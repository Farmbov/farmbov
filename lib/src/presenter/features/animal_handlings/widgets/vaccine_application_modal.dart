import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/presenter/shared/modals/base_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../common/themes/theme_constants.dart';
import '../../../../domain/models/vaccine_model.dart';
import '../animal_handling_update/animal_handling_update_page_store.dart';
import 'animal_card.dart';
import 'search_animal_to_card.dart';

class VaccineApplicationModal extends StatefulWidget {
  final AnimalHandlingUpdatePageStore store;
  final bool readOnly;

  const VaccineApplicationModal({
    super.key,
    required this.store,
    this.readOnly = false,
  });

  @override
  _VaccineApplicationModalState createState() =>
      _VaccineApplicationModalState();
}

class _VaccineApplicationModalState extends State<VaccineApplicationModal> {
  String? _selectedVaccineId;
  VaccineModel? _selectedVaccine;
  DateTime? _selectedDate;

  final TextEditingController _searchAnimalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.store.healthHandlingDate;
  }

  @override
  void dispose() {
    _searchAnimalController.dispose();
    super.dispose();
  }

  Future<List<VaccineModel>> _fetchAvailableVaccines() async {
    final vaccinesCollection = FirebaseFirestore.instance
        .collection('farms')
        .doc(AppManager.instance.currentUser.currentFarm?.id)
        .collection('vaccines');

    final querySnapshot = await vaccinesCollection.get();

    List<VaccineModel> vaccines = querySnapshot.docs
        .map((doc) => VaccineModel.fromJson(doc.data(), doc.reference))
        .toList();

    vaccines.sort((a, b) => a.name!.compareTo(b.name ?? ""));

    return vaccines;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        title: widget.readOnly
            ? 'Detalhes da Aplicação'
            : 'Editar Aplicação de Vacina',
        children: [
          Observer(
            builder: (context) {
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
                    "Selecione uma vacina:",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF44403C),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  FutureBuilder<List<VaccineModel>>(
                    future: _fetchAvailableVaccines(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Erro ao carregar vacinas');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('Nenhuma vacina disponível');
                      }

                      final vaccines = snapshot.data!;

                      // Para recuperar a vacina caso seja edição ou vizualização
                      if (_selectedVaccine == null) {
                        _selectedVaccineId = vaccines
                            .where((vaccine) =>
                                vaccine.name?.toLowerCase() ==
                                widget.store.model?.vaccine)
                            .firstOrNull
                            ?.ref
                            ?.id;
                      }

                      return DropdownButtonFormField<String>(
                        hint: const Text('Escolha uma vacina...'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(width: 1, color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(width: 1, color: Colors.grey),
                          ),
                        ),
                        // hint: const Text("Selecione uma vacina"),
                        value: _selectedVaccineId,
                        isExpanded: true,
                        items: vaccines.map((vaccine) {
                          return DropdownMenuItem<String>(
                            value: vaccine.ref?.id,
                            child: Text(vaccine.name!),
                          );
                        }).toList(),
                        onChanged: widget.readOnly
                            ? null
                            : (newId) {
                                setState(() {
                                  _selectedVaccineId = newId;
                                  _selectedVaccine = vaccines
                                      .firstWhere((v) => v.ref?.id == newId);
                                });
                              },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Data da aplicação da vacina:",
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
                    onTap: !widget.readOnly ? () => _selectDate(context) : null,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.primaryGreen,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(width: 1, color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(width: 1, color: Colors.grey),
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
                            onPressed: _selectedVaccineId == null
                                ? null
                                : () {
                                    widget.store.finishSanitario(
                                      context,
                                      selectedVaccine: _selectedVaccine!,
                                      handlingDate:
                                          _selectedDate ?? DateTime.now(),
                                    );
                                  },
                            child: const Text(
                              'Aplicar Vacina',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              );
            },
          )
        ]);
  }
}
