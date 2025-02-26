import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/common/helpers/strings_helpers.dart';
import 'package:farmbov/src/presenter/features/animal_handlings/widgets/reproduction_handling_modal.dart';
import 'package:farmbov/src/presenter/features/animal_handlings/widgets/weighing_handling_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../common/providers/app_manager.dart';

import '../../../../common/router/route_name.dart';
import '../../../../common/themes/theme_constants.dart';
import '../../../../domain/constants/animal_handling_types.dart';
import '../../../../domain/models/firestore/animal_handling_model.dart';
import '../../../../domain/models/firestore/animal_model.dart';
import '../../../shared/components/ff_button.dart';
import '../../../shared/components/generic_page_content.dart';
import '../../../shared/modals/base_modal_bottom_sheet.dart';
import '../../search_animal/search_animal_widget.dart';
import '../animal_handling_update/animal_handling_update_page_store.dart';
import '../widgets/vaccine_application_modal.dart';

class HandlingsPage extends StatefulWidget {
  final AnimalHandlingTypes? type;

  const HandlingsPage({super.key, this.type});

  @override
  State<HandlingsPage> createState() => _HandlingsPageState();
}

class _HandlingsPageState extends State<HandlingsPage> {
  AnimalHandlingTypes? selectedType;
  int _sortColumnIndex = 1;
  bool _sortAscending = true;
  final int _rowsPerPage = 10;
  int _currentPage = 0;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchOnHandlingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedType = widget.type;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchOnHandlingController.dispose();
    super.dispose();
  }

  String get titlePage {
    switch (selectedType) {
      case AnimalHandlingTypes.pesagem:
        return 'Manejos de Pesagem';
      case AnimalHandlingTypes.reprodutivo:
        return 'Manejos Reprodutivos';
      case AnimalHandlingTypes.sanitario:
        return 'Manejos Sanitários';
      default:
        return 'Todos os Manejos';
    }
  }

  Stream<QuerySnapshot> get handlingsStream {
    final collection = FirebaseFirestore.instance
        .collection('farms')
        .doc(AppManager.instance.currentUser.currentFarm?.id)
        .collection('animals_handlings');

    if (selectedType != null) {
      return collection
          .where('handling_type', isEqualTo: selectedType!.name)
          .snapshots();
    }

    return collection.snapshots();
  }

//TODO: DUPLICATED CODE - ABOVE - FROM HOME HANDLING ANIMALS AND DASHBOARD PAGE
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

//TODO: DUPLICATED CODE - ABOVE - FROM HOME HANDLING ANIMALS AND DASHBOARD PAGE

  @override
  Widget build(BuildContext context) {
    return GenericPageContent(
      actionButton: () {
        _openInitialHandlingModal(context);
      },
      actionTitle: 'Fazer Manejo',
      title: titlePage,
      showBackButton: true,
      useGridRows: false,
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 30),
                child: SegmentedButton<AnimalHandlingTypes>(
                  emptySelectionAllowed: true,
                  segments: const [
                    ButtonSegment(
                        value: AnimalHandlingTypes.pesagem,
                        label: Text('Pesagem')),
                    ButtonSegment(
                        value: AnimalHandlingTypes.reprodutivo,
                        label: Text('Reprodutivo')),
                    ButtonSegment(
                        value: AnimalHandlingTypes.sanitario,
                        label: Text('Sanitário')),
                  ],
                  selected: selectedType != null ? {selectedType!} : {},
                  onSelectionChanged: (newSelection) {
                    setState(() {
                      selectedType =
                          newSelection.isEmpty ? null : newSelection.first;
                      _currentPage = 0; // Resetar a paginação ao trocar filtro
                    });
                  },
                  showSelectedIcon: false,
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: AppManager.instance.currentFarmNotifier,
                  builder: (context, farmModel, __) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: handlingsStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Text('Nenhum manejo encontrado'));
                        }

                        final List<AnimalHandlingModel> handlings = snapshot
                            .data!.docs
                            .map((doc) =>
                                AnimalHandlingModel.getDocumentFromData(
                                    doc.data() as Map<String, dynamic>,
                                    doc.reference))
                            .toList();

                        return _buildPaginatedTable(handlings);
                      },
                    );
                  })
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPaginatedTable(List<AnimalHandlingModel> handlings) {
    handlings.sort((a, b) {
      int compare = 0;
      switch (_sortColumnIndex) {
        case 0:
          compare = a.tagNumber!.compareTo(b.tagNumber!);
          break;
        case 1:
          compare = a.handlingDate!.compareTo(b.handlingDate!);
          break;
        case 2:
          compare = a.handlingType!.compareTo(b.handlingType!);
          break;
      }
      return _sortAscending ? compare : -compare;
    });

    int totalPages = (handlings.length / _rowsPerPage).ceil();
    _currentPage = _currentPage.clamp(0, totalPages - 1);

    final int start = _currentPage * _rowsPerPage;
    final int end = (start + _rowsPerPage).clamp(0, handlings.length);
    final displayedRows = handlings.sublist(start, end);

    final columns = _buildColumns();

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            showBottomBorder: true,
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            columns: columns,
            rows: _buildRows(displayedRows),
          ),
        ),
        _buildPaginationControls(totalPages),
      ],
    );
  }

  List<DataColumn> _buildColumns() {
    List<DataColumn> columns = [
      DataColumn(
        label: const Text('Animal'),
        onSort: (columnIndex, _) => _onSort(columnIndex),
      ),
      if (selectedType != null &&
          ResponsiveBreakpoints.of(context).isMobile) ...[
        DataColumn(
          label: const Text('Data'),
          onSort: (columnIndex, _) => _onSort(columnIndex),
        ),
      ],
      if (selectedType != null &&
          !ResponsiveBreakpoints.of(context).isMobile) ...[
        DataColumn(
          label: const Text('Data'),
          onSort: (columnIndex, _) => _onSort(columnIndex),
        ),
      ],
      if (selectedType == null) ...[
        DataColumn(
          label: const Text('Tipo'),
          onSort: (columnIndex, _) => _onSort(columnIndex),
        ),
      ]
    ];

    if (selectedType == AnimalHandlingTypes.reprodutivo &&
        (!ResponsiveBreakpoints.of(context).isMobile ||
            !ResponsiveBreakpoints.of(context).isTablet)) {
      columns.add(
        const DataColumn(label: Text('Animal Macho')),
      );
      columns.add(const DataColumn(label: Text('Prenha')));
      columns.add(const DataColumn(label: Text('Data Prenhez')));
    }
    if (selectedType == AnimalHandlingTypes.sanitario &&
        (!ResponsiveBreakpoints.of(context).isMobile ||
            !ResponsiveBreakpoints.of(context).isTablet)) {
      columns.add(const DataColumn(label: Text('Vacina')));
      columns.add(const DataColumn(label: Text('Lote')));
    }
    if (selectedType == AnimalHandlingTypes.pesagem &&
        (!ResponsiveBreakpoints.of(context).isMobile ||
            !ResponsiveBreakpoints.of(context).isTablet)) {
      columns.add(const DataColumn(label: Text('Peso')));
    }

    columns.add(const DataColumn(label: Text('Ações')));

    return columns;
  }

  List<DataRow> _buildRows(List<AnimalHandlingModel> handlings) {
    return handlings.map((handling) {
      return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.selected)) {
            return Theme.of(context).colorScheme.primary.withOpacity(0.08);
          }
          if (handlings.indexOf(handling).isEven) {
            return AppColors.primaryGreenLight.withOpacity(0.5);
          }
          return null;
        }),
        cells: [
          DataCell(Text(handling.tagNumber!)),
          if (selectedType != null &&
              ResponsiveBreakpoints.of(context).isMobile) ...[
            DataCell(
                Text(DateFormat('dd/MM/yyyy').format(handling.handlingDate!))),
          ],
          if (selectedType != null &&
              !ResponsiveBreakpoints.of(context).isMobile) ...[
            DataCell(
                Text(DateFormat('dd/MM/yyyy').format(handling.handlingDate!))),
          ],
          if (selectedType == null) ...[
            DataCell(Text(
                '${handling.handlingType!.substring(0, 1).toUpperCase()}${handling.handlingType!.substring(1).toLowerCase()}')),
          ],
          if ((!ResponsiveBreakpoints.of(context).isMobile ||
              !!ResponsiveBreakpoints.of(context).isTablet)) ...[
            if (selectedType == AnimalHandlingTypes.reprodutivo)
              DataCell(Text(handling.maleTagNumber ?? '--')),
            if (selectedType == AnimalHandlingTypes.reprodutivo)
              DataCell(Text(handling.isPregnant == true ? 'Sim' : 'Não')),
            if (selectedType == AnimalHandlingTypes.reprodutivo)
              DataCell(Text(handling.pregnantDate != null
                  ? DateFormat('dd/MM/yyyy').format(handling.pregnantDate!)
                  : '--')),
            if (selectedType == AnimalHandlingTypes.pesagem)
              DataCell(Text('${handling.weight}')),
            if (selectedType == AnimalHandlingTypes.sanitario) ...[
              DataCell(Text(
                  '${handling.vaccine?.substring(0, 1).toUpperCase()}${handling.vaccine?.substring(1)}')),
              DataCell(Text('${handling.batchNumber}')),
            ],
          ],
          DataCell(_buildActionCell(handling)),
        ],
      );
    }).toList();
  }

  Widget _buildActionCell(AnimalHandlingModel handling) {
    return MenuAnchor(
      style: const MenuStyle(
        elevation: MaterialStatePropertyAll<double>(0.1),
        backgroundColor:
            MaterialStatePropertyAll<Color>(AppColors.primaryGreen),
      ),
      builder: (context, controller, _) {
        return IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => controller.open(),
        );
      },
      menuChildren: [
        MenuItemButton(
          child: const Text(
            'Visualizar',
            style: TextStyle(
                color: Colors.white, backgroundColor: Colors.transparent),
          ),
          onPressed: () {
            if (selectedType == AnimalHandlingTypes.reprodutivo ||
                handling.handlingType == 'reprodutivo') {
              _showReproductionModal(context, handling, readOnly: true);
            } else if (selectedType == AnimalHandlingTypes.sanitario ||
                handling.handlingType == 'sanitario') {
              _showVaccineApplicationModal(context, handling, readOnly: true);
            } else if (selectedType == AnimalHandlingTypes.pesagem ||
                handling.handlingType == 'pesagem') {
              _showWeightingModal(context, handling, readOnly: true);
            }
          },
        ),

        //TODO: Permitir edição de manejo via tela de manejos
        // MenuItemButton(
        //   child: const Text(
        //     'Editar',
        //     style: TextStyle(
        //         color: Colors.white, backgroundColor: Colors.transparent),
        //   ),
        //   onPressed: () {
        //     if (selectedType == AnimalHandlingTypes.reprodutivo) {
        //       _showReproductionModal(
        //         context,
        //         handling,
        //       );
        //     } else if (selectedType == AnimalHandlingTypes.sanitario) {
        //       _showVaccineApplicationModal(context, handling);
        //     } else if (selectedType == AnimalHandlingTypes.pesagem) {
        //       _showWeightingModal(context, handling);
        //     }
        //   },
        // ),
        MenuItemButton(
          child: const Text(
            'Excluir',
            style: TextStyle(
                color: Colors.white, backgroundColor: Colors.transparent),
          ),
          onPressed: () => _showDeleteDialog(handling),
        ),
      ],
    );
  }

  void _showReproductionModal(
      BuildContext context, AnimalHandlingModel handlingModel,
      {bool readOnly = false}) {
    AnimalHandlingUpdatePageStore store = AnimalHandlingUpdatePageStore(
      model: handlingModel,
    );
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => ReproductionHandlingModal(
        store: store,
        readOnly: readOnly,
      ),
    );
  }

  void _showVaccineApplicationModal(
      BuildContext context, AnimalHandlingModel handlingModel,
      {bool readOnly = false}) {
    AnimalHandlingUpdatePageStore store = AnimalHandlingUpdatePageStore(
      model: handlingModel,
    );
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => VaccineApplicationModal(
        store: store,
        readOnly: readOnly,
      ),
    );
  }

  void _showWeightingModal(
      BuildContext context, AnimalHandlingModel handlingModel,
      {bool readOnly = false}) {
    AnimalHandlingUpdatePageStore store = AnimalHandlingUpdatePageStore(
      model: handlingModel,
    );
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => WeighingHandlingModal(
        store: store,
        readOnly: readOnly,
        handlingModel: handlingModel,
      ),
    );
  }

  void _showDeleteDialog(AnimalHandlingModel handling) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Manejo'),
        content: const Text('Tem certeza que deseja excluir este manejo?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () {
                handling.reference.delete();
                context.pop();
              },
              child: const Text('Excluir')),
        ],
      ),
    );
  }

  void _onSort(int columnIndex) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = !_sortAscending;
    });
  }

  Widget _buildPaginationControls(int totalPages) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.primaryGreen,
            ),
            onPressed:
                _currentPage > 0 ? () => setState(() => _currentPage--) : null,
          ),
          Text('Página ${_currentPage + 1} de $totalPages'),
          IconButton(
            icon:
                const Icon(Icons.chevron_right, color: AppColors.primaryGreen),
            onPressed: _currentPage < totalPages - 1
                ? () => setState(() => _currentPage++)
                : null,
          ),
        ],
      ),
    );
  }
}
