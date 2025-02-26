import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/constants/animal_handling_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:farmbov/src/presenter/shared/modals/base_modal_bottom_sheet.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../common/providers/alert_manager.dart';

import 'package:extended_masked_text/extended_masked_text.dart';

import '../../../../domain/models/firestore/animal_handling_model.dart';
import '../animal_handling_update/animal_handling_update_page_store.dart';
import 'animal_card.dart';
import 'search_animal_to_card.dart';

class WeighingHandlingModal extends StatefulWidget {
  final AnimalHandlingModel? handlingModel;
  final AnimalHandlingUpdatePageStore store;
  final bool readOnly;

  const WeighingHandlingModal({
    super.key,
    this.handlingModel,
    required this.store,
    this.readOnly = false,
  });

  @override
  _WeighingHandlingModalState createState() => _WeighingHandlingModalState();
}

class _WeighingHandlingModalState extends State<WeighingHandlingModal> {
  late MoneyMaskedTextController _weightController;
  final TextEditingController _searchAnimalController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    widget.store.updateHandlingType(AnimalHandlingTypes.pesagem);
    // Inicializa o controlador com a máscara para peso
    _weightController = MoneyMaskedTextController(
      initialValue: widget.handlingModel != null
          ? double.tryParse(widget.handlingModel!.weight!
              .replaceAll('.', '')
              .replaceAll(',', '.'))
          : 0,
    );

    // Inicializa a data caso seja edição
    _selectedDate = widget.handlingModel?.handlingDate;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _searchAnimalController.dispose();
    super.dispose();
  }

  // Seleção de data
  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Widget _buildSearchAnimal() {
    return SearchAnimalToCard(
        title: 'Escolha o Animal:',
        searchController: _searchAnimalController,
        onAnimalSelected: widget.store.updateSelectedAnimal,
        onlyFemales: false,
        onlyMales: false);
  }

  Widget _buildAnimalCard(BuildContext context) {
    return AnimalCard(
      title: 'O Animal Escolhido',
      animal: widget.store.animal,
      onRemove: () => widget.store.updateSelectedAnimal(null),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute =
        GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();

    return BaseModalBottomSheet(
      title: widget.readOnly
          ? "Detalhes Pesagem"
          : widget.handlingModel == null
              ? 'Novo Manejo de Pesagem'
              : 'Editar Manejo de Pesagem',
      showCloseButton:
          ResponsiveBreakpoints.of(context).isDesktop ? true : false,
      children: [
        Observer(builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              if (widget.store.animal == null &&
                  currentRoute.contains('/animais/manejos/')) ...[
                _buildSearchAnimal(),
                const SizedBox(
                  height: 10,
                ),
              ],
              if (widget.store.animal != null &&
                  currentRoute.contains('/animais/manejos/'))
                _buildAnimalCard(context),
              const SizedBox(height: 10),

              Text(
                "Peso (kg):",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF44403C),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                readOnly: widget.readOnly,
                controller: _weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              // Campo de data
              Text(
                "Data Pesagem:",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF44403C),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () => !widget.readOnly ? _selectDate(context) : null,
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: widget.readOnly,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.primaryGreen,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: TextEditingController(
                      text: _selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                          : '',
                    ),
                  ),
                ),
              ),
              if (!widget.readOnly)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                        onPressed: () {
                          final weight = double.tryParse(_weightController.text
                              .replaceAll('.', '')
                              .replaceAll(',', '.'));
                          if (weight == null || weight <= 0) {
                            AlertManager.showToast(
                                'Por favor, insira um peso válido.');
                            return;
                          }
                          widget.store.weightController.text =
                              weight.toStringAsFixed(2);
                          widget.store.updateWeightHandlingDate(
                              _selectedDate ?? DateTime.now());

                          widget.store.finish(context);
                        },
                        child: Text(
                          widget.store.model != null ? 'Salvar' : 'Cadastrar',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        })
      ],
    );
  }
}
