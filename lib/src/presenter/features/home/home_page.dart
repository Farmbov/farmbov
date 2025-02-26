import 'dart:async';

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/models/global_farm_model.dart';
import 'package:farmbov/src/presenter/features/animal_handlings/handlings_page/handlings_page.dart';
import 'package:farmbov/src/presenter/shared/components/user_circle_avatar.dart';
import 'package:farmbov/src/presenter/shared/pages/generic_page/generic_stack_page.dart';
import 'package:farmbov/src/presenter/shared/pages/global_navigation/global_farm_select.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:farmbov/src/common/helpers/strings_helpers.dart';
import 'package:farmbov/src/presenter/features/animals/animals_page_store.dart';
import 'package:farmbov/src/presenter/features/home/widgets/vaccines_table_section.dart';
import 'package:farmbov/src/presenter/features/search_animal/search_animal_widget.dart';
import 'package:farmbov/src/presenter/shared/components/page_title_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/common/themes/farm_bov_icons.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/farm_model.dart';
import 'package:farmbov/src/presenter/features/dashboard/widgets/animals_ups_downs_chart.dart';
import 'package:farmbov/src/presenter/shared/components/generic_card_tile.dart';
import 'package:farmbov/src/presenter/shared/components/generic_card_tile_item.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/features/home/widgets/home_section_details.dart';
import 'package:farmbov/src/presenter/features/home/widgets/section_action_button.dart';
import 'package:farmbov/src/presenter/features/home/home_page_store.dart';
import 'package:farmbov/src/common/router/route_name.dart';

import '../../../domain/constants/animal_handling_types.dart';
import '../../../domain/models/firestore/animal_model.dart';
import '../../shared/components/ff_button.dart';
import '../../shared/modals/base_modal_bottom_sheet.dart';
import '../animal_handlings/animal_handling_update/animal_handling_update_page_store.dart';

class HomePage extends StatefulWidget {
  final HomePageStore store;

  const HomePage({super.key, required this.store});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _searchOnHandlingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.store.init(context);
  }

  @override
  void dispose() {
    widget.store.dispose();
    _searchController.dispose();
    _searchOnHandlingController.dispose();
    super.dispose();
  }

  List<Widget> _animalsSection() {
    return [
      SearchAnimalWidget(
        searchController: _searchController,
      ),
      // Row(
      //   children: [
      //     InkWell(
      //       onTap: () =>
      //           NavBarPage.of(context).pushNamed(const PaginaAnimalWidget()),
      //       child: Container(
      //         decoration: BoxDecoration(
      //           color: AppColors
      //               .secondaryColor
      //               .withOpacity(0.8),
      //           borderRadius: BorderRadius.circular(8),
      //         ),
      //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      //         child: Row(
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             const Icon(
      //               Icons.bar_chart_rounded,
      //               color: Colors.white,
      //             ),
      //             const SizedBox(
      //               width: 10,
      //             ),
      //             Text(
      //               'Gráficos',
      //               style: Theme.of(context).textTheme.titleSmall?.copyWith(
      //                     fontSize: 14,
      //                     fontWeight: FontWeight.w500,
      //                     color: Colors.white,
      //                   ),
      //             ),
      //             const SizedBox(
      //               width: 14,
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     const SizedBox(width: 12),
      //     Container(
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(8),
      //         border: Border.all(
      //           color: const Color(0xFFD7D3D0),
      //         ),
      //       ),
      //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      //       child: Row(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           Icon(
      //             Icons.filter_list_rounded,
      //             color: AppColors.neutralGray,
      //           ),
      //           const SizedBox(
      //             width: 10,
      //           ),
      //           Text(
      //             'Filtro',
      //             style: Theme.of(context).textTheme.titleSmall?.copyWith(
      //                   fontSize: 14,
      //                   fontWeight: FontWeight.w500,
      //                 ),
      //           ),
      //           const SizedBox(
      //             width: 14,
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    ];
  }

  Widget _sectionDetailsTitle(
    String title,
    Stream<List<dynamic>> amount, {
    Color? customColor,
    bool? showDownAnimal,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 10,
      ),
      visualDensity: const VisualDensity(vertical: -3),
      trailing: StreamBuilder<List<dynamic>>(
        stream: amount,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // TODO: put circularloagin or skeleton loading
            return _sectionTitleCounter(amount: 0);
          }

          return _sectionTitleCounter(
              amount: snapshot.data?.length ?? 0, color: customColor);
        },
      ),
      onTap: showDownAnimal == null
          ? null
          : () {
              final shell = StatefulNavigationShell.of(context);
              shell.goBranch(2);
              context.pushNamed(
                RouteName.animals,
                extra: {
                  "showDownAnimal": showDownAnimal,
                  "listAllAnimals": false,
                },
              );
            },
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  Widget _sectionDetailsAnimalsTitle(
    String title,
    Stream<int> amount, {
    Color? customColor,
    bool? showDownAnimal,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 10,
      ),
      visualDensity: const VisualDensity(vertical: -3),
      trailing: StreamBuilder<int>(
        stream: amount,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // TODO: put circularloagin or skeleton loading
            return _sectionTitleCounter(amount: 0);
          }

          return _sectionTitleCounter(
              amount: snapshot.data ?? 0, color: customColor);
        },
      ),
      onTap: showDownAnimal == null
          ? null
          : () {
              final shell = StatefulNavigationShell.of(context);
              shell.goBranch(2);
              context.pushNamed(
                RouteName.animals,
                extra: {
                  "showDownAnimal": showDownAnimal,
                  "listAllAnimals": false,
                },
              );
            },
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  Widget _sectionTitleCounter({int amount = 0, Color? color}) {
    return Text(
      amount.toString(),
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: amount <= 0
                ? const Color(0xFF292524)
                : (color ?? const Color(0xFF292524)),
          ),
    );
  }

  Widget _homeAnimalsSection() {
    return HomeSectionDetails(
      title: "Animais",
      detailsTiles: [
        _sectionDetailsAnimalsTitle(
          'Animais ativos',
          widget.store.countAnimalsAsStream(),
          customColor: AppColors.feedbackSuccess,
          showDownAnimal: false,
        ),
        const Divider(
          height: 0,
        ),
        _sectionDetailsAnimalsTitle(
          'Animais baixados',
          widget.store.countAnimalsAsStream(isActive: false),
          customColor: AppColors.feedbackDanger,
          showDownAnimal: true,
        ),
      ],
      nameMorePageRoute: 'Dashboard',
      morePageRoute: RouteName.dashboard,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SectionActionButton(
            title: "Dar baixa",
            width: 120,
            height: 35,
            icon: Icons.remove,
            onPressed: () {
              context.pushNamed(RouteName.animalDown);
            },
            displayBorder: false,
            color: AppColors.feedbackDanger,
          ),
          const SizedBox(width: 10),
          SectionActionButton(
            title: 'Cadastrar animais',
            width: 170,
            height: 35,
            icon: Icons.add,
            onPressed: () => showAnimalCreateModal(context),
          ),
        ],
      ),
    );
  }

  Widget _homeHandlingsSection() {
    return HomeSectionDetails(
      title: "Manejos",
      morePageRoute: 'Ver Todos',
      onMorePageRoute: () {
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: ((context, animation, secondaryAnimation) =>
                const HandlingsPage())));
      },
      detailsTiles: [
        InkWell(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: ((context, animation, secondaryAnimation) =>
                    const HandlingsPage(
                      type: AnimalHandlingTypes.pesagem,
                    )),
              ),
            );
          },
          child: _sectionDetailsTitle(
            'Pesagem',
            queryManejoRecord(
              queryBuilder: (manejoRecord) => (widget
                              .store.searchController?.text.isEmpty ??
                          true) ||
                      (widget.store.searchController?.text.length ?? 0) < 3
                  ? manejoRecord.where('handling_type', isEqualTo: 'pesagem')
                  : manejoRecord
                      .where('handling_type', isEqualTo: 'pesagem')
                      .where(
                        'tag_number',
                        isEqualTo: widget.store.searchController?.text ?? '',
                      ),
            ),
          ),
        ),
        const Divider(
          height: 0,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: ((context, animation, secondaryAnimation) =>
                    const HandlingsPage(
                      type: AnimalHandlingTypes.reprodutivo,
                    )),
              ),
            );
          },
          child: _sectionDetailsTitle(
            'Reprodutivo',
            queryManejoRecord(
              queryBuilder: (manejoRecord) =>
                  (widget.store.searchController?.text.isEmpty ?? true) ||
                          (widget.store.searchController?.text.length ?? 0) < 3
                      ? manejoRecord.where('handling_type',
                          isEqualTo: 'reprodutivo')
                      : manejoRecord
                          .where('handling_type', isEqualTo: 'reprodutivo')
                          .where(
                            'tag_number',
                            isEqualTo:
                                widget.store.searchController?.text ?? '',
                          ),
            ),
          ),
        ),
        const Divider(
          height: 0,
        ),
        InkWell(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: ((context, animation, secondaryAnimation) =>
                    const HandlingsPage(
                      type: AnimalHandlingTypes.sanitario,
                    )),
              ),
            );
          },
          child: _sectionDetailsTitle(
            'Sanitário',
            queryManejoRecord(
              queryBuilder: (manejoRecord) => (widget
                              .store.searchController?.text.isEmpty ??
                          true) ||
                      (widget.store.searchController?.text.length ?? 0) < 3
                  ? manejoRecord.where('handling_type', isEqualTo: 'sanitario')
                  : manejoRecord
                      .where('handling_type', isEqualTo: 'sanitario')
                      .where(
                        'tag_number',
                        isEqualTo: widget.store.searchController?.text ?? '',
                      ),
            ),
          ),
        ),
      ],
      child: Align(
        alignment: Alignment.centerRight,
        child: SectionActionButton(
          title: 'Fazer manejo',
          width: 170,
          height: 35,
          icon: Icons.add,
          onPressed: () => _openInitialHandlingModal(context),
        ),
      ),
    );
  }

  void _navigateToHandlingModal(
      BuildContext context, AnimalHandlingUpdatePageStore store) {
    Map<String, dynamic> extra = {
      'animal': store.animal?.toMap(),
      'reference': store.animal?.ffRef
    };
    switch (store.handlingType) {
      case AnimalHandlingTypes.pesagem:
        context.go(RouteName.animalWeighingHandling, extra: extra);
        break;
      case AnimalHandlingTypes.sanitario:
        context.go(RouteName.animalVaccineHandling, extra: extra);
        break;
      case AnimalHandlingTypes.reprodutivo:
        context.go(RouteName.animalReproductionHandling, extra: extra);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tipo de manejo inválido')),
        );
    }
  }

  void _openInitialHandlingModal(BuildContext context) {
    final store = AnimalHandlingUpdatePageStore();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Observer(builder: (_) {
          return BaseModalBottomSheet(
            title: 'Novo Manejo',
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seção: Tipo de manejo
              const SizedBox(height: 16),
              Text(
                'Tipo de manejo:',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF44403C),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<AnimalHandlingTypes?>(
                value: store.handlingType,
                decoration: InputDecoration(
                  labelText: 'Selecione o tipo',
                  labelStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 16),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                ),
                onChanged: store.animal == null
                    ? (type) {
                        _searchController.text = "";
                        store.updateHandlingType(type);
                      }
                    : null,
                validator: (_) =>
                    store.handlingType == null ? 'Campo obrigatório.' : null,
                items: AnimalHandlingTypes.values
                    .map<DropdownMenuItem<AnimalHandlingTypes>>(
                  (AnimalHandlingTypes type) {
                    return DropdownMenuItem<AnimalHandlingTypes>(
                      value: type,
                      child: Text(type.name.capitalize()),
                    );
                  },
                ).toList(),
              ),
              const SizedBox(height: 16),

              // Seção: Seleção do animal
              if (store.animal == null) ...[
                Observer(
                  builder: (context) {
                    return Visibility(
                      visible: store.handlingType != null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Escolha o animal${store.handlingType == AnimalHandlingTypes.reprodutivo ? ' fêmea:' : ':'}',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: const Color(0xFF44403C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                          const SizedBox(height: 4),
                          SearchAnimalWidget(
                            onAnimalSelected: store.updateSelectedAnimal,
                            onlyFemales: store.handlingType ==
                                    AnimalHandlingTypes.reprodutivo
                                ? true
                                : false,
                            searchController: _searchOnHandlingController,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ] else ...[
                // Exibe informações do animal selecionado
                StreamBuilder<AnimalModel>(
                  stream: AnimalModel.getDocument(store.animal!.ffRef!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          color: AppColors.primaryGreen,
                        ),
                      );
                    }

                    final animal = snapshot.data;

                    if (animal == null) {
                      return Text(
                        'Animal não encontrado',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: const Color(0xFF292524),
                                ),
                        textAlign: TextAlign.start,
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          'Informações do animal selecionado',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 16,
                                    color: const Color(0xFF292524),
                                  ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 6),
                        _animalDetails('Sexo do animal:', animal.sex ?? '-'),
                        const Divider(),
                        _animalDetails(
                            'Brinco do animal:', animal.tagNumber ?? '-'),
                        const Divider(),
                        _animalDetails('Lote:', animal.lot ?? '-'),
                        const Divider(),
                        if (store.isLastStep) ...[
                          _animalDetails(
                            'Manejo:',
                            store.handlingType?.name.capitalize() ?? '-',
                          ),
                          const Divider(),
                        ],
                      ],
                    );
                  },
                ),
              ],

              const SizedBox(height: 24),

              const SizedBox(height: 20),
              FFButton(
                loading: store.isLoading,
                text: store.isLastStep
                    ? (store.model == null
                        ? 'Adicionar manejo'
                        : 'Salvar alterações')
                    : 'Continuar',
                onPressed: store.animal != null
                    ? () {
                        if (store.handlingType != null &&
                            store.animal != null) {
                          Navigator.pop(context);
                          _navigateToHandlingModal(context, store);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Preencha todos os campos')),
                          );
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 16),
              FFButton(
                text: 'Cancelar',
                type: FFButtonType.outlined,
                onPressed: () {
                  if (store.animal != null && store.isLastStep) {
                    store.updateSelectedAnimal(null);
                  }
                  GoRouter.of(context).pop();
                },
                backgroundColor: Colors.transparent,
                borderColor: AppColors.primaryGreen,
                splashColor: AppColors.primaryGreen.withOpacity(0.1),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _animalDetails(String title, String leading) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(vertical: -3),
      trailing: Text(
        leading,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  // TODO: colocar o Ver todos igual o de Vacinas aplicadas recentemente
  List<Widget> _farmsSection() {
    return [
      ValueListenableBuilder<GlobalFarmModel?>(
          valueListenable: AppManager.instance.currentFarmNotifier,
          builder: (context, currentFarmModel, child) {
            final currentFarm = AppManager.instance.currentUser.currentFarm;

            DocumentReference farmReference = FirebaseFirestore.instance
                .collection('farms')
                .doc(currentFarm?.id);

            //TODO: future deve ser colocado dentro de um repository
            return FutureBuilder<FarmModel>(
              future: farmReference.get().then((doc) =>
                  FarmModel.getDocumentFromData(
                      doc.data()! as Map<String, dynamic>, doc.reference)),
              builder: (context, snapshot) {
                if ((snapshot.connectionState == ConnectionState.none ||
                        snapshot.connectionState == ConnectionState.waiting) &&
                    !snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final farm = snapshot.data;

                if (farm == null) {
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Você ainda não possui fazendas cadastradas',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SectionActionButton(
                          title: 'Adicionar fazenda',
                          width: 170,
                          icon: Icons.add,
                          onPressed: () =>
                              widget.store.updateFarmModal(context),
                        ),
                      ),
                    ],
                  );
                }

                final area = farm.area ?? 0.0;

                return HomeSectionDetails(
                    title: 'Minha Fazenda',
                    morePageRoute: RouteName.farms,
                    defaultSeeAllOption: false,
                    child: Observer(builder: (context) {
                      return GenericCardTile(
                        title: currentFarm?.name ?? '-',
                        updateAction: () =>
                            widget.store.updateFarmModal(context, model: farm),
                        children: [
                          GenericCardTileItem(
                            title:
                                "${NumberFormat.decimalPattern("pt-BR").format(area)} ha",
                            icon: Icons.zoom_out_map_outlined,
                          ),
                          const SizedBox(height: 9),
                          //TODO: future deve ser colocado dentro de um repository
                          FutureBuilder<int>(
                            future: farmReference
                                .collection('animals')
                                .where('active', isEqualTo: true)
                                .count()
                                .get()
                                .then((counter) => counter.count!),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                );
                              }

                              final total = snapshot.data!;

                              return GenericCardTileItem(
                                title: StringHelpers.animalsAmountLabel(total),
                                icon: FarmBovIcons.cow,
                              );
                            },
                          ),
                          const SizedBox(height: 9),
                          GenericCardTileItem(
                            title: (farm.latitude?.isEmpty ?? true) ||
                                    (farm.longitude?.isEmpty ?? true)
                                ? "Sem localização definida"
                                : "${farm.latitude} lat, ${farm.longitude} long",
                            icon: Icons.location_on_outlined,
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }));
              },
            );
          }),
    ];
  }

  Widget _buildWeb(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageTitleSection(
                title: 'Meus animais',
                content: _animalsSection(),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _homeAnimalsSection(),
                        SizedBox(height: Adaptive.px(20)),
                        _homeHandlingsSection()
                      ],
                    ),
                  ),
                  SizedBox(width: Adaptive.px(40)),
                  Expanded(
                    flex: 1,
                    child: AnimalsUpsDownsChart(
                      onAnimalTerminateEvent: () =>
                          context.goNamedAuth(RouteName.animalDown),
                      onAnimalCreateEvent: () => showAnimalCreateModal(context),
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 72,
                thickness: 1,
                color: Color(0xFFD7D3D0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 1,
                    child: VaccinesTableSection(mostRecent: true),
                  ),
                  SizedBox(width: Adaptive.px(40)),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: _farmsSection(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        title: SvgPicture.asset(
          'assets/images/logos/logo_icon_white.svg',
          semanticsLabel: 'Farmbov logo',
          height: 28,
        ),
        automaticallyImplyLeading: false,
        actions: [
          // IconButton(
          //   onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          //   icon: const Icon(
          //     Icons.notifications_none_outlined,
          //   ),
          // ),
          const SizedBox(height: 15),
          const SizedBox(width: 200, child: GlobalFarmSelect()),
          const SizedBox(width: 10),
          UserCircleAvatar(
            // TODO: get from global user model
            onPressed: () =>
                NavigationService.mobileMenuKey.currentState?.openDrawer(),
            small: true,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageTitleSection(
                title: "Meus animais",
                content: [
                  ..._animalsSection(),
                  const SizedBox(height: 24),
                  _homeAnimalsSection(),
                ],
              ),
              _homeHandlingsSection(),
              const Divider(
                height: 48,
                thickness: 1,
                color: Color(0xFFD7D3D0),
              ),
              const VaccinesTableSection(mostRecent: true),
              const Divider(
                height: 48,
                thickness: 1,
                color: Color(0xFFD7D3D0),
              ),
              PageTitleSection(
                title: "Minhas Fazendas",
                content: _farmsSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppManager>(
      builder: (context, appManager, child) => GenericStackPage(
        child: ResponsiveBreakpoints.of(context).isMobile
            ? _buildMobile(context)
            : _buildWeb(context),
      ),
    );
  }
}
