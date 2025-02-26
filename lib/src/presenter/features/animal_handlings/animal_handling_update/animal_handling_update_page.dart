import 'package:farmbov/src/common/helpers/custom_validators.dart';
import 'package:farmbov/src/common/helpers/strings_helpers.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/models/vaccine_model.dart';
import 'package:farmbov/src/domain/repositories/vaccine_repository.dart';
import 'package:farmbov/src/presenter/features/search_animal/search_animal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:farmbov/src/domain/constants/animal_handling_types.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';
import 'package:farmbov/src/presenter/features/animal_handlings/animal_handling_update/animal_handling_update_page_store.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:farmbov/src/presenter/shared/modals/base_modal_bottom_sheet.dart';

import '../../../shared/components/custom_date_picker.dart';

class AnimalHandlingUpdatePage extends StatefulWidget {
  final AnimalHandlingUpdatePageStore store;

  const AnimalHandlingUpdatePage({super.key, required this.store});

  @override
  AnimalHandlingUpdatePageState createState() =>
      AnimalHandlingUpdatePageState();
}

class AnimalHandlingUpdatePageState extends State<AnimalHandlingUpdatePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    widget.store.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Widget> _manejoPesagem() {
    final store = widget.store;
    return [
      const SizedBox(height: 16),
      FFInput(
        floatingLabel: 'Peso (Kg)',
        labelText: 'Peso (Kg)',
        controller: widget.store.weightController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: MultiValidator([
          DefaultRequiredValidator(),
          // TODO: fix
          // RangeValidator(
          //     min: 0,
          //     max: 20000,
          //     errorText: 'A quantidade deve estar entre 0 e 20000'),
        ]).call,
      ),
      const SizedBox(height: 16),
      Text(
        'Data da pesagem',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF44403C),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
      ),
      CustomDatePicker(
        labelText: 'Selecione um data',
        initialDate: store.weightHandlingDate,
        onDateSelected: (DateTime date) {
          store.updateWeightHandlingDate(date);
        },
      ),
    ];
  }

  List<Widget> _manejoSanitario() {
    final store = widget.store;
    return [
      const SizedBox(height: 16),
      Text(
        'Data da Aplicação da Vacina',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF44403C),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
      ),
      CustomDatePicker(
        labelText: 'Selecione um data',
        initialDate: store.healthHandlingDate ?? DateTime.now(),
        onDateSelected: store.updateHealthHandlingDate,
      ),
      const SizedBox(height: 16),
      Text(
        'Vacina:',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF44403C),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
      ),
      const SizedBox(height: 4),
      FutureBuilder<List<VaccineModel>>(
        future: VaccineRepositoryImpl().listVaccines(),
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

          final vacinaList = snapshot.data;

          if (vacinaList == null || vacinaList.isEmpty) {
            return Text(
              'Nenhuma vacina encontrada',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF292524),
                  ),
              textAlign: TextAlign.start,
            );
          }

          return DropdownButtonFormField<String?>(
            value: store.vaccine,
            decoration: InputDecoration(
                labelText: 'Selecione a vacina',
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 16),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10)),
            onChanged: store.updateVaccine,
            items: vacinaList.map((option) {
              var selected = option.name;
              if (!vacinaList.contains(option)) {
                selected = '';
              }
              return DropdownMenuItem<String?>(
                value: selected,
                child: Text(option.name ?? '-'),
              );
            }).toList(),
            validator: NotNullRequiredValidator(
              errorText: 'Este campo é obrigatório.',
            ).call,
          );
        },
      ),
    ];
  }

  List<Widget> _manejoReprodutivo() {
    final store = widget.store;
    return [
      if (store.selectedMaleAnimal == null) ...[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Escolha o macho reprodutor:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF44403C),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 5),
            SearchAnimalWidget(
              searchController: _searchController,
              onAnimalSelected: store.updateSelectedMaleAnimal,
              onlyMales: true,
            ),
          ],
        ),
      ] else ...[
        store.selectedMaleAnimal == null
            ? Text(
                'Animal não encontrado',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF292524),
                    ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Informações do animal macho reprodutor selecionado',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          color: const Color(0xFF292524),
                        ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 6),
                  _animalDetails(
                    'Brinco do macho reprodutor :',
                    store.selectedMaleAnimal?.tagNumber ?? '-',
                  ),
                  const Divider(),
                  _animalDetails(
                    'Lote:',
                    store.selectedMaleAnimal?.lot ?? '-',
                  ),
                  const Divider(),
                  if (store.isLastStep) ...[
                    _animalDetails(
                      'Manejo:',
                      store.handlingType?.name.capitalize() ?? '-',
                    ),
                    const Divider(),
                  ],
                ],
              )
      ],
      const SizedBox(height: 16),
      Text(
        'Data do manejo reprodutivo',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF44403C),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
      ),
      CustomDatePicker(
          labelText: 'Selecione um data',
          initialDate: store.reproductionHandlingDate,
          onDateSelected: widget.store.updateReproductionHandlingDate),
      const SizedBox(height: 16),
      Text(
        'Fêmea está prenha:',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF44403C),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
      ),
      const SizedBox(height: 4),
      Observer(builder: (context) {
        return DropdownButtonFormField<bool>(
          value: store.isPregnant,
          decoration: InputDecoration(
              labelText: 'Selecione',
              labelStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 16),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 10)),
          onChanged: (pregnant) {
            widget.store.updatePregnancyStatus(pregnant ?? false);
          },
          items: ['Sim', 'Não']
              .map<DropdownMenuItem<bool>>(
                (String value) => DropdownMenuItem<bool>(
                  value: value == 'Sim' ? true : false,
                  child: Text(
                    value,
                  ),
                ),
              )
              .toList(),
        );
      }),
      const SizedBox(
        height: 5,
      ),
      if (store.isPregnant) ...[
        const SizedBox(height: 16),
        Text(
          'Data da provável prenhez',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF44403C),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
        ),
        CustomDatePicker(
          labelText: 'Selecione um data',
          initialDate: store.pregnantLikelyDate,
          onDateSelected: (DateTime date) {
            widget.store.updatePregnantLikelyDate(date);
          },
        ),
        Observer(builder: (context) {
          final dateFormatter = DateFormat('dd/MM/yyyy');

          DateTime? birthLikelyDate =
              store.pregnantLikelyDate?.add(const Duration(days: 30 * 9));

          if (store.pregnantLikelyDate != null) {
            var date = dateFormatter.format(birthLikelyDate!);

            return Text(
              'Provável data do parto: $date',
              style:
                  const TextStyle(fontSize: 15, color: AppColors.primaryGreen),
            );
          }
          return const SizedBox();
        }),
        const SizedBox(
          height: 5,
        )
      ]
    ];
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

  @override
  Widget build(BuildContext context) {
    final store = widget.store;

    return Observer(
      builder: (context) {
        return BaseModalBottomSheet(
          showCloseButton: true,
          title: (store.model == null ? 'Adicionar manejo' : 'Editar manejo'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Form(
              key: store.formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (store.isLastStep) ...[
                    if (store.handlingType == AnimalHandlingTypes.pesagem) ...[
                      ..._manejoPesagem(),
                    ] else if (store.handlingType ==
                        AnimalHandlingTypes.sanitario) ...[
                      ..._manejoSanitario(),
                    ] else if (store.handlingType ==
                        AnimalHandlingTypes.reprodutivo) ...[
                      ..._manejoReprodutivo(),
                    ]
                  ] else ...[
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
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 10)),
                      onChanged: store.animal == null
                          ? (type) {
                              _searchController.text = "";
                              store.updateHandlingType(type);
                            }
                          : null,
                      validator: (_) => store.handlingType == null
                          ? 'Campo obrigatório.'
                          : null,
                      items: animalHandlingTypes
                          .map<DropdownMenuItem<AnimalHandlingTypes>>(
                            (AnimalHandlingTypes type) =>
                                DropdownMenuItem<AnimalHandlingTypes>(
                              value: type,
                              child: Text(
                                type.name,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (store.animal == null) ...[
                    Observer(builder: (context) {
                      return Visibility(
                        visible: store.handlingType != null ? true : false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Escolha o animal${store.handlingType == AnimalHandlingTypes.reprodutivo ? ' fêmea:' : ':'}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
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
                                searchController: _searchController),
                          ],
                        ),
                      );
                    })
                  ] else ...[
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
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
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
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Informações do animal selecionado',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontSize: 16,
                                    color: const Color(0xFF292524),
                                  ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 6),
                            _animalDetails(
                              'Sexo do animal:',
                              animal.sex ?? '-',
                            ),
                            const Divider(),
                            _animalDetails(
                              'Brinco do animal:',
                              animal.tagNumber ?? '-',
                            ),
                            const Divider(),
                            _animalDetails(
                              'Lote:',
                              animal.lot ?? '-',
                            ),
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
                ],
              ),
            ),
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
                      if (store.isLastStep) {
                        if ((store.handlingType ==
                                AnimalHandlingTypes.reprodutivo &&
                            store.selectedMaleAnimal == null)) {
                          store.showErrorModal(context);
                        } else {
                          widget.store.finish(
                            context,
                          );
                        }
                      } else {
                        store.updateIsLastStep(true);
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
                context.pop();
              },
              backgroundColor: Colors.transparent,
              borderColor: AppColors.primaryGreen,
              splashColor: AppColors.primaryGreen.withOpacity(0.1),
            ),
          ],
        );
      },
    );
  }
}
