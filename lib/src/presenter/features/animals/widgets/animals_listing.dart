import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/services/domain/animal_data_service.dart';
import 'package:farmbov/src/presenter/shared/components/no_content_page.dart';
import 'package:intl/intl.dart';
import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';
import 'package:farmbov/src/presenter/features/home/widgets/generic_table_item.dart';
import 'package:farmbov/src/presenter/features/home/widgets/generic_table_item_action.dart';
import 'package:farmbov/src/presenter/shared/components/animal_situation_label.dart';
import 'package:flutter/material.dart';

final animalDataService = AnimalDataService();

class AnimalsListing extends StatefulWidget {
  final String? searchQuery;
  final String? lotNameFilter;
  final bool showDownAnimals;
  final void Function(AnimalModel animal)? deleteAction;
  final bool showActionButtons;

  const AnimalsListing({
    super.key,
    this.searchQuery,
    this.lotNameFilter,
    this.showDownAnimals = false,
    this.deleteAction,
    this.showActionButtons = true,
  });

  @override
  State<AnimalsListing> createState() => _AnimalsListingState();
}

class _AnimalsListingState extends State<AnimalsListing> {
  List<AnimalModel> animals = [];
  DocumentSnapshot? startAfter;
  Future<List<AnimalModel>>? _dataAnimalsFuture;
  bool _hasMore = true;

  Future<List<AnimalModel>> _loadAnimals() async {
    final resultAnimals = await animalDataService.listAnimals(
        isActive: !widget.showDownAnimals,
        limit: 10,
        startAfter: startAfter,
        lotName: widget.lotNameFilter);

    setState(() {
      if (resultAnimals.length != 10) {
        _hasMore = false;
      }
      animals.addAll(resultAnimals);
    });
    startAfter = await resultAnimals.last.ffRef?.get();

    return animals;
  }

  @override
  void initState() {
    super.initState();
    _dataAnimalsFuture = _loadAnimals();
  }

  Widget animalsTable(BuildContext context, {List<TableRow>? items}) {
    return Table(
      // columnWidths: {
      //   0: FlexColumnWidth(
      //       ResponsiveBreakpoints.of(context).isMobile ? 0.7 : 1),
      //   1: FlexColumnWidth(
      //       ResponsiveBreakpoints.of(context).isMobile ? 0.5 : 0.7),
      //   2: FlexColumnWidth(
      //       ResponsiveBreakpoints.of(context).isMobile ? 0.5 : 0.7),
      //   3: FlexColumnWidth(
      //     ResponsiveBreakpoints.of(context).isMobile ? 1 : 1,
      //   ),
      // },
      children: [
        TableRow(
          decoration: const BoxDecoration(
            color: Color(0xFFFAFAF9),
          ),
          children: [
            const GenericTableItem(
              text: "Nº Brinco",
              header: true,
            ),
            const GenericTableItem(
              text: "Lote",
              header: true,
              textAlign: TextAlign.center,
            ),
            const GenericTableItem(
              text: "Nasc",
              header: true,
              textAlign: TextAlign.center,
            ),
            const GenericTableItem(
              text: "Situação",
              header: true,
              textAlign: TextAlign.center,
            ),
            if (widget.showActionButtons) ...[
              const GenericTableItem(
                text: "Ação",
                header: true,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
        ...items ?? [],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AnimalModel>>(
      future: _dataAnimalsFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(
              child: CircularProgressIndicator(),
            );

          case ConnectionState.done:
            final animalList = snapshot.data;

            if (animalList == null || animalList.isEmpty) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.grey[700]),
                  const SizedBox(width: 8),
                  Text(
                    'Nenhum animal encontrado.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              );
            }

            if (!snapshot.hasData) {
              return const NoContentPage();
            }

            return Column(
              children: [
                animalsTable(
                  context,
                  items: animalList
                      .map(
                        (animal) => TableRow(
                          children: [
                            GenericTableItem(
                              text: animal.tagNumber,
                              fontSize: 12,
                              goToAnimalDetails: true,
                              animal: animal,
                            ),
                            GenericTableItem(
                              text: animal.lot,
                              fontSize: 12,
                              animal: animal,
                            ),
                            GenericTableItem(
                              text: animal.birthDate == null
                                  ? '-'
                                  : DateFormat('dd/MM/yyyy').format(
                                      animal.birthDate!,
                                    ),
                              fontSize: 12,
                            ),
                            GenericTableItem(
                              fontSize: 12,
                              alignment: Alignment.center,
                              child:
                                  AnimalSituationLabel(active: animal.active),
                            ),
                            if (widget.showActionButtons) ...[
                              GenericTableItem(
                                alignment: Alignment.center,
                                child: animal.active
                                    ? GenericTableItemAction(
                                        id: animal.ffRef?.id ?? "-1",
                                        detailsAction: () =>
                                            context.goNamedAuth(
                                          RouteName.animalVisualize,
                                          params: {
                                            "id": animal.ffRef?.id ?? "-1"
                                          },
                                          extra: {"model": animal},
                                        ),
                                        editAction: () => context.goNamedAuth(
                                          RouteName.animalUpdate,
                                          params: {
                                            "id": animal.ffRef?.id ?? "-1"
                                          },
                                          extra: {"model": animal},
                                        ),
                                        deleteAction: () =>
                                            widget.deleteAction?.call(animal),
                                      )
                                    : const Text('-'),
                              ),
                            ],
                          ],
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                _hasMore
                    ? ElevatedButton(
                        onPressed: () => _loadAnimals(),
                        child: const Text(
                          "Carregar Mais ...",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : const SizedBox()
              ],
            );
        }
      },
    );
  }
}
