import 'package:farmbov/src/common/helpers/custom_validators.dart';
import 'package:farmbov/src/domain/models/firestore/farm_model.dart';
import 'package:farmbov/src/presenter/features/farms/farm_update/farm_update_page.store.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:farmbov/src/presenter/shared/modals/base_modal_bottom_sheet.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mobx_triple/mobx_triple.dart';

class FarmUpdatePage extends StatefulWidget {
  final FarmModel? model;
  final FarmUpdatePageStore store;

  const FarmUpdatePage({
    super.key,
    required this.store,
    this.model,
  });

  @override
  FarmUpdatePageState createState() => FarmUpdatePageState();
}

class FarmUpdatePageState extends State<FarmUpdatePage> {
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
      builder: (context, Triple<FarmModel?> model) => BaseModalBottomSheet(
        title: _isCreateView() ? 'Adicionar fazenda' : 'Editar fazenda',
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
                  'Informações da fazenda',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: const Color(0xFF292524),
                      ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                FFInput(
                  floatingLabel: 'Nome da fazenda*',
                  labelText: 'Nome da fazenda',
                  controller: widget.store.nameController,
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
                  floatingLabel: 'Tamanho (ha)*',
                  labelText: 'Área total da fazenda em hectares',
                  controller: widget.store.areaController,
                  keyboardType: TextInputType.number,
                  // TODO: input filter numbers and comma
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
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
                FFInput(
                  floatingLabel: 'Latitude',
                  labelText: 'Latitude',
                  controller: widget.store.latitudeController,
                  keyboardType: TextInputType.number,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
                  // validator: MultiValidator([
                  //   DefaultRequiredValidator(),
                  //   RangeValidator(
                  //       min: 0,
                  //       max: 99999999,
                  //       errorText:
                  //           'A quantidade deve estar entre 0 e 99999999'),
                  // ]),
                ),
                const SizedBox(height: 16),
                FFInput(
                  floatingLabel: 'Longitude',
                  labelText: 'Longitude',
                  controller: widget.store.longitudeController,
                  keyboardType: TextInputType.number,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
                  // validator: MultiValidator([
                  //   DefaultRequiredValidator(),
                  //   RangeValidator(
                  //       min: 0,
                  //       max: 99999999,
                  //       errorText:
                  //           'A quantidade deve estar entre 0 e 99999999'),
                  // ]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          FFButton(
            text: _isCreateView() ? 'Cadastrar fazenda' : 'Salvar alterações',
            onPressed: () => _isCreateView()
                ? widget.store.insert(context)
                : widget.store.edit(
                    widget.model!.ffRef!,
                    context,
                  ),
            loading: widget.store.isLoading,
          ),
        ],
      ),
    );
  }
}
