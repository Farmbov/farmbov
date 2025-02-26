import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/shared/pages/generic_page/generic_page_mixin.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/common/themes/farm_bov_icons.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/lot_model.dart';
import 'package:farmbov/src/presenter/shared/components/generic_card_tile.dart';
import 'package:farmbov/src/presenter/shared/components/generic_card_tile_item.dart';
import 'package:farmbov/src/presenter/shared/components/generic_page_content.dart';
import 'package:farmbov/src/presenter/shared/components/no_content_page.dart';
import 'package:farmbov/src/presenter/features/lots/lots_page_store.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../common/providers/app_manager.dart';
import '../../../domain/models/global_farm_model.dart';
import '../../shared/modals/base_alert_modal.dart';

class LotsPage extends StatefulWidget {
  final LotsPageStore store;

  const LotsPage({super.key, required this.store});

  @override
  LotsPageState createState() => LotsPageState();
}

class LotsPageState extends State<LotsPage> with GenericPageMixin {
  @override
  LotsPageStore get baseStore => widget.store;

  @override
  Widget get web => _buildContent(context);

  @override
  Widget get mobile => _buildContent(context);

  @override
  String get title => 'Lotes de animais';

  @override
  bool get allowBackButton => true;

  @override
  Widget get noContentPage => NoContentPage(
        title: 'Nenhum lote cadastrado',
        description: 'Você ainda não cadastrou nenhum lote.',
        actionTitle: 'Cadastrar lote',
        action: () => widget.store.updateLoteModal(context),
      );

  Widget _buildContent(BuildContext context) {
    return ValueListenableBuilder<GlobalFarmModel?>(
        valueListenable: AppManager.instance.currentFarmNotifier,
        builder: (context, globalFarmModel, child) {
          return FutureBuilder<List<LotModel>>(
            future: queryLotModelOnce(
              queryBuilder: (model) => model.where('active', isEqualTo: true),
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  ),
                );
              }
              final modelList = snapshot.data;

              if (modelList == null || modelList.isEmpty) return noContentPage;

              return GenericPageContent(
                title: 'Meus lotes',
                actionTitle: 'Adicionar lote',
                actionButton: () => baseStore.updateLoteModal(context),
                showBackButton:
                    ResponsiveBreakpoints.of(context).isDesktop ? false : true,
                onBackButtonPressed: ResponsiveBreakpoints.of(context).isDesktop
                    ? null
                    : () {
                        //Lida com a navegação de subpáginas dentro do botão "Outras Páginas"
                        final shell = StatefulNavigationShell.of(context);
                        shell.goBranch(4, initialLocation: true);
                      },
                loading: !snapshot.hasData,
                children: modelList.map((lot) {
                  final animalsCapacity = NumberFormat.decimalPattern("pt-BR")
                      .format(lot.animalsCapacity);

                  return FutureBuilder(
                      future: widget.store.getAnimalsCountByLot(lot.name!),
                      builder: (_, animalsCount) {
                        if (animalsCount.connectionState !=
                            ConnectionState.done) {
                          return const SizedBox.shrink();
                        }

                        final animalsAmount = animalsCount.data == null
                            ? 0
                            : NumberFormat.decimalPattern("pt-BR")
                                .format(animalsCount.data);

                        return GenericCardTile(
                          title: lot.name,
                          customActions: [
                            IconButton(
                              icon: const Icon(
                                FarmBovIcons.cow,
                                size: 20,
                                color: AppColors.primaryGreen,
                              ),
                              visualDensity: const VisualDensity(vertical: -3),
                              onPressed: () =>
                                  widget.store.showAnimals(context, lot),
                              splashRadius: 20,
                              tooltip: 'Visualizar animais',
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.move_down_rounded,
                                size: 20,
                                color: AppColors.primaryGreen,
                              ),
                              visualDensity: const VisualDensity(vertical: -3),
                              onPressed: () => showTransferAnimalsModal(
                                  context: context, currentLotName: lot.name!),
                              splashRadius: 20,
                              tooltip: 'Transferir Animais',
                            ),
                          ],
                          updateAction: () =>
                              widget.store.updateLoteModal(context, model: lot),
                          deleteAction: () =>
                              widget.store.deleteLoteModal(context, model: lot),
                          items: [
                            GenericCardTileItem(
                              icon: FarmBovIcons.map,
                              title: 'Área: ${lot.area}',
                            ),
                            GenericCardTileItem(
                              icon: FarmBovIcons.cow,
                              title: 'Total de '
                                  '$animalsAmount ${animalsAmount == '1' ? 'animal' : 'animais'}',
                            ),
                            GenericCardTileItem(
                              icon: FarmBovIcons.cow,
                              title: 'Capacidade de '
                                  '$animalsCapacity ${animalsCapacity == '1' ? 'animal' : 'animais'}',
                            ),
                          ],
                          otherItems: [
                            GenericCardTileItem(
                              leadingText: 'Observação',
                              title: lot.notes,
                            ),
                          ],
                        );
                      });
                }).toList(),
              );
            },
          );
        });
  }

  Future<void> _transferAnimals(
      {required String currentFarm,
      required String currentLotName,
      required String selectedLotName}) async {
    // Coleta animais do lote atual
    final animalsSnapshot = await FirebaseFirestore.instance
        .collection('farms')
        .doc(currentFarm)
        .collection('animals')
        .where('lot', isEqualTo: currentLotName) // Use o ID do lote atual
        .get();

    // Atualize o lote de cada animal
    final batch = FirebaseFirestore.instance.batch();
    for (var animalDoc in animalsSnapshot.docs) {
      batch.update(animalDoc.reference, {'lot': selectedLotName});
    }

    // Execute a operação em lote
    await batch.commit();
  }

  void showTransferAnimalsModal({
    required BuildContext context,
    required String currentLotName,
  }) {
    final currentFarm = Provider.of<AppManager>(context, listen: false)
        .currentUser
        .currentFarm
        ?.id;

    String? selectedLotName;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          titleTextStyle: const TextStyle(color: AppColors.primaryGreen),
          title: Text(
            'Transferir Animais',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontSize: 20, color: AppColors.primaryGreen),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selecione o novo lote para transferir os animais:',
                style: TextStyle(fontSize: 16),
              ),
              TransferLotDropdown(
                currentFarm: currentFarm!,
                currentLot: currentLotName,
                onLotSelected: (value) {
                  selectedLotName = value; // Atualiza o lote selecionado
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (selectedLotName != null) {
                  await _transferAnimals(
                    currentFarm: currentFarm,
                    currentLotName: currentLotName,
                    selectedLotName: selectedLotName!,
                  );
                  setState(() {});
                  Navigator.of(context).pop(); // Fecha o modal
                  showDialog(
                    context: context,
                    builder: (_) => const BaseAlertModal(
                      showCancel: false,
                      title: 'Transferência realizada com sucesso!',
                    ),
                  );
                }
              },
              child: const Text(
                'Transferir',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: AppColors.errorColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

class TransferLotDropdown extends StatefulWidget {
  final String currentFarm;
  final String currentLot;
  final ValueChanged<String> onLotSelected;

  const TransferLotDropdown({
    super.key,
    required this.currentFarm,
    required this.currentLot,
    required this.onLotSelected,
  });

  @override
  _TransferLotDropdownState createState() => _TransferLotDropdownState();
}

class _TransferLotDropdownState extends State<TransferLotDropdown> {
  String? selectedLotName;

  Future<List<LotModel>> _fetchAvailableLots(
      {required BuildContext context,
      required String currentFarm,
      required currentLot}) async {
    final lotsSnapshot = await FirebaseFirestore.instance
        .collection('farms')
        .doc(currentFarm)
        .collection('lots')
        .where('name', isNotEqualTo: currentLot)
        .get();

    return lotsSnapshot.docs.map((doc) {
      return LotModel.getDocumentFromData(doc.data(), reference: doc.reference);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LotModel>>(
      future: _fetchAvailableLots(
        context: context,
        currentFarm: widget.currentFarm,
        currentLot: widget.currentLot,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final lots = snapshot.data!;

        return SizedBox(
          child: DropdownButton<String>(
            value: selectedLotName,
            hint: const Text(
              'Selecione um lote',
              style: TextStyle(fontSize: 16),
            ),
            onChanged: (value) {
              setState(() {
                selectedLotName = value; // Atualiza o lote selecionado
              });
              widget.onLotSelected(value!); // Notifica a seleção
            },
            items: lots.map((lot) {
              return DropdownMenuItem<String>(
                value: lot.name, // Use o ID do lote
                child: Text(lot.name ?? 'Lote Desconhecido'),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
