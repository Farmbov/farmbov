/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// import {onRequest} from "firebase-functions/v2/https";
// import * as logger from "firebase-functions/logger";

// functions/src/index.ts
import * as farmStats from './modules/update-stats';

// Exporte todas as funções
// export const backfillFarmStats = farmStats.backfillFarmStats;
export const updateEntryStats = farmStats.updateEntryStats;
export const updateExitStats = farmStats.updateExitStats;
export const updateCountByAnimalsSex = farmStats.updateCountByAnimalsSex;

// Caso seja necessário refazer farm_statistics
// export const backfillFarmStatistics = farmStats.backfillFarmStatistics;