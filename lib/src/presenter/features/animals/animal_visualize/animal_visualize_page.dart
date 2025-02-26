// ignore_for_file: use_build_context_synchronously

import 'package:farmbov/src/presenter/features/animal_handlings/animal_handling_update/animal_handling_update_page_store.dart';
import 'package:farmbov/src/presenter/features/animal_handlings/widgets/weighing_handling_modal.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:diacritic/diacritic.dart';
import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/domain/constants/animal_handling_types.dart';
import 'package:farmbov/src/domain/constants/animal_tag_type.dart';
import 'package:farmbov/src/presenter/features/animals/animal_visualize/animal_visualize_page_store.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';
import 'package:farmbov/src/domain/models/firestore/animal_handling_model.dart';
import 'package:farmbov/src/presenter/features/animals/animal_visualize/widgets/handling_weight_bar_chart.dart';
import 'package:farmbov/src/presenter/features/dashboard/widgets/animals_filtter_toggle_option.dart';
import 'package:farmbov/src/presenter/features/home/widgets/generic_table_item.dart';
import 'package:farmbov/src/presenter/features/home/widgets/generic_table_item_action.dart';
import 'package:farmbov/src/presenter/features/home/widgets/section_action_button.dart';
import 'package:farmbov/src/presenter/shared/components/animal_situation_label.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/components/image_network_preview.dart';
import 'package:farmbov/src/presenter/shared/components/page_appbar.dart';

import 'package:responsive_framework/responsive_framework.dart';

import '../../../shared/modals/base_alert_modal.dart';
import '../../animal_handlings/widgets/reproduction_handling_modal.dart';
import '../../animal_handlings/widgets/vaccine_application_modal.dart';

class AnimalVisualizePage extends StatefulWidget {
  final AnimalVisualizePageStore store;
  final AnimalModel? model;
  final bool readOnly;

  const AnimalVisualizePage({
    super.key,
    required this.store,
    this.model,
    this.readOnly = false,
  });

  @override
  AnimalVisualizePageState createState() => AnimalVisualizePageState();
}

class AnimalVisualizePageState extends State<AnimalVisualizePage> {
  final List<bool> _selectedToggleOptions = <bool>[true, false, false];

  @override
  void initState() {
    super.initState();
    widget.store.init();
  }

  @override
  void dispose() {
    widget.store.disposeStore();
    super.dispose();
  }

  AnimalHandlingTypes? _getSelectedTypeFilter() {
    if (_selectedToggleOptions[0]) {
      return AnimalHandlingTypes.pesagem;
    } else if (_selectedToggleOptions[1]) {
      return AnimalHandlingTypes.reprodutivo;
    } else if (_selectedToggleOptions[2]) {
      return AnimalHandlingTypes.sanitario;
    }
    return null;
  }

  List<GenericTableItem> _getDynamicTableItems() {
    if (_selectedToggleOptions[0]) {
      return [
        const GenericTableItem(
          text: 'Peso',
          header: true,
        ),
      ];
    } else if (_selectedToggleOptions[1]) {
      return [
        const GenericTableItem(
          text: 'Prenha?',
          header: true,
        ),
        const GenericTableItem(
          text: 'Macho',
          header: true,
        ),
        if (!ResponsiveBreakpoints.of(context).isMobile)
          const GenericTableItem(
            text: 'Data Prenhez',
            header: true,
          ),
        if (!ResponsiveBreakpoints.of(context).isMobile)
          const GenericTableItem(
            text: 'Previsão Parto',
            header: true,
          ),
        if (!ResponsiveBreakpoints.of(context).isMobile)
          const GenericTableItem(
            text: 'Dias Restantes',
            header: true,
          ),
      ];
    } else if (_selectedToggleOptions[2]) {
      return [
        const GenericTableItem(
          text: 'Vacina',
          header: true,
        ),
        const GenericTableItem(
          text: 'Lote',
          header: true,
        ),
      ];
    }

    return [
      const GenericTableItem(
        text: '-',
        header: true,
      ),
    ];
  }

  List<GenericTableItem> _getDynamicTableItemValue(
    String? maleTag,
    String? peso,
    DateTime? dataPrenha,
    bool? prenha,
    String? vacina,
    String? batchNumber,
  ) {
    if (_selectedToggleOptions[0]) {
      return [
        GenericTableItem(
          text: peso?.isEmpty ?? true ? '-' : "$peso kg",
          fontSize: 12,
        )
      ];
    } else if (_selectedToggleOptions[1]) {
      final birthLikelyDate = dataPrenha?.add(const Duration(days: 30 * 9));
      final remaningDays = birthLikelyDate?.difference(DateTime.now());
      return [
        GenericTableItem(
          text: prenha == null
              ? '-'
              : prenha
                  ? 'Sim'
                  : 'Não',
          fontSize: 12,
        ),
        GenericTableItem(
          text: maleTag ?? "-",
          fontSize: 12,
        ),
        if (!ResponsiveBreakpoints.of(context).isMobile)
          GenericTableItem(
            text: dataPrenha == null
                ? '-'
                : DateFormat('dd/MM/yyyy').format(dataPrenha),
            fontSize: 12,
          ),
        if (!ResponsiveBreakpoints.of(context).isMobile)
          GenericTableItem(
            text: birthLikelyDate == null
                ? '-'
                : DateFormat('dd/MM/yyyy').format(birthLikelyDate),
            fontSize: 12,
          ),
        if (!ResponsiveBreakpoints.of(context).isMobile)
          GenericTableItem(
            child: Text(
              remaningDays == null ? '-' : '${remaningDays.inDays}',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.errorColor),
            ),
          ),
      ];
    } else if (_selectedToggleOptions[2]) {
      return [
        GenericTableItem(
          text: vacina ?? '-',
          fontSize: 12,
        ),
        GenericTableItem(
          text: batchNumber ?? '-',
          fontSize: 12,
        )
      ];
    }

    return [
      const GenericTableItem(
        text: '-',
        fontSize: 12,
      )
    ];
  }

  Widget _manejosTable({List<TableRow>? items}) {
    return Table(
      children: [
        TableRow(
          decoration: const BoxDecoration(
            color: Color(0xFFFAFAF9),
          ),
          children: [
            ..._getDynamicTableItems(),
             GenericTableItem(
              text: !ResponsiveBreakpoints.of(context).isMobile?"Data do Manejo":"Data",
              header: true,
              textAlign: TextAlign.center,
            ),
            const GenericTableItem(
              text: "Ação",
              header: true,
              textAlign: TextAlign.right,
              alignment: Alignment.center,
            ),
          ],
        ),
        ...items ?? [],
      ],
    );
  }

  Widget _toggleFilter() {
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < _selectedToggleOptions.length; i++) {
            // Machos não possuem a opção de manejo reprodutivo index 1 em _selectedToggleOptions
            if (widget.model?.sex == 'Macho') {
              if (index != 1) _selectedToggleOptions[i] = i == index;
            } else {
              _selectedToggleOptions[i] = i == index;
            }
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
          title: 'Pesagem',
          isSelected: _selectedToggleOptions[0],
        ),
        if (widget.model?.sex == 'Fêmea')
          AnimalsFilterToggleOption(
            title: 'Reprodutivo',
            isSelected: _selectedToggleOptions[1],
          )
        else
          const AnimalsFilterToggleOption(
            title: '-',
            isSelected: false,
          ),
        AnimalsFilterToggleOption(
          title: 'Sanitário',
          isSelected: _selectedToggleOptions[2],
        ),
      ],
    );
  }

  Padding _handlingButton(BuildContext context) {
    String selectedHandling = '';

    if (_selectedToggleOptions[0] == true) {
      selectedHandling = 'Pesagem';
    } else if (_selectedToggleOptions[1] == true) {
      selectedHandling = 'Reprodutivo';
    } else {
      selectedHandling = 'Sanitário';
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: ResponsiveBreakpoints.of(context).screenWidth < 600
            ? IconButton(
                tooltip: 'Adicionar Manejo $selectedHandling',
                onPressed: () {
                  _handlingAction(context);
                },
                icon: const Icon(
                  Icons.add_rounded,
                  color: AppColors.primaryGreen,
                  size: 25,
                ))
            : SectionActionButton(
                title: 'Adicionar Manejo $selectedHandling',
                width: 250,
                height: 35,
                icon: Icons.add_rounded,
                onPressed: () {
                  _handlingAction(context);
                },
              ),
      ),
    );
  }

  void _handlingAction(BuildContext context) {
    if (_selectedToggleOptions[0] == true) {
      // widget.store.editManejoModal(
      //   context,
      //   animal: widget.model,
      //   type: _getSelectedTypeFilter(),
      // );
      showWeighingHandlingModal(context);
    } else if (_selectedToggleOptions[1] == true) {
      // widget.store.editManejoModal(
      //   context,
      //   animal: widget.model,
      //   type: _getSelectedTypeFilter(),
      // );
      showReproductionHandlignModal(context);
    } else {
      showVaccineApplicationModal(context);
    }
  }

  Widget _sectionDetailsTitle(
    String title, {
    String? subtitle,
    Widget? subtitleWidget,
    bool hasBorder = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: hasBorder
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Color(0xFFE7E5E4),
                ),
              ),
            )
          : const BoxDecoration(),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 10,
        ),
        visualDensity: const VisualDensity(vertical: -3),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
        ),
        trailing: subtitleWidget ??
            Text(
              subtitle ?? '-',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF57534E),
                  ),
            ),
      ),
    );
  }

  void showVaccineApplicationModal(BuildContext context) {
    AnimalHandlingUpdatePageStore store = AnimalHandlingUpdatePageStore();
    store.updateSelectedAnimal(widget.model);
    showModalBottomSheet(
      context: context,
      builder: (context) => VaccineApplicationModal(
        store: store,
      ),
    );
  }

  void showWeighingHandlingModal(BuildContext context,
      {AnimalHandlingModel? handlingModel, bool readOnly=false}) {
    AnimalHandlingUpdatePageStore store = AnimalHandlingUpdatePageStore(
        animal: widget.model,
        model: handlingModel,
        handlingType: AnimalHandlingTypes.pesagem);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => WeighingHandlingModal(
        store: store,
        handlingModel: handlingModel,
        readOnly: readOnly,

      ),
    );
  }

  void showReproductionHandlignModal(BuildContext context,
      {AnimalHandlingModel? handlingModel, bool readOnly=false}) {
    AnimalHandlingUpdatePageStore store = AnimalHandlingUpdatePageStore(
        animal: widget.model,
        model: handlingModel,
        handlingType: AnimalHandlingTypes.reprodutivo);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ReproductionHandlingModal(store: store, readOnly: readOnly,),
    );
  }

  void showInsertSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Manejo Realizado com Sucesso!',
        actionCallback: () {
          context.pop();
        },
        showCancel: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveBreakpoints.of(context).isMobile
          ? const PageAppBar(
              title: "Visualizar meu animal",
              backButton: true,
            )
          : const PageAppBar(
              title: "Visualizar meu animal",
              invertedColors: true,
              backButton: true,
            ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informações do animal',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          color: const Color(0xFF292524),
                        ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 16),
                  if (widget.model?.photoUrl?.isNotEmpty ?? false) ...[
                    ImageNetworkPreview(imageUrl: widget.model!.photoUrl!),
                  ] else ...[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffD7D3D0),
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image_not_supported,
                            color: AppColors.neutralGray,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nenhuma foto do animal',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.neutralGray,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffD7D3D0),
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionDetailsTitle(
                          'Brinco do animal:',
                          subtitle: widget.model?.tagNumber,
                        ),
                        _sectionDetailsTitle(
                          'Tipo do brinco:',
                          subtitle:
                              widget.model?.tagType == AnimalTagType.common.name
                                  ? 'Comum'
                                  : 'RFID',
                        ),
                        _sectionDetailsTitle(
                          'Situação:',
                          subtitleWidget: AnimalSituationLabel(
                            active: widget.model?.active ?? true,
                          ),
                        ),
                        _sectionDetailsTitle(
                          'Peso:',
                          subtitle: "${widget.model?.weight ?? 0} kg",
                        ),
                        _sectionDetailsTitle(
                          'Sexo:',
                          subtitle: widget.model?.sex,
                        ),
                        _sectionDetailsTitle(
                          'Raça:',
                          subtitle: widget.model?.breed,
                        ),
                        _sectionDetailsTitle(
                          'Lote:',
                          subtitle: widget.model?.lot,
                        ),
                        _sectionDetailsTitle(
                          'Data de nascimento:',
                          subtitle: widget.model?.birthDate == null
                              ? '-'
                              : DateFormat('dd/MM/yyyy')
                                  .format(widget.model!.birthDate!),
                        ),
                        _sectionDetailsTitle(
                          'Entrada do animal:',
                          subtitle: widget.model?.entryDate == null
                              ? '-'
                              : DateFormat('dd/MM/yyyy')
                                  .format(widget.model!.entryDate!),
                        ),
                        _sectionDetailsTitle(
                          'Data da pesagem:',
                          subtitle: widget.model?.weighingDate == null
                              ? '-'
                              : DateFormat('dd/MM/yyyy')
                                  .format(widget.model!.weighingDate!),
                          hasBorder: false,
                        ),
                        // TODO: make situation label
                        // _sectionDetailsTitle('Situação:', "Ativo"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Informações dos pais',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          color: const Color(0xFF292524),
                        ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffD7D3D0),
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionDetailsTitle(
                          'Brinco da mãe:',
                          subtitle: widget.model?.momTagNumber,
                        ),
                        _sectionDetailsTitle(
                          'Brinco do pai:',
                          subtitle: widget.model?.dadTagNumber,
                          hasBorder: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Observações',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          color: const Color(0xFF292524),
                        ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    constraints: const BoxConstraints(
                      minHeight: 50,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffD7D3D0),
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      widget.model?.notes ?? 'Nenhuma observação.',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manejos',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          color: const Color(0xFF292524),
                        ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _toggleFilter(),
                      _handlingButton(context),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            StreamBuilder<List<AnimalHandlingModel>>(
              stream: queryManejoRecord(
                queryBuilder: (manejoRecord) => manejoRecord
                    .where(
                      'tag_number',
                      isEqualTo: widget.model?.tagNumber,
                    )
                    .where(
                      'active',
                      isEqualTo: true,
                    )
                    .where(
                      'handling_type',
                      isEqualTo: removeDiacritics(
                          _getSelectedTypeFilter()?.name.toLowerCase() ?? ''),
                    )
                    .orderBy(
                      "handling_date",
                      descending: true,
                    ),
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final manejoList = snapshot.data;

                if (manejoList == null || manejoList.isEmpty) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    constraints: const BoxConstraints(
                      minHeight: 50,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffD7D3D0),
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Nenhum manejo encontrado para este tipo.',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  );
                }

                return _manejosTable(
                  items: manejoList
                      .map(
                        (manejo) => TableRow(
                          children: [
                            ..._getDynamicTableItemValue(
                                manejo.maleTagNumber,
                                manejo.weight,
                                manejo.pregnantDate,
                                manejo.isPregnant,
                                manejo.vaccine,
                                manejo.batchNumber),
                            GenericTableItem(
                              text: manejo.handlingDate == null
                                  ? '-'
                                  : DateFormat('dd/MM/yyyy').format(
                                      manejo.handlingDate!,
                                    ),
                              fontSize: 12,
                              textAlign: TextAlign.center,
                            ),
                            GenericTableItem(
                              alignment: Alignment.center,
                              child: GenericTableItemAction(
                                detailsAction: _getSelectedTypeFilter() ==
                                        AnimalHandlingTypes.pesagem
                                    ? () => showWeighingHandlingModal(context,
                                        handlingModel: manejo, readOnly: true)
                                    : _getSelectedTypeFilter() ==
                                            AnimalHandlingTypes.reprodutivo
                                        ? () => showReproductionHandlignModal(
                                            context,
                                            handlingModel: manejo, readOnly:true)
                                        : null,
                                id: manejo.ffRef?.id ?? "-1",
                                //TODO: Como não foi definido quais são as regras de negócio é melhor remover a opção de edição do manejo sanitário por enquanto.
                                editAction: _getSelectedTypeFilter() ==
                                        AnimalHandlingTypes.pesagem
                                    ? () => showWeighingHandlingModal(context,
                                        handlingModel: manejo)
                                    : _getSelectedTypeFilter() ==
                                            AnimalHandlingTypes.reprodutivo
                                        ? () => showReproductionHandlignModal(
                                            context,
                                            handlingModel: manejo)
                                        : null,
                                deleteAction: () => widget.store
                                    .deleteManejoModal(context, manejo),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 0),
              child: Text(
                'Evolução de peso',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      color: const Color(0xFF292524),
                    ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: StreamBuilder<List<AnimalHandlingModel>>(
                stream: queryManejoRecord(
                  queryBuilder: (manejoRecord) => manejoRecord
                      .where(
                        'tag_number',
                        isEqualTo: widget.model?.tagNumber ?? "-1",
                      )
                      .where(
                        'handling_type',
                        isEqualTo: "pesagem",
                      ),
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return HandlingWeightBarChart(
                    manejoPesagem: snapshot.data ?? [],
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if ((widget.model?.active ?? false)) ...[
                    FFButton(
                      text: 'Dar baixa no animal',
                      onPressed: () => context.goNamedAuth(
                        RouteName.animalDownId,
                        params: {"id": widget.model?.ffRef?.id ?? 'unknown'},
                        extra: {"model": widget.model},
                      ),
                      backgroundColor: AppColors.feedbackDanger,
                      borderColor: AppColors.feedbackDanger,
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 16),
                  ],
                  FFButton(
                    text: 'Voltar',
                    type: FFButtonType.outlined,
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
