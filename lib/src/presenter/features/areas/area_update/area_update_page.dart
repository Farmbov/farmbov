import 'package:farmbov/src/domain/constants/area_usage_type.dart';
import 'package:farmbov/src/domain/models/area_usage_type_model.dart';
import 'package:farmbov/src/presenter/features/areas/area_update/area_update_page_model.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/common/helpers/custom_validators.dart';
import 'package:farmbov/src/domain/models/firestore/area_model.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:farmbov/src/presenter/shared/modals/base_modal_bottom_sheet.dart';
import 'package:farmbov/src/presenter/features/areas/area_update/area_update_page_store.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AreaUpdatePage extends StatefulWidget {
  final AreaModel? model;
  final AreaUpdatePageStore store;

  const AreaUpdatePage({
    super.key,
    required this.store,
    this.model,
  });

  @override
  AreaUpdatePageState createState() => AreaUpdatePageState();
}

class AreaUpdatePageState extends State<AreaUpdatePage> {
  @override
  void initState() {
    super.initState();
    widget.store.init(model: widget.model);
  }

  @override
  void dispose() {
    widget.store.dispose();
    super.dispose();
  }

  bool _isCreateView() => widget.model == null;

  @override
  Widget build(BuildContext context) {
    return TripleBuilder(
      store: widget.store,
      builder: (context, Triple<AreaUpdatePageModel> model) =>
          BaseModalBottomSheet(
        title: _isCreateView() ? 'Adicionar área' : 'Editar área',
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
                  'Informações da área',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: const Color(0xFF292524),
                      ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                FFInput(
                  floatingLabel: 'Nome da área',
                  labelText: 'Insira um nome',
                  initialValue: model.state.name,
                  onChanged: (value) => widget.store.update(
                    model.state.copyWith(name: value),
                  ),
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
                  floatingLabel: 'Tamanho (em hectares)',
                  labelText: 'Insira o tamanho',
                  initialValue: model.state.totalArea?.toString() ?? '',
                  onChanged: (value) => widget.store.update(
                    model.state.copyWith(totalArea: double.tryParse(value)),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: MultiValidator([
                    RangeValidator(
                        min: 0,
                        max: 99999999,
                        errorText:
                            'A quantidade deve estar entre 0 e 99999999'),
                  ]).call,
                ),
                const SizedBox(height: 16),
                FFInput(
                  floatingLabel: 'Total de animais recomendados*',
                  labelText: 'Insira a quantidade máxima de animais da área',
                  initialValue: model.state.totalCapacity?.toString() ?? '',
                  onChanged: (value) => widget.store.update(
                    model.state.copyWith(totalCapacity: int.tryParse(value)),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: MultiValidator([
                    DefaultRequiredValidator(),
                    RangeValidator(
                        min: 0,
                        max: 99999999,
                        errorText:
                            'A quantidade deve estar entre 0 e 99999999'),
                  ]).call,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tipo de uso*:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF44403C),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<AreaUsageTypeModel?>(
                  value: model.state.selectedUsageType,
                  decoration: InputDecoration(
                    labelText: 'Tipo de uso',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 16),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    
                  ),
                  onChanged: (usageType) => widget.store.update(
                    model.state.copyWith(selectedUsageType: usageType),
                  ),
                  items: defaultAreaUsageTypes.map((tipo) {
                    return DropdownMenuItem<AreaUsageTypeModel>(
                      value: tipo,
                      child: Text(tipo.name ?? '-'),
                    );
                  }).toList(),
                  validator: NotNullRequiredValidator(
                          errorText: 'Este campo é obrigatório.')
                      .call,
                ),
                const SizedBox(height: 16),
                Text(
                  'Observações',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: const Color(0xFF292524),
                      ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 8),
                FFInput(
                  labelText: 'Observações adicionais da área',
                  initialValue: model.state.notes,
                  onChanged: (value) => widget.store.update(
                    model.state.copyWith(notes: value),
                  ),
                  maxLines: 8,
                  validator: MultiValidator([
                    LengthRangeValidator(
                        min: 0,
                        max: 512,
                        errorText: 'O campo deve ter no máximo 512 caracteres.')
                  ]).call,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          FFButton(
            text: _isCreateView() ? 'Adicionar área' : 'Salvar alterações',
            onPressed: () => _isCreateView()
                ? widget.store.insert(context)
                : widget.store.edit(
                    widget.model!.ffRef!,
                    context,
                  ),
            loading: widget.store.isLoading,
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
