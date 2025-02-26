import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/models/drug_administration_type.dart';
import '../../../../domain/models/vaccine_model.dart';
import '../../../shared/modals/base_modal_bottom_sheet.dart';
import 'vaccines_configuration_page_store.dart';

class VaccineModal extends StatefulWidget {
  final VaccineModel? vaccine;
  final VaccinesConfigurationPageStore store;

  const VaccineModal({super.key, this.vaccine, required this.store});

  @override
  VaccineModalState createState() => VaccineModalState();
}

class VaccineModalState extends State<VaccineModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController dosesRequiredController;
  late TextEditingController intervalBetweenDosesController;
  late TextEditingController storageConditionsController;

  DrugAdministrationType? selectedDrugAdministrationType;

  late CollectionReference? collectionReference;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.vaccine?.name ?? "");
    descriptionController =
        TextEditingController(text: widget.vaccine?.description ?? "");
    dosesRequiredController = TextEditingController(
        text: widget.vaccine?.dosesRequired?.toString() ?? "");
    intervalBetweenDosesController = TextEditingController(
        text: widget.vaccine?.intervalBetweenDosesInDays?.toString() ?? "");
    storageConditionsController =
        TextEditingController(text: widget.vaccine?.storageConditions ?? "");

    if (widget.vaccine == null) {
      collectionReference = FirebaseFirestore.instance
          .collection('farms')
          .doc('${AppManager.instance.currentUser.currentFarm?.id}')
          .collection('vaccines');
    }
  }

  @override
  void didChangeDependencies() async {
    if (widget.vaccine != null) {
      final admVaccineType = await widget.store
          .getAdmType(widget.vaccine!.drugAdministrationType!);
      setState(() {
        selectedDrugAdministrationType = widget.store.drugAdministrationTypes
            .where((element) => element.ref?.id == admVaccineType.ref?.id)
            .first;
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    dosesRequiredController.dispose();
    intervalBetweenDosesController.dispose();
    storageConditionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseModalBottomSheet(
        title: widget.vaccine == null ? 'Criar Vacina' : 'Editar Vacina',
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Nome',
                        labelText: 'Nome',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: .1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o nome';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        hintText: 'Descrição',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: .1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a descrição';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: dosesRequiredController,
                      decoration: const InputDecoration(
                        labelText: 'Doses Necessárias',
                        hintText: 'Doses Necessárias',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: .1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (int.tryParse(value) == null) {
                          dosesRequiredController.text = "";
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o número de doses necessárias';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Por favor, insira um número inteiro';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: intervalBetweenDosesController,
                      decoration: const InputDecoration(
                        labelText: 'Intervalo entre Doses (dias)',
                        hintText: 'Intervalo entre Doses (dias)',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: .1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      onChanged: (value) {
                        if (int.tryParse(value) == null) {
                          intervalBetweenDosesController.text = "";
                        }
                      },
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o intervalo entre doses';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Por favor, insira um número inteiro';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<DrugAdministrationType>(
                      value: selectedDrugAdministrationType,
                      decoration: const InputDecoration(
                        labelText: 'Via de Administração',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: .1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      items: widget.store.drugAdministrationTypes
                          .map((drugAdmType) {
                        return DropdownMenuItem<DrugAdministrationType>(
                          value: drugAdmType,
                          child: Text(drugAdmType.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal),),

                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedDrugAdministrationType = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, selecione a via de administração';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: storageConditionsController,
                      decoration: const InputDecoration(
                        labelText: 'Condições de Armazenamento',
                        hintText: 'Condições de Armazenamento',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: .1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira as condições de armazenamento';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              late VaccineModel vaccine;
                              if (widget.vaccine == null) {
                                vaccine = VaccineModel.empty();
                              } else {
                                vaccine = widget.vaccine!;
                              }

                              vaccine = vaccine.copyWith(
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  dosesRequired: int.tryParse(
                                      dosesRequiredController.text),
                                  intervalBetweenDosesInDays: int.tryParse(
                                      intervalBetweenDosesController.text),
                                  drugAdministrationType:
                                      selectedDrugAdministrationType?.ref?.id,
                                  storageConditions:
                                      storageConditionsController.text,
                                  isActive: true);

                              if (widget.vaccine == null) {
                                widget.store.addVaccine(vaccine);
                              } else {
                                widget.store.updateVaccine(vaccine);
                              }

                              GoRouter.of(context).pop();
                            }
                          },
                          child: Text(
                            widget.vaccine == null
                                ? 'Criar Vacina'
                                : 'Salvar Alterações',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]);
  }
}
