import 'package:collection/collection.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:farmbov/src/common/helpers/custom_validators.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/models/firestore/animal_breed_model.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input_date_picker.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobx_triple/mobx_triple.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:farmbov/src/presenter/shared/modals/base_modal_bottom_sheet.dart';
import 'package:farmbov/src/domain/constants/animal_sex.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';
import 'package:farmbov/src/domain/models/firestore/lot_model.dart';
import 'package:farmbov/src/presenter/features/animals/animal_update/animal_update_page_model.dart';
import 'package:farmbov/src/presenter/features/animals/animal_update/animal_update_page_store.dart';
import 'package:farmbov/src/presenter/shared/components/image_network_preview.dart';

import '../../../../common/router/route_name.dart';
import '../../../shared/modals/base_alert_modal.dart';

class AnimalUpdatePage extends StatefulWidget {
  final AnimalModel? model;
  final AnimalUpdatePageStore store;

  const AnimalUpdatePage({
    super.key,
    required this.store,
    this.model,
  });

  @override
  AnimalUpdatePageState createState() => AnimalUpdatePageState();
}

class AnimalUpdatePageState extends State<AnimalUpdatePage> {
  final NumberFormat weightFormatter = NumberFormat('#,##0.00', 'pt_BR');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final tagNumberController = TextEditingController();
  final tagNumberRFIDController = TextEditingController();
  final momTagNumberController = TextEditingController();
  final dadTagNumberController = TextEditingController();
  final weightController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '',
    precision: 2,
  );

  final sexController = TextEditingController();
  final breedController = TextEditingController();
  final lotController = TextEditingController();

  final notesController = TextEditingController();

  //Dates Controller
  final birthDateController = TextEditingController();
  final entryDateController = TextEditingController();
  final weightingDateController = TextEditingController();

  final dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    widget.store.init(model: widget.model);
    if (widget.model != null) {
      tagNumberController.text = widget.model?.tagNumber ?? '';
      tagNumberRFIDController.text = widget.model?.tagNumberRFID ?? '';
      momTagNumberController.text = widget.model?.momTagNumber ?? '';
      dadTagNumberController.text = widget.model?.dadTagNumber ?? '';
      weightController.text = weightFormatter.format(widget.model?.weight);

      sexController.text = widget.model?.sex ?? '';
      breedController.text = widget.model?.breed ?? '';
      lotController.text = widget.model?.lot ?? '';

      birthDateController.text = widget.model!.birthDate != null
          ? dateFormat.format(widget.model!.birthDate!)
          : "";
      entryDateController.text = widget.model!.entryDate != null
          ? dateFormat.format(widget.model!.entryDate!)
          : "";
      weightingDateController.text = widget.model!.weighingDate != null
          ? dateFormat.format(widget.model!.weighingDate!)
          : "";

      notesController.text = widget.model!.notes ?? '';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndShowAlerts(context);
    });
  }

  @override
  void dispose() {
    tagNumberController.dispose();
    tagNumberRFIDController.dispose();
    momTagNumberController.dispose();
    dadTagNumberController.dispose();
    weightController
        .dispose(); // MoneyMaskedTextController também precisa de dispose
    sexController.dispose();
    breedController.dispose();
    lotController.dispose();
    notesController.dispose();
    birthDateController.dispose();
    entryDateController.dispose();
    weightingDateController.dispose();
    super.dispose();
  }

  Future<void> checkAndShowAlerts(BuildContext context) async {
    String? farmId = AppManager.instance.currentUser.currentFarm!.id;
    // Funções para verificar se há áreas e lotes ativos
    bool hasActiveLots = await _hasActiveDocuments('farms/$farmId/lots');

    if (!hasActiveLots) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => BaseAlertModal(
            type: BaseModalType.warning,
            title: 'Nenhum lote encontrado',
            description: 'Você precisa criar um lote ativo para continuar.',
            actionButtonTitle: 'Criar Lote',
            canPop: true,
            cancelCallback: (){
              context.pop();
              context.pop();
            },
            actionCallback: () {
              context.pop();
              context.pop();
              context.pushNamed(RouteName.lots);
            }),
      );
    }
  }

// Função para verificar documentos ativos no Firestore
  Future<bool> _hasActiveDocuments(String collectionPath) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(collectionPath)
        .where('active', isEqualTo: true)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  bool _isCreateView() => widget.model == null;

  Widget _earTagWidget(BuildContext context) => FFInput(
        floatingLabel: 'Número do brinco*',
        labelText: 'Número do brinco*',
        controller: tagNumberController,
        validator: MultiValidator(
          [
            DefaultRequiredValidator(),
            LengthRangeValidator(
              min: 2,
              max: 512,
              errorText: 'O campo deve ter entre 2 e 512 caracteres.',
            ),
          ],
        ).call,
      );

  Widget _rfidEarTagWidget(BuildContext context) => FFInput(
        floatingLabel: 'Brinco RFID',
        labelText: 'Brinco RFID',
        controller: tagNumberRFIDController,
        validator: MultiValidator(
          [
            LengthRangeValidator(
              min: tagNumberRFIDController.text.isEmpty ? 0 : 2,
              max: 512,
              errorText: 'O campo deve ter entre 2 e 512 caracteres.',
            ),
          ],
        ).call,
      );

  Widget _momEarTagWidget(BuildContext context) => FFInput(
        floatingLabel: 'Número do brinco da mãe',
        labelText: 'Número do brinco da mãe',
        controller: momTagNumberController,
        validator: MultiValidator([
          LengthRangeValidator(
              min: 0,
              max: 512,
              errorText: 'O campo deve ter no máximo 512 caracteres.')
        ]).call,
      );

  Widget _dadEarTagWidget(BuildContext context) => FFInput(
        floatingLabel: 'Número do brinco do pai',
        labelText: 'Número do brinco do pai',
        controller: dadTagNumberController,
        validator: MultiValidator([
          LengthRangeValidator(
              min: 0,
              max: 512,
              errorText: 'O campo deve ter no máximo 512 caracteres.')
        ]).call,
      );

  @override
  Widget build(BuildContext context) {
    return TripleBuilder(
      store: widget.store,
      builder: (context, Triple<AnimalUpdatePageModel> model) =>
          BaseModalBottomSheet(
        showCloseButton: true,
        title: _isCreateView() ? 'Adicionar animal' : 'Editar animal',
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informações de cadastro',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: const Color(0xFF292524),
                      ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                // TODO: maybe use a package to handle Cols
                if (ResponsiveBreakpoints.of(context).isMobile) ...[
                  _earTagWidget(context),
                  const SizedBox(height: 16),
                  _rfidEarTagWidget(context)
                ] else ...[
                  Row(
                    children: [
                      Flexible(child: _earTagWidget(context)),
                      const SizedBox(width: 8),
                      Flexible(child: _rfidEarTagWidget(context))
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                // TODO: maybe use a package to handle Cols
                if (ResponsiveBreakpoints.of(context).isMobile) ...[
                  _momEarTagWidget(context),
                  const SizedBox(height: 16),
                  _dadEarTagWidget(context)
                ] else ...[
                  Row(
                    children: [
                      Flexible(child: _momEarTagWidget(context)),
                      const SizedBox(width: 8),
                      Flexible(child: _dadEarTagWidget(context))
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                FFInput(
                  floatingLabel: 'Peso (Kg)',
                  labelText: 'Peso (Kg)',
                  controller: weightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  // TODO: fix
                  // validator: MultiValidator([
                  //   RangeValidator(
                  //       min: 0,
                  //       max: 20000,
                  //       errorText: 'A quantidade deve estar entre 0 e 20000'),
                  // ]),
                ),
                const SizedBox(height: 16),
                Text(
                  'Sexo*:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF44403C),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: model.state.selectedSex,
                  decoration: InputDecoration(
                      labelText: 'Sexo do animal',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),

                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 10)),
                  onChanged: (sex) {
                    sexController.text = sex!;
                  },
                  items: animalSexList
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ),
                        ),
                      )
                      .toList(),
                  validator: NotNullRequiredValidator(
                          errorText: 'Este campo é obrigatório.')
                      .call,
                ),
                const SizedBox(height: 16),
                Text(
                  'Raça*:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF44403C),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                FutureBuilder<List<AnimalBreedModel>>(
                  future: getAnimalsBreedsWithDefault(),
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

                    var racaRacaRecordList = snapshot.data;

                    if (racaRacaRecordList == null ||
                        racaRacaRecordList.isEmpty) {
                      return Text(
                        'Nenhuma raça encontrada',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: const Color(0xFF292524),
                                ),
                        textAlign: TextAlign.start,
                      );
                    }

                    final raca = racaRacaRecordList
                        .firstWhereOrNull(
                          (raca) =>
                              raca.name!.toLowerCase() ==
                              model.state.selectedBreed?.toLowerCase(),
                        )
                        ?.name;

                    return DropdownButtonFormField<String?>(
                      value: raca,
                      decoration: InputDecoration(
                        labelText: 'Raça do animal',
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        
                      ),
                      onChanged: (breed) {
                        breedController.text = breed!;
                      },
                      items: racaRacaRecordList.map((option) {
                        return DropdownMenuItem<String?>(
                          value: option.name,
                          child: Text(option.name ?? '-'),
                        );
                      }).toList(),
                      validator: NotNullRequiredValidator(
                              errorText: 'Este campo é obrigatório.')
                          .call,
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Lote*:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF44403C),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                StreamBuilder<List<LotModel>>(
                  stream: queryLotModel(),
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

                    final loteList = snapshot.data;
                    //Remove da listagem os lotes "deletados" == lot.active sendo false
                    loteList?.removeWhere((element) => element.active == false);

                    if (loteList == null || loteList.isEmpty) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Nenhum lote encontrado ',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: const Color(0xFF292524),
                                ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.go(RouteName.lots);
                            },
                            child: Text(
                              'Criar Lote!',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryGreen,
                                  ),
                            ),
                          ),
                        ],
                      );
                    }

                    return DropdownButtonFormField<String?>(
                      value: model.state.selectedLot,
                      decoration: InputDecoration(
                        labelText: 'Selecione o lote',
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        
                      ),
                      onChanged: (lot) {
                        lotController.text = lot!;
                      },
                      items: loteList.map((option) {
                        var selected = option.name;
                        if (!loteList.contains(option)) {
                          selected = '';
                        }

                        return DropdownMenuItem<String?>(
                          value: selected,
                          child: Text(option.name ?? '-'),
                        );
                      }).toList(),
                      validator: NotNullRequiredValidator(
                              errorText: 'Este campo é obrigatório.')
                          .call,
                    );
                  },
                ),
                const SizedBox(height: 16),

                FFInputDatePicker(
                  floatingLabel: 'Data de nascimento',
                  labelText: 'Selecione um data',
                  initDate: model.state.selectedBirthDate,
                  onSelectDate: (DateTime date) {
                    birthDateController.text = dateFormat.format(date);
                  },
                  validator: MultiValidator([
                    DefaultRequiredValidator(),
                    LessThanDateValidator(
                      afterDate: entryDateController.text.isNotEmpty
                          ? format.parse(entryDateController.text)
                          : null,
                      afterDateLabel: 'Data de entrada',
                    ),
                  ]).call,
                ),
                const SizedBox(height: 16),
                FFInputDatePicker(
                  floatingLabel: 'Data de entrada do animal',
                  labelText: 'Selecione uma data',
                  initDate: model.state.selectedEntryDate,
                  onSelectDate: (DateTime date) {
                    entryDateController.text = dateFormat.format(date);
                  },
                  validator: MultiValidator([
                    DefaultRequiredValidator(),
                    GreaterOrEqualThanDateValidator(
                      beforeDate: birthDateController.text.isNotEmpty
                          ? format.parse(birthDateController.text)
                          : null,
                      beforeDateLabel: 'Data de nascimento',
                    ),
                  ]).call,
                ),

                const SizedBox(height: 16),

                FFInputDatePicker(
                  floatingLabel: 'Data de pesagem',
                  labelText: 'Selecione um data',
                  initDate: model.state.selectedWeighingDate,
                  onSelectDate: (DateTime date) {
                    weightingDateController.text = dateFormat.format(date);
                  },
                  validator: MultiValidator(
                    model.state.selectedWeighingDate == null
                        ? [
                            GreaterOrEqualThanDateValidator(
                              beforeDate: entryDateController.text.isNotEmpty
                                  ? format.parse(entryDateController.text)
                                  : null,
                              beforeDateLabel: 'Data de entrada',
                            ),
                          ]
                        : [
                            DefaultRequiredValidator(),
                            GreaterOrEqualThanDateValidator(
                              beforeDate: entryDateController.text.isNotEmpty
                                  ? format.parse(entryDateController.text)
                                  : null,
                              beforeDateLabel: 'Data de entrada',
                            ),
                          ],
                  ).call,
                ),
                const SizedBox(height: 16),
                Text(
                  'Observações:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF292524),
                      ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                FFInput(
                  labelText: 'Possui alguma observação sobre o animal?',
                  controller: notesController,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                // TODO: Create component
                InkWell(
                  onTap: () => widget.store.uploadImage(context),
                  splashColor: AppColors.primaryGreen.withOpacity(0.1),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFE7E5E4),
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: MediaQuery.of(context).size.width,
                    padding: model.state.uploadedFileUrl?.isEmpty ?? true
                        ? const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          )
                        : EdgeInsets.zero,
                    child: model.state.isMediaUploading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : model.state.uploadedFileUrl?.isEmpty ?? true
                            ? Column(
                                children: [
                                  const Icon(
                                    Icons.upload_outlined,
                                    color: Color(0xFF57534E),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Clique para enviar o arquivo',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryGreenDark,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'SVG, PNG, JPG or GIF (max. 800x400px)',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: const Color(0xFF57534E),
                                        ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: ImageNetworkPreview(
                                    imageUrl: model.state.uploadedFileUrl!),
                              ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          FFButton(
            text: _isCreateView() ? 'Cadastrar animal' : 'Atualizar animal',
            loading: widget.store.isLoading,
            onPressed: () {
              final animalFormControllers = AnimalFormControllers(
                tagNumberController: tagNumberController,
                tagNumberRFIDController: tagNumberRFIDController,
                momTagNumberController: momTagNumberController,
                dadTagNumberController: dadTagNumberController,
                weightController: weightController,
                sexController: sexController,
                breedController: breedController,
                lotController: lotController,
                notesController: notesController,
                birthDateController: birthDateController,
                entryDateController: entryDateController,
                weightingDateController: weightingDateController,
              );
              _isCreateView()
                  ? widget.store
                      .insert(context, _formKey, animalFormControllers)
                  : widget.store.edit(
                      widget.model!, context, _formKey, animalFormControllers);
            },
          ),
          if (ResponsiveBreakpoints.of(context).isMobile) ...[
            const SizedBox(height: 16),
            FFButton(
              text: 'Cancelar',
              type: FFButtonType.outlined,
              onPressed: () => context.pop(),
              backgroundColor: Colors.transparent,
              borderColor: AppColors.primaryGreen,
              splashColor: AppColors.primaryGreen.withOpacity(0.1),
            ),
          ],
        ],
      ),
    );
  }
}

class AnimalFormControllers {
  final TextEditingController tagNumberController;
  final TextEditingController tagNumberRFIDController;
  final TextEditingController momTagNumberController;
  final TextEditingController dadTagNumberController;
  final MoneyMaskedTextController weightController;
  final TextEditingController sexController;
  final TextEditingController breedController;
  final TextEditingController lotController;
  final TextEditingController notesController;
  final TextEditingController birthDateController;
  final TextEditingController entryDateController;
  final TextEditingController weightingDateController;

  AnimalFormControllers({
    required this.tagNumberController,
    required this.tagNumberRFIDController,
    required this.momTagNumberController,
    required this.dadTagNumberController,
    required this.weightController,
    required this.sexController,
    required this.breedController,
    required this.lotController,
    required this.notesController,
    required this.birthDateController,
    required this.entryDateController,
    required this.weightingDateController,
  });

  // Método para limpar os controllers (se necessário)
  void clear() {
    tagNumberController.clear();
    tagNumberRFIDController.clear();
    momTagNumberController.clear();
    dadTagNumberController.clear();
    weightController.updateValue(0); // Para MoneyMaskedTextController
    sexController.clear();
    breedController.clear();
    lotController.clear();
    notesController.clear();
    birthDateController.clear();
    entryDateController.clear();
    weightingDateController.clear();
  }

  @override
  String toString() {
    return '''
    AnimalFormControllers {
      tagNumber: ${tagNumberController.text},
      tagNumberRFID: ${tagNumberRFIDController.text},
      momTagNumber: ${momTagNumberController.text},
      dadTagNumber: ${dadTagNumberController.text},
      weight: ${weightController.text},
      sex: ${sexController.text},
      breed: ${breedController.text},
      lot: ${lotController.text},
      notes: ${notesController.text},
      birthDate: ${birthDateController.text},
      entryDate: ${entryDateController.text},
      weightingDate: ${weightingDateController.text},
    }
    ''';
  }
}
