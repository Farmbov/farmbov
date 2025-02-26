import 'package:collection/collection.dart';
import 'package:farmbov/src/presenter/features/areas/lots_area/lots_area_page.dart';
import 'package:farmbov/src/presenter/features/lots/lots_page_store.dart';
import 'package:farmbov/src/presenter/shared/pages/generic_page/generic_stack_page.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:farmbov/src/domain/constants/area_usage_type.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/common/themes/farm_bov_icons.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/area_model.dart';
import 'package:farmbov/src/presenter/features/areas/areas_page_store.dart';
import 'package:farmbov/src/presenter/shared/pages/generic_page/generic_page_mixin.dart';
import 'package:farmbov/src/presenter/shared/components/generic_card_tile.dart';
import 'package:farmbov/src/presenter/shared/components/generic_card_tile_item.dart';
import 'package:farmbov/src/presenter/shared/components/generic_page_content.dart';
import 'package:farmbov/src/presenter/shared/components/no_content_page.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../common/providers/app_manager.dart';
import '../../../domain/models/global_farm_model.dart';

class AreasPage extends StatefulWidget {
  final AreasPageStore store;

  const AreasPage({super.key, required this.store});

  @override
  AreasPageState createState() => AreasPageState();
}

class AreasPageState extends State<AreasPage> with GenericPageMixin {
  @override
  AreasPageStore get baseStore => widget.store;

  @override
  Widget get web => _buildContent(context);

  @override
  Widget get mobile => _buildContent(context);

  @override
  String get title => 'Área';

  @override
  bool get allowBackButton => true;

  @override
  Widget get noContentPage => NoContentPage(
        title: 'Nenhuma área cadastrada',
        description: 'Você ainda não cadastrou nenhuma área.',
        actionTitle: 'Adicionar área',
        action: () => widget.store.updateAreaModal(context),
      );

  Widget _buildContent(BuildContext context) {
    return ValueListenableBuilder<GlobalFarmModel?>(
        valueListenable: AppManager.instance.currentFarmNotifier,
        builder: (context, globalFarmModel, child) {
          return GenericStackPage(
            child: Observer(builder: (context) {
              return StreamBuilder<List<AreaModel>>(
                stream: queryAreaModel(
                  queryBuilder: (model) =>
                      model.where('active', isEqualTo: true),
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

                  if (modelList == null || modelList.isEmpty) {
                    return noContentPage;
                  }

                  return GenericPageContent(
                    title: 'Minhas áreas',
                    actionTitle: 'Adicionar área',
                    actionButton: () => baseStore.updateAreaModal(context),
                    showBackButton: ResponsiveBreakpoints.of(context).isDesktop
                        ? false
                        : true,
                    onBackButtonPressed: ResponsiveBreakpoints.of(context)
                            .isDesktop
                        ? null
                        : () {
                            //Lida com a navegação de subpáginas dentro do botão "Outras Páginas"
                            final shell = StatefulNavigationShell.of(context);
                            shell.goBranch(4, initialLocation: true);
                          },
                    children: modelList
                        .map(
                          (area) => FutureBuilder(
                            future: widget.store.getAnimalsCountByLotArea(
                                area.name ?? 'unknown'),
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
                                title: area.name,
                                customActions: [
                                  IconButton(
                                      onPressed: () {
                                        //TODO: Criar Rota no goRouter... não foi criado pois as rotas em area estão como genéricas, eu poderia quebrar algo
                                        Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                                reverseTransitionDuration:
                                                    const Duration(seconds: 0),
                                                transitionDuration:
                                                    const Duration(seconds: 0),
                                                transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) {
                                                  return FadeTransition(
                                                    opacity: animation,
                                                    child: child,
                                                  );
                                                },
                                                pageBuilder: (context,
                                                    animation,
                                                    secondaryAnimation) {
                                                  return LotsAreaPage(
                                                    store: LotsPageStore(),
                                                    areaName: area.name!,
                                                  );
                                                }));
                                      },
                                      icon: const Icon(
                                        FarmBovIcons.dotsGrid,
                                        color: AppColors.primaryGreen,
                                        size: 20,
                                      )),
                                ],
                                updateAction: () => baseStore
                                    .updateAreaModal(context, model: area),
                                deleteAction: () => baseStore
                                    .deleteAreaModal(context, model: area),
                                items: [
                                  GenericCardTileItem(
                                    icon: Icons.zoom_out_map_outlined,
                                    title:
                                        "${NumberFormat.decimalPattern("pt-BR").format(area.totalArea)} ha",
                                  ),
                                  GenericCardTileItem(
                                    icon: FarmBovIcons.cow,
                                    title: "$animalsAmount de "
                                        "${NumberFormat.decimalPattern("pt-BR").format(area.totalCapacity)}"
                                        " animais alocados",
                                  ),
                                ],
                                otherItems: [
                                  GenericCardTileItem(
                                    leadingText: 'Tipo de uso ',
                                    titleContent: Text(
                                      defaultAreaUsageTypes
                                              .firstWhereOrNull((a) =>
                                                  a.name == area.usageType)
                                              ?.name ??
                                          '-',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontSize: 12,
                                            color: AppColors.neutralGray,
                                            fontWeight: FontWeight.normal,
                                          ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  GenericCardTileItem(
                                    leadingText: 'Observação',
                                    title: area.notes ?? '-',
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                        .toList(),
                  );
                },
              );
            }),
          );
        });
  }
}
