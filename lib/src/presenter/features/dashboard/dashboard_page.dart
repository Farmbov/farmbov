import 'dart:async';

import 'package:farmbov/src/common/helpers/strings_helpers.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';
import 'package:farmbov/src/presenter/features/dashboard/dashboard_page_store.dart';
import 'package:farmbov/src/presenter/features/dashboard/widgets/animals_filtter_toggle_option.dart';
import 'package:farmbov/src/presenter/features/dashboard/widgets/animals_pie_chart.dart';
import 'package:farmbov/src/presenter/features/dashboard/widgets/animals_ups_downs_chart.dart';
import 'package:farmbov/src/presenter/features/home/widgets/home_section_details.dart';
import 'package:farmbov/src/presenter/features/search_animal/search_animal_widget.dart';
import 'package:farmbov/src/presenter/shared/components/generic_page_content.dart';
import 'package:farmbov/src/presenter/shared/components/no_content_page.dart';
import 'package:farmbov/src/presenter/shared/components/widget_default_loader.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../domain/constants/animal_handling_types.dart';
import '../../shared/modals/base_modal_bottom_sheet.dart';
import '../animal_handlings/animal_handling_update/animal_handling_update_page_store.dart';
import '../animal_handlings/handlings_page/handlings_page.dart';

class DashboardPage extends StatefulWidget {
  final DashboardPageStore store;
  final bool toggleShowDownAnimals;

  const DashboardPage({
    super.key,
    required this.store,
    this.toggleShowDownAnimals = false,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _searchOnHandlingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.store.init();
  }

  @override
  void dispose() {
    widget.store.dispose();
    _searchController.dispose();
    _searchOnHandlingController.dispose();
    super.dispose();
  }

  final List<bool> _selectedToggleOptions = <bool>[true, false, false];

  Timer? _debounceTimer;

  // TODO: improve and make component
  void startSearchTimer(String keyword) {
    _debounceTimer?.cancel();
    setState(() {
      if (keyword.length >= 3) {
        // _model.searchingTerm = true;
        // _debounceTimer = Timer(const Duration(milliseconds: 250), () {
        //   setState(() {
        //     _model.searchingTerm = false;
        //   });
        // });
      }
    });
  }

  // TODO: move to DS
  Widget sectionActionButton(
    String title, {
    double width = 150,
    double height = 35,
    IconData? icon,
    dynamic Function()? onPressed,
    Color? color,
    bool displayBorder = true,
  }) {
    return FFButton(
      type: FFButtonType.outlined,
      fullWidth: false,
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      borderColor: displayBorder ? null : Colors.transparent,
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color ?? AppColors.primaryGreen,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 12,
                  color: color ?? AppColors.primaryGreen,
                ),
          ),
        ],
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

  Widget _sectionDetailsTitle(String title, Future<List<dynamic>> amount,
      {Color? customColor, bool? showDownAnimal}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 10,
      ),
      visualDensity: const VisualDensity(vertical: -3),
      trailing: FutureBuilder<List<dynamic>>(
        future: amount,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // TODO: put circularloagin or skeleton loading
            return _sectionTitleCounter(amount: 0);
          }

          return _sectionTitleCounter(
              amount: snapshot.data?.length ?? 0, color: customColor);
        },
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
      ),
      onTap: showDownAnimal == null
          ? null
          : () {
              context.pushNamed(
                RouteName.animals,
                extra: {
                  "showDownAnimal": showDownAnimal,
                  "listAllAnimals": false,
                },
              );
            },
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

  Widget toggleFilter() {
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < _selectedToggleOptions.length; i++) {
            _selectedToggleOptions[i] = i == index;
          }
        });
      },
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedColor: const Color(0xFF292524),
      fillColor: Colors.transparent,
      color: const Color(0xFFD7D3D0),
      constraints: const BoxConstraints(
        maxHeight: 40,
        minWidth: 70,
      ),
      splashColor: const Color(0xFF292524).withOpacity(0.05),
      isSelected: _selectedToggleOptions,
      children: <Widget>[
        // TODO: rename to generic
        AnimalsFilterToggleOption(
          title: '12 meses',
          isSelected: _selectedToggleOptions[0],
        ),
        AnimalsFilterToggleOption(
          title: '30 dias',
          isSelected: _selectedToggleOptions[1],
        ),
        AnimalsFilterToggleOption(
          title: '7 dias',
          isSelected: _selectedToggleOptions[2],
        ),
      ],
    );
  }

  Future<int?> getAnimalCount(String sex) async {
    final farmId = AppManager.instance.currentUser.currentFarm?.id;

    final query = FirebaseFirestore.instance
        .collection('farms/$farmId/animals')
        .where('active', isEqualTo: true)
        .where('sex', isEqualTo: sex);

    final snapshot = await query.count().get();
    return snapshot.count;
  }

  Widget _sexPieChart() {
    final farmId = AppManager.instance.currentUser.currentFarm?.id;
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Sexo dos animais ativos',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  color: const Color(0xFF292524),
                ),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 14),
        ValueListenableBuilder(
            valueListenable: AppManager.instance.currentFarmNotifier,
            builder: (context, _, __) {
              return WidgetDefaultLoader(
                //TODO: loading: widget.store.searchingTerm,
                loading: false,
                child: FutureBuilder<List<AnimalModel>>(
                  future: widget.store.listAnimals(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    final maleAmount =
                        snapshot.data!.where((a) => a.sex == "Macho").length;
                    final femaleAmount =
                        snapshot.data!.where((a) => a.sex == "Fêmea").length;
                    return AnimalsPieChart(
                      maleAmount: maleAmount,
                      femaleAmount: femaleAmount,
                    );
                  },
                ),
              );
            }),
      ],
    );
  }

  Widget _entryExitAnimalsChart() {
    return AnimalsUpsDownsChart(
      onAnimalTerminateEvent: () => context.pushNamed(RouteName.animalDown),
      onAnimalCreateEvent: () => widget.store.showAnimalsRegisterModal(context),
    );
  }

  List<Widget> _chartsListWeb() {
    return [
      Expanded(child: _sexPieChart()),
      if (!ResponsiveBreakpoints.of(context).isMobile)
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Container(
            color: AppColors.primaryGreen,
            height: 400,
            width: 0.2,
          ),
        ),
      Expanded(child: _entryExitAnimalsChart())
    ];
  }

  List<Widget> _chartsListMobile() {
    return [
      _sexPieChart(),
      if (!ResponsiveBreakpoints.of(context).isMobile)
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Container(
            color: AppColors.primaryGreen,
            height: 400,
            width: 0.2,
          ),
        ),
      _entryExitAnimalsChart()
    ];
  }

  List<Widget> _animalsSection() {
    return [
      SearchAnimalWidget(
        onlyActive: !widget.toggleShowDownAnimals,
        searchController: _searchController,
      ),
      const SizedBox(
        height: 22,
      ),
      HomeSectionDetails(
        title: "Animais",
        detailsTiles: [
          _sectionDetailsAnimalsTitle(
            'Animais ativos',
            widget.store.animalService
                .countAnimalsByStatusStream(isActive: true),
            customColor: AppColors.feedbackSuccess,
            showDownAnimal: false,
          ),
          const Divider(
            height: 0,
          ),
          _sectionDetailsAnimalsTitle(
            'Animais baixados',
            widget.store.animalService
                .countAnimalsByStatusStream(isActive: false),
            customColor: AppColors.feedbackDanger,
            showDownAnimal: true,
          ),
        ],
        morePageRoute: RouteName.animals,
        onMorePageRoute: () {
          context.pushNamed(RouteName.animals);
        },
      ),
      const SizedBox(height: 24),
      WidgetDefaultLoader(
        //TODO: loading: _model.searchingTerm,
        loading: false,
        child: HomeSectionDetails(
          morePageRoute: 'Ver Todos',
          onMorePageRoute: () {
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: ((context, animation, secondaryAnimation) =>
                    const HandlingsPage())));
          },
          nameMorePageRoute: "Ver todos",
          title: "Manejos",
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
                queryManejoRecordOnce(
                  queryBuilder: (manejoRecord) => (widget
                                  .store.searchController?.text.isEmpty ??
                              true) ||
                          (widget.store.searchController?.text.length ?? 0) < 3
                      ? manejoRecord.where('handling_type',
                          isEqualTo: 'pesagem')
                      : manejoRecord
                          .where('handling_type', isEqualTo: 'pesagem')
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
              thickness: 0.5,
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
                queryManejoRecordOnce(
                  queryBuilder: (manejoRecord) => (widget
                                  .store.searchController?.text.isEmpty ??
                              true) ||
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
              thickness: 0.5,
            ),
            InkWell(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
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
                queryManejoRecordOnce(
                  queryBuilder: (manejoRecord) => (widget
                                  .store.searchController?.text.isEmpty ??
                              true) ||
                          (widget.store.searchController?.text.length ?? 0) < 3
                      ? manejoRecord.where('handling_type',
                          isEqualTo: 'sanitario')
                      : manejoRecord
                          .where('handling_type', isEqualTo: 'sanitario')
                          .where(
                            'tag_number',
                            isEqualTo:
                                widget.store.searchController?.text ?? '',
                          ),
                ),
              ),
            ),
          ],
          child: Column(
            children: [
              const SizedBox(height: 8),
              FFButton(
                text: 'Fazer manejo',
                onPressed: () => _openInitialHandlingModal(context),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 40),
      if (ResponsiveBreakpoints.of(context).isMobile ||
          ResponsiveBreakpoints.of(context).isTablet)
        Column(
          children: [..._chartsListMobile()],
        )
      else
        Row(
          children: [..._chartsListWeb()],
        )
    ];
  }

  //TODO: DUPLICATED CODE FROM HOME HANDLING ANIMALS
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
                      child: Text(type.name),
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

//TODO: DUPLICATED CODE - ABOVE - FROM HOME HANDLING ANIMALS

  Widget _buildContent() {
    return FutureBuilder<List<AnimalModel>>(
      future: widget.store.listAnimals(),
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
        final areaList = snapshot.data;

        if (areaList == null || areaList.isEmpty) {
          return Center(
            child: NoContentPage(
              title: 'Nenhum animal encontrado',
              description: 'Não existem animais ativos para mostrar.',
              actionTitle: 'Cadastrar Animais',
              action: () {
                widget.store.showAnimalsRegisterModal(context);
              },
            ),
          );
        }

        return GenericPageContent(
          appBar: null,
          title: 'Dashboard Animais',
          showBackButton: false,
          useGridRows: false,
          children: [
            // TODO: create widget component
            ..._animalsSection(),
          ],
        );
      },
    );
  }

  Widget _buildMobile(BuildContext context) => _buildContent();

  Widget _buildWeb(BuildContext context) => _buildContent();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppManager.instance.currentFarmNotifier,
        builder: (context, _, __) {
          return ResponsiveBreakpoints.of(context).isMobile
              ? _buildMobile(context)
              : _buildWeb(context);
        });
  }
}
