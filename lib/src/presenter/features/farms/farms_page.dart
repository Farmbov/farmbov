import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/farm_model.dart';
import 'package:farmbov/src/presenter/features/farms/farms_page_store.dart';
import 'package:farmbov/src/presenter/shared/components/shared_label.dart';
import 'package:farmbov/src/presenter/shared/pages/generic_page/generic_page_mixin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/common/themes/farm_bov_icons.dart';
import 'package:farmbov/src/presenter/shared/components/generic_card_tile.dart';
import 'package:farmbov/src/presenter/shared/components/generic_card_tile_item.dart';
import 'package:farmbov/src/presenter/shared/components/generic_page_content.dart';
import 'package:farmbov/src/presenter/shared/components/no_content_page.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../common/helpers/strings_helpers.dart';
import '../../../common/providers/app_manager.dart';
import '../../../common/router/route_name.dart';
import '../../../domain/models/global_farm_model.dart';
import '../../../domain/services/domain/animal_data_service.dart';

final animalService = AnimalDataService();

class FarmsPage extends StatefulWidget {
  final FarmsPageStore store;

  const FarmsPage({super.key, required this.store});

  @override
  FarmsPageState createState() => FarmsPageState();
}

class FarmsPageState extends State<FarmsPage> with GenericPageMixin {
  @override
  FarmsPageStore get baseStore => widget.store;

  @override
  Widget get web => _buildContent(context);

  @override
  Widget get mobile => _buildContent(context);

  @override
  String get title => 'Minhas fazendas';

  @override
  bool get allowBackButton => false;

  @override
  Widget get noContentPage => NoContentPage(
        title: 'Nenhuma fazenda cadastrada',
        description: 'Você ainda não cadastrou nenhuma fazenda.',
        actionTitle: 'Cadastrar fazenda',
        action: () => widget.store.updateFarmModal(context),
      );

  Widget _buildContent(BuildContext context) {
    return ValueListenableBuilder<GlobalFarmModel?>(
        valueListenable: AppManager.instance.currentFarmNotifier,
        builder: (context, globalFarmModel, child) {
          return FutureBuilder<List<FarmModel>>(
            future: widget.store.getFarms(),
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
                title: 'Minhas fazendas',
                actionTitle: 'Adicionar fazenda',
                actionButton: () => baseStore.updateFarmModal(context),
                loading: !snapshot.hasData,
                showBackButton: false,
                children: modelList.map(
                  (farm) {
                    final isShared =
                        farm.ownerId != FirebaseAuth.instance.currentUser?.uid;
                    return FutureBuilder<AggregateQuerySnapshot>(
                        //TODO: colocar essas chamadas dentro de um repository
                        future: FirebaseFirestore.instance
                            .collection('farms')
                            .doc(farm.ffRef?.id)
                            .collection('animals')
                            .where('active', isEqualTo: true)
                            .count()
                            .get(),
                        builder: ((context, snapshot) {
                          int? qtdAnimals = snapshot.data?.count;

                          return GenericCardTile(
                            title: farm.name,
                            extraTitleWidget:
                                isShared ? const SharedLabel() : null,
                            customActions: isShared
                                ? null
                                : [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.share,
                                        size: 20,
                                        color: AppColors.primaryGreen,
                                      ),
                                      tooltip: 'Compartilhar Fazenda',
                                      visualDensity:
                                          const VisualDensity(vertical: -3),
                                      onPressed: () =>
                                          widget.store.shareFarm(context, farm),
                                      splashRadius: 20,
                                    ),
                                    IconButton(
                                      tooltip: 'Usuários compartilhados',
                                      icon: const Icon(
                                        Icons.people_alt_rounded,
                                        size: 20,
                                        color: AppColors.primaryGreen,
                                      ),
                                      visualDensity:
                                          const VisualDensity(vertical: -3),
                                      onPressed: () {
                                        widget.store.sharedUsers(context, farm);
                                      },
                                      splashRadius: 20,
                                    ),
                                    MenuAnchor(
                                      style: const MenuStyle(
                                        elevation:
                                            MaterialStatePropertyAll<double>(
                                                0.1),
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                AppColors.primaryGreen),
                                      ),
                                      builder: (BuildContext context,
                                          MenuController controller,
                                          Widget? child) {
                                        return IconButton(
                                          onPressed: () {
                                            if (controller.isOpen) {
                                              controller.close();
                                            } else {
                                              controller.open();
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.widgets,
                                            color: AppColors.primaryGreen,
                                            size: 20,
                                          ),
                                          tooltip: 'Outras Páginas',
                                        );
                                      },
                                      menuChildren: [
                                        MenuItemButton(
                                            child: TextButton.icon(
                                                onPressed: () {
                                                  GoRouter.of(context)
                                                      .pushNamed(
                                                          RouteName.settings);
                                                },
                                                icon: const Icon(
                                                  Icons.settings,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                label: const Text(
                                                  'Configurações',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))),
                                        MenuItemButton(
                                            child: TextButton.icon(
                                                onPressed: () {
                                                  GoRouter.of(context)
                                                      .pushNamed(
                                                          RouteName.areas);
                                                },
                                                icon: const Icon(
                                                  Icons.map,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                label: const Text(
                                                  'Áreas',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))),
                                        MenuItemButton(
                                            child: TextButton.icon(
                                                onPressed: () {
                                                  GoRouter.of(context)
                                                      .pushNamed(
                                                          RouteName.lots);
                                                },
                                                icon: const Icon(
                                                  FarmBovIcons.dotsGrid,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                label: const Text(
                                                  'Lotes',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))),
                                      ],
                                    )
                                  ],
                            updateAction: () => widget.store
                                .updateFarmModal(context, model: farm),
                            //TODO: Ainda está sendo debatido sobre essa questão de deleção de fazendas
                            // deleteAction: isShared
                            //     ? null
                            //     : () => widget.store
                            //         .deleteFarmModal(context, model: farm),
                            items: [
                              GenericCardTileItem(
                                title:
                                    "${NumberFormat.decimalPattern("pt-BR").format(farm.area)} ha",
                                icon: Icons.zoom_out_map_outlined,
                              ),
                              GenericCardTileItem(
                                icon: FarmBovIcons.cow,
                                title: StringHelpers.animalsAmountLabel(
                                    qtdAnimals ?? 0),
                              ),
                              GenericCardTileItem(
                                icon: Icons.location_pin,
                                title:
                                    '${farm.latitude} lat, ${farm.longitude} long',
                              ),
                            ],
                          );
                        }));
                  },
                ).toList(),
              );
            },
          );
        });
  }
}
