import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/domain/models/vaccine_model.dart';
import 'package:farmbov/src/presenter/features/settings/vaccines/vaccines_configuration_page_store.dart';
import 'package:farmbov/src/presenter/features/vaccines/vaccines_page_store.dart';
import 'package:farmbov/src/presenter/shared/components/generic_page_content.dart';
import 'package:farmbov/src/presenter/shared/components/no_content_page.dart';
import 'package:farmbov/src/presenter/shared/pages/generic_page/generic_page_mixin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:farmbov/src/presenter/shared/components/generic_card_tile.dart';
import 'package:farmbov/src/presenter/shared/components/generic_card_tile_item.dart';

import '../../../common/themes/theme_constants.dart';
import '../../../domain/models/drug_administration_type.dart';
import '../../../domain/models/global_farm_model.dart';

class VaccinesPage extends StatefulWidget {
  final VaccinesPageStore store;

  const VaccinesPage({super.key, required this.store});

  @override
  VaccinesPageState createState() => VaccinesPageState();
}

class VaccinesPageState extends State<VaccinesPage> with GenericPageMixin {
  final VaccinesConfigurationPageStore _vaccinesConfigurationStore =
      VaccinesConfigurationPageStore();

  @override
  VaccinesPageStore get baseStore => widget.store;

  @override
  Widget get web => _buildContent(context);

  @override
  Widget get mobile => _buildContent(context);

  @override
  String get title => 'Configurações de Vacinas';

  @override
  bool get allowBackButton => false;

  @override
  Widget get noContentPage => NoContentPage(
        title: 'Nenhuma vacina cadastrada',
        description: 'Você ainda não cadastrou nenhuma vacina.',
        actionTitle: 'Adicionar vacina',
        action: () => widget.store.updateVacinaModal(context),
      );

  Widget _buildWeb(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _buildListing(context),
        ),
        SizedBox(width: Adaptive.px(40)),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return GenericPageContent(
      title: 'Minhas vacinas',
      useGridRows: false,
      showBackButton: false,
      actionTitle: 'Aplicar Vacina',
      actionButton: () {
        context.push(RouteName.vaccineLot);
      },
      onBackButtonPressed: () => context.goNamedAuth(RouteName.home),
      children: [
        ResponsiveBreakpoints.of(context).isMobile
            ? _buildMobile(context)
            : _buildWeb(context)
      ],
    );
  }

  Widget _buildListing(BuildContext context) {
    return FutureBuilder<List<VaccineModel>>(
      future: widget.store.vaccineService.listVaccines(),
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

        return Column(
          children: [
            ...modelList.map(
              (VaccineModel vacina) {
                return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('farms')
                        .doc(AppManager.instance.currentUser.currentFarm?.id!)
                        .collection('drug_administration_types')
                        .doc(vacina.drugAdministrationType)
                        .get()
                        .then((type) {
                      return DrugAdministrationType.fromMap(
                          type.data()!, type.reference);
                    }),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData &&
                          (snapshot.connectionState == ConnectionState.none ||
                              snapshot.connectionState ==
                                  ConnectionState.waiting)) {
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

                      DrugAdministrationType? admTypeVaccine = snapshot.data;

                      return GenericCardTile(
                        title: vacina.name,
                        //TODO: Faz sentido ter actions das vacinas nessa tela?
                        // updateAction: () {
                        //   // TODO: a store dessa página deve guardar os dados das vacinas para então poder atualizar-- Só está atualizando no firebase
                        //   showDialog(
                        //       context: context,
                        //       builder: (context) => VaccineModal(
                        //             store: _vaccinesConfigurationStore,
                        //             vaccine: vacina,
                        //           ));
                        // },
                        // deleteAction: () {
                        //   //TODO:delete vaccine na tela de vacinas
                        // },
                        customActions: [
                          TextButton(
                              onPressed: () => {
                                    context.goNamed(
                                      'vacinaLotes',
                                      pathParameters: {
                                        'vaccine_name': vacina.name!
                                            .replaceAll(' ', '-')
                                            .toLowerCase()
                                      },
                                      extra: vacina,
                                    )
                                  },
                              child: const Text('Ver Lotes'))
                        ],
                        items: [
                          GenericCardTileItem(
                            leadingText: "Quantidade em estoque",
                            title: '${vacina.quantity ?? 0}',
                          ),
                          GenericCardTileItem(
                            leadingText: 'Doses Necessárias',
                            title: vacina.dosesRequired == null
                                ? '-'
                                : vacina.dosesRequired.toString(),
                          ),
                          GenericCardTileItem(
                            leadingText: 'Intervalo entre aplicações',
                            title: vacina.intervalBetweenDosesInDays == null
                                ? '-'
                                : vacina.intervalBetweenDosesInDays! < 1
                                    ? "Não aplicavel"
                                    : vacina.intervalBetweenDosesInDays
                                        .toString(),
                          ),
                          GenericCardTileItem(
                              leadingText: 'Via de Administração',
                              title: vacina.drugAdministrationType == null
                                  ? '-'
                                  : admTypeVaccine?.name),
                          GenericCardTileItem(
                            leadingText: 'Condições de Armazenamento:',
                            title: vacina.storageConditions ?? '-',
                          ),
                          GenericCardTileItem(
                            leadingText: 'Descrição',
                            title: vacina.description ?? '-',
                          ),
                        ],
                      );
                    });
              },
            ),
            // if (ResponsiveBreakpoints.of(context).isMobile) ...[
            //   Align(
            //     alignment: Alignment.centerRight,
            //     child: FFSectionButton(
            //       title: 'Cadastrar vacina',
            //       icon: Icons.add,
            //       width: 175,
            //       onPressed: () => widget.store.updateVacinaModal(context),
            //     ),
            //   ),
            // ],
          ],
        );
      },
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      children: [
        _buildListing(context),
        const Divider(
          height: 48,
          thickness: 1,
          color: Color(0xFFD7D3D0),
        ),
        // const VaccinesLotTableSection(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) =>  ValueListenableBuilder<GlobalFarmModel?>(
        valueListenable: AppManager.instance.currentFarmNotifier,
        builder: (context, globalFarmModel, child) {
      return _buildContent(context);
    }
  );
}
