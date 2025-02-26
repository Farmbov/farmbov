import 'package:farmbov/src/common/helpers/custom_validators.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/features/vaccines/vaccine_update/vaccine_update_model.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input_date_picker.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/features/vaccines/vaccine_update/vaccine_update_page_store.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:farmbov/src/presenter/shared/modals/base_modal_bottom_sheet.dart';
import 'package:flutter/services.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class VaccineUpdatePage extends StatefulWidget {
  final VaccineUpdatePageStore store;

  const VaccineUpdatePage({super.key, required this.store});

  @override
  VaccineUpdatePageState createState() => VaccineUpdatePageState();
}

class VaccineUpdatePageState extends State<VaccineUpdatePage> {
  @override
  void initState() {
    super.initState();
    widget.store.init();
  }

  @override
  void dispose() {
    widget.store.dispose();
    super.dispose();
  }

  bool _isCreateView() => widget.store.state.model == null;

  @override
  Widget build(BuildContext context) {
    return TripleBuilder(
      store: widget.store,
      builder: (context, Triple<VaccineUpdatePageModel> model) =>
          BaseModalBottomSheet(
        title: _isCreateView() ? 'Adicionar vacina' : 'Editar vacina',
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Form(
            key: widget.store.formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informações da vacina',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: const Color(0xFF292524),
                      ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                FFInput(
                  floatingLabel: 'Nome da vacina*',
                  labelText: 'Informe o nome da vacina',
                  initialValue: widget.store.state.name,
                  onChanged: (value) =>
                      widget.store.update(model.state.copyWith(name: value)),
                  validator: MultiValidator([
                    DefaultRequiredValidator(),
                    MinLengthValidator(3,
                        errorText: 'O campo deve ter no mínimo 3 caracteres.'),
                    MaxLengthValidator(50,
                        errorText: 'O campo deve ter no máximo 50 caracteres.')
                  ]).call,
                ),
                const SizedBox(height: 16),
                FFInput(
                  floatingLabel: 'Descrição da vacina*',
                  labelText: 'Para quê serve a vacina?',
                  initialValue: widget.store.state.description,
                  onChanged: (value) => widget.store
                      .update(model.state.copyWith(description: value)),
                  validator: MultiValidator([
                    // TODO: fazer a validação ignorar valores vazio, quando o campo for opcional (ignoreEmptyValues)
                    // copiar o LessThanDateValidator
                    MinLengthValidator(3,
                        errorText: 'O campo deve ter no mínimo 3 caracteres.'),
                    MaxLengthValidator(50,
                        errorText: 'O campo deve ter no máximo 50 caracteres.')
                  ]).call,
                ),
                const SizedBox(height: 16),
                FFInput(
                  floatingLabel: 'Lote de fabricação*',
                  labelText: 'Insira o número do lote de fabricação',
                  initialValue: widget.store.state.lotNumber,
                  onChanged: (value) => widget.store
                      .update(model.state.copyWith(lotNumber: value)),
                  validator: MultiValidator([
                    DefaultRequiredValidator(),
                    MinLengthValidator(1,
                        errorText: 'O campo deve ter no mínimo 1 caracter.'),
                    MaxLengthValidator(250,
                        errorText: 'O campo deve ter no máximo 250 caracteres.')
                  ]).call,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FFInput(
                        floatingLabel: 'Fornecedor*',
                        labelText: 'Informe o fornecedor',
                        initialValue: widget.store.state.supplier,
                        onChanged: (value) => widget.store
                            .update(model.state.copyWith(supplier: value)),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Este campo é obrigatório.'),
                          MinLengthValidator(3,
                              errorText:
                                  'O campo deve ter no mínimo 3 caracteres.'),
                          MaxLengthValidator(50,
                              errorText:
                                  'O campo deve ter no máximo 50 caracteres.')
                        ]).call,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FFInput(
                        floatingLabel: 'Laboratório',
                        labelText: 'Nome do laboratório',
                        initialValue: widget.store.state.producer,
                        onChanged: (value) => widget.store
                            .update(model.state.copyWith(producer: value)),
                        // validator: MultiValidator([
                        //   MinLengthValidator(1,
                        //       errorText:
                        //           'O campo deve ter no mínimo 3 caracteres.'),
                        //   MaxLengthValidator(250,
                        //       errorText:
                        //           'O campo deve ter no máximo 250 caracteres.')
                        // ]).call,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // TODO: quando digitar o dia, calcular a baixa a data de proxima aplicação
                FFInput(
                  floatingLabel: 'Dias para a próxima dose',
                  labelText: 'Dias para a próxima dose',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  initialValue: widget.store.state.daysToNextDose == null
                      ? ""
                      : widget.store.state.daysToNextDose.toString(),
                  onChanged: (value) => widget.store.update(
                    model.state.copyWith(
                      daysToNextDose: int.tryParse(value),
                    ),
                  ),
                  validator: MultiValidator([
                    // TODO: criar wrapper já com textos corretos
                    RangeValidator(
                      min: 0,
                      max: 999999,
                      errorText: 'A quantidade deve estar entre 0 e 999999',
                    ),
                  ]).call,
                ),
                // const SizedBox(height: 16),
                // FFInput(
                //   floatingLabel: 'Bula',
                //   labelText: 'Link para a bula da vacina',
                //   initialValue: widget.store.state.leafletUrl,
                //   onChanged: (value) => widget.store
                //       .update(model.state.copyWith(leafletUrl: value)),
                // ),
                const SizedBox(height: 16),
                FFInputDatePicker(
                  floatingLabel: 'Data de fabricação*',
                  labelText: 'Insira a data de fabricação da vacina',
                  initDate: model.state.fabricationDate,
                  onSelectDate: (DateTime date) => widget.store.update(
                    model.state.copyWith(fabricationDate: date),
                  ),
                  validator: MultiValidator([
                    DefaultRequiredValidator(),
                    LessThanDateValidator(
                      afterDate: model.state.dueDate,
                      afterDateLabel: 'Data de vencimento',
                    ),
                    LessThanDateValidator(
                      afterDate: DateTime.now(),
                      afterDateLabel: 'data de hoje',
                    ),
                  ]).call,
                ),
                const SizedBox(height: 16),
                FFInputDatePicker(
                  floatingLabel: 'Data de vencimento*',
                  labelText: 'Insira a data de vencimento da vacina',
                  initDate: model.state.dueDate,
                  onSelectDate: (DateTime date) => widget.store.update(
                    model.state.copyWith(dueDate: date),
                  ),
                  validator: MultiValidator([
                    DefaultRequiredValidator(),
                    GreaterOrEqualThanDateValidator(
                      beforeDate: model.state.fabricationDate,
                      beforeDateLabel: 'Data de fabricação',
                    ),
                  ]).call,
                ),
                // TODO: create 'Data da próxima dose:'
                // TODO: create 'upload image'
              ],
            ),
          ),
          const SizedBox(height: 40),
          FFButton(
            text: _isCreateView() ? 'Adicionar vacina' : 'Salvar alterações',
            onPressed: () => _isCreateView()
                ? widget.store.insert(context)
                : widget.store.edit(
                    widget.store.state.model!.ffRef!,
                    context,
                  ),
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
