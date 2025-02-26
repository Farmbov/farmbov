import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();
const db = admin.firestore();

interface MonthStats {
    entries: number;
    exits: number;
}

// Inicializa um objeto (mapa) com 12 meses
const initializeMonths = (): { [key: number]: MonthStats } => {
    const months: { [key: number]: MonthStats } = {};
    for (let i = 0; i < 12; i++) {
        months[i] = { entries: 0, exits: 0 };
    }
    return months;
};

export const updateEntryStats = functions
    .region('southamerica-east1')
    .firestore
    .document('farms/{farmId}/animals/{animalId}')
    .onCreate(async (snap, context) => {
        return handleStatsUpdate(snap, context, 'entries');
    });

export const updateExitStats = functions
    .region('southamerica-east1')
    .firestore
    .document('farms/{farmId}/animals_down/{downId}')
    .onCreate(async (snap, context) => {
        return handleStatsUpdate(snap, context, 'exits');
    });




async function handleStatsUpdate(
    snap: FirebaseFirestore.DocumentSnapshot,
    context: functions.EventContext,
    field: 'entries' | 'exits'
): Promise<void> {
    const farmId = context.params.farmId;
    const dateField = field === 'entries' ? 'entry_date' : 'down_date';
    const date = snap.get(dateField)?.toDate();

    if (!date) {
        functions.logger.error(`Documento sem data de ${field}`, {
            documentId: snap.id,
            farmId
        });
        return;
    }

    try {
        await updateStats(farmId, date, field, 1);
        functions.logger.log(`${field} atualizados para ${farmId}`, { date });
    } catch (error) {
        functions.logger.error(`Erro em ${field}:`, error);
        throw error;
    }
}

async function updateStats(
    farmId: string,
    date: Date,
    field: 'entries' | 'exits',
    increment: number
): Promise<void> {
    const year = date.getFullYear();
    const month = date.getMonth();
    const statsRef = db.doc(`farms/${farmId}/farm_statistics/entry_exit`);
    const yearRef = statsRef.collection('years').doc(year.toString());

    await db.runTransaction(async (transaction) => {
        const yearDoc = await transaction.get(yearRef);

        // Se o ano não existe, cria com meses inicializados
        if (!yearDoc.exists) {
            transaction.create(yearRef, {
                months: initializeMonths() // Mapa com chaves 0-11
            });
            transaction.set(
                statsRef,
                { available_years: admin.firestore.FieldValue.arrayUnion(year) },
                { merge: true }
            );
        }

        // Atualiza apenas o campo desejado
        transaction.update(yearRef, {
            [`months.${month}.${field}`]: admin.firestore.FieldValue.increment(increment)
        });
    });
}





export const updateCountByAnimalsSex = functions.firestore
    .document('farms/{farmId}/animals/{animalId}')
    .onWrite(async (change, context) => {
        const farmId = context.params.farmId;
        const statsRef = db.doc(`farms/${farmId}/farm_statistics/animal_counts`);

        const updateData: { [key: string]: admin.firestore.FieldValue } = {};

        if (change.after.exists) {
            const newData = change.after.data();
            if (newData?.active && newData?.sex) {
                updateData[`${newData.sex}.active`] = admin.firestore.FieldValue.increment(1);
            }
        }

        if (change.before.exists) {
            const oldData = change.before.data();
            if (oldData?.active && oldData?.sex) {
                updateData[`${oldData.sex}.active`] = admin.firestore.FieldValue.increment(-1);
            }
        }

        await statsRef.set(updateData, { merge: true });
    });



// Function para atualizar as fazendas que já possuem dados de animais, manter aqui caso por algum motivo as outras functions falharem e
// ser necessário refazer a farm_statistics, alterar timeoutSeconds de acordo com a necessidade, quanto mais animais numa fazenda mais demorado o processo

// export const backfillFarmStatistics = functions
//     .region('southamerica-east1')
//     .runWith({ timeoutSeconds: 540 })
//     .https.onRequest(async (req, res) => {
//         try {
//             // 1. Iterar por todas as fazendas
//             const farmsSnapshot = await db.collection('farms').get();

//             for (const farmDoc of farmsSnapshot.docs) {
//                 const farmId = farmDoc.id;

//                 // 2. Processar animais (entradas)
//                 await processCollection(
//                     farmId,
//                     'animals',
//                     'entry_date',
//                     'entries'
//                 );

//                 // 3. Processar baixas (saídas)
//                 await processCollection(
//                     farmId,
//                     'animals_down',
//                     'down_date',
//                     'exits'
//                 );
//             }

//             res.status(200).send('Backfill completo com sucesso!');
//         } catch (error) {
//             functions.logger.error('Erro no backfill:', error);
//             res.status(500).send('Erro durante o backfill');
//         }
//     });

// async function processCollection(
//     farmId: string,
//     collection: 'animals' | 'animals_down',
//     dateField: string,
//     field: 'entries' | 'exits'
// ) {
//     let query = db.collection(`farms/${farmId}/${collection}`) as admin.firestore.Query;

//     // Paginação para grandes coleções
//     while (true) {
//         const snapshot = await query.limit(300).get();
//         if (snapshot.empty) break;

//         // Processar lote atual
//         await Promise.all(snapshot.docs.map(async (doc) => {
//             const date = doc.get(dateField)?.toDate();
//             if (!date) return;

//             try {
//                 await updateStats(farmId, date, field, 1);
//             } catch (error) {
//                 functions.logger.error(`Erro ao processar ${doc.id}:`, error);
//             }
//         }));

//         // Próximo lote
//         const lastDoc = snapshot.docs[snapshot.docs.length - 1];
//         query = query.startAfter(lastDoc);
//     }
// }

// End backfillFarmStatistics
