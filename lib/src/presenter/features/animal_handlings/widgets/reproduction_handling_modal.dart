import 'package:farmbov/src/presenter/features/animal_handlings/widgets/search_animal_to_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import '../../../shared/components/custom_date_picker.dart';
import '../../../shared/modals/base_modal_bottom_sheet.dart';
import '../animal_handling_update/animal_handling_update_page_store.dart';
import 'animal_card.dart';

class ReproductionHandlingModal extends StatefulWidget {
  final AnimalHandlingUpdatePageStore store;
  final bool readOnly;

  const ReproductionHandlingModal({
    super.key,
    required this.store,
    this.readOnly = false,
  });

  @override
  State<ReproductionHandlingModal> createState() =>
      _ReproductionHandlingModalState();
}

class _ReproductionHandlingModalState extends State<ReproductionHandlingModal> {
  final TextEditingController _searchMaleAnimalController =
      TextEditingController();

  final TextEditingController _searchFemaleAnimalController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchMaleAnimalController.dispose();
    _searchFemaleAnimalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;

    final currentRoute =
        GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();

    return BaseModalBottomSheet(
        showCloseButton: true,
        title: widget.readOnly
            ? "Detalhes Manejo"
            : store.model == null
                ? 'Novo Manejo Reprodutivo'
                : 'Editar Manejo Reprodutivo',
        children: [
          Observer(
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                if (widget.store.animal == null &&
                    currentRoute.contains('/animais/manejos/')) ...[
                  _buildSearchFemaleAnimal(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
                if (widget.store.animal != null &&
                    currentRoute.contains('/animais/manejos/'))
                  _buildFemaleAnimalCard(context),
                if (widget.store.selectedMaleAnimal == null)
                  _buildSearchMaleAnimal(),
                if (widget.store.selectedMaleAnimal != null)
                  _buildMaleAnimalCard(context),
                const SizedBox(height: 10),
                _buildHandlingDate(),
                const SizedBox(height: 10),
                _buildPregnancyDropdown(),
                if (widget.store.isPregnant) _buildPregnancyDetails(),
                const SizedBox(height: 20),
                if (!widget.readOnly) _buildButtons(context),
              ],
            ),
          ),
        ]);
  }

  /// Busca para o animal reprodutor (macho)
  Widget _buildSearchMaleAnimal() {
    return SearchAnimalToCard(
      title: 'Escolha o Animal Macho Reprodutor:',
      searchController: _searchMaleAnimalController,
      onAnimalSelected: widget.store.updateSelectedMaleAnimal,
      onlyMales: true,
      onlyFemales: false,
    );
  }

  /// Busca para o animal fêmea
  Widget _buildSearchFemaleAnimal() {
    return SearchAnimalToCard(
        title: 'Escolha o Animal Fêmea:',
        searchController: _searchFemaleAnimalController,
        onAnimalSelected: widget.store.updateSelectedAnimal,
        onlyFemales: true,
        onlyMales: false);
  }

  // Card para o animal reprodutor (macho)
  Widget _buildMaleAnimalCard(BuildContext context) {
    return AnimalCard(
      title: 'Animal Macho Reprodutor Escolhido',
      animal: widget.store.selectedMaleAnimal,
      onRemove: !widget.readOnly
          ? () {
              widget.store.updateSelectedMaleAnimal(null);
            }
          : null,
    );
  }

  // Card para o animal fêmea
  Widget _buildFemaleAnimalCard(BuildContext context) {
    return AnimalCard(
      title: 'Animal Fêmea Escolhido',
      animal: widget.store.animal,
      onRemove: () => widget.store.updateSelectedAnimal(null),
    );
  }

  Widget _buildHandlingDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data do manejo reprodutivo:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF44403C),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 5),
        CustomDatePicker(
          readOnly: widget.readOnly,
          labelText: 'Data do manejo reprodutivo',
          initialDate: widget.store.reproductionHandlingDate,
          onDateSelected: !widget.readOnly
              ? widget.store.updateReproductionHandlingDate
              : (date) {},
        ),
      ],
    );
  }

  Widget _buildPregnancyDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fêmea está prenha?',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF44403C),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<bool>(
          padding: EdgeInsets.zero,
          value: widget.store.isPregnant,
          onChanged: !widget.readOnly
              ? (pregnant) {
                  widget.store.updatePregnancyStatus(pregnant ?? false);
                }
              : null,
          items: ['Sim', 'Não']
              .map((value) => DropdownMenuItem<bool>(
                    value: value == 'Sim',
                    child: Text(value),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPregnancyDetails() {
    final birthLikelyDate =
        widget.store.pregnantLikelyDate?.add(const Duration(days: 30 * 9));
    final remaningDays = birthLikelyDate?.difference(DateTime.now());

    final dateFormatter = DateFormat('dd/MM/yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Provável da Prenhez:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF44403C),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 5),
        CustomDatePicker(
            readOnly: widget.readOnly,
            labelText: 'Data da provável prenhez',
            initialDate: widget.store.pregnantLikelyDate,
            onDateSelected: !widget.readOnly
                ? widget.store.updatePregnantLikelyDate
                : (date) {}),
        if (widget.store.pregnantLikelyDate != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Provável data do parto: ${dateFormatter.format(birthLikelyDate!)}',
                style: const TextStyle(color: Color(0xFF518159)),
              ),
              if (widget.readOnly)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Dias restantes até o parto:',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF44403C),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      initialValue: '${remaningDays?.inDays} dias',
                      readOnly: widget.readOnly,
                      mouseCursor: MouseCursor.defer,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Color(0xffD7D3D0),
                          width: 1,
                        ),
                      )),
                    )
                  ],
                )
            ],
          ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => GoRouter.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)))),
          onPressed: () {
            widget.store.finish(context);
          },
          child: Text(
            widget.store.model != null ? 'Salvar' : 'Cadastrar',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
