import 'package:farmbov/src/common/helpers/custom_validators.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/area_model.dart';
import 'package:farmbov/src/presenter/features/lots/lot_update/lot_update_page_model.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/domain/models/firestore/lot_model.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:farmbov/src/presenter/shared/modals/base_modal_bottom_sheet.dart';
import 'package:farmbov/src/presenter/features/lots/lot_update/lot_update_page_store.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../common/providers/app_manager.dart';
import '../../../../common/router/route_name.dart';
import '../../../shared/modals/base_alert_modal.dart';

class LotUpdatePage extends StatefulWidget {
  final LotModel? model;
  final LotUpdatePageStore store;

  const LotUpdatePage({
    super.key,
    required this.store,
    this.model,
  });

  @override
  LotUpdatePageState createState() => LotUpdatePageState();
}

class LotUpdatePageState extends State<LotUpdatePage> {
  @override
  void initState() {
    super.initState();
    widget.store.init(model: widget.model);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndShowAlerts(
        context,
      );
    });
  }

  @override
  void dispose() {
    widget.store.dispose();
    super.dispose();
  }

  Future<void> checkAndShowAlerts(BuildContext context) async {
    String? farmId = AppManager.instance.currentUser.currentFarm!.id;
    // Funções para verificar se há áreas e lotes ativos
    bool hasActiveAreas = await _hasActiveDocuments('farms/$farmId/areas');

    //Mensagens e títulos dos modais
    if (!hasActiveAreas) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => BaseAlertModal(
            type: BaseModalType.warning,
            title: 'Nenhuma área encontrada',
            description: 'Você precisa criar uma área ativa para continuar.',
            actionButtonTitle: 'Criar Área',
            canPop: true,
            cancelCallback: (){
              context.pop();
              context.pop();
            },
            actionCallback: () {
              context.pop();
              context.pushNamed(RouteName.areas);
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

  @override
  Widget build(BuildContext context) {
    return TripleBuilder(
      store: widget.store,
      builder: (context, Triple<LotUpdatePageModel> model) =>
          BaseModalBottomSheet(
        title: _isCreateView() ? 'Adicionar lote' : 'Editar lote',
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
                  'Informações do lote',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: const Color(0xFF292524),
                      ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                FFInput(
                  floatingLabel: 'Nome do lote*',
                  labelText: 'Insira um nome',
                  controller: widget.store.nameController,
                  validator: MultiValidator([
                    DefaultRequiredValidator(),
                    MinLengthValidator(3,
                        errorText: 'O campo deve ter no mínimo 3 caracteres.'),
                    MaxLengthValidator(100,
                        errorText: 'O campo deve ter no máximo  caracteres.')
                  ]).call,
                ),
                const SizedBox(height: 16),
                Text(
                  'Área:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF44403C),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                StreamBuilder<List<AreaModel>>(
                  stream: queryAreaModel(),
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

                    final areaList = snapshot.data;

                    areaList?.removeWhere((area) => area.active == false);

                    if (areaList == null || areaList.isEmpty) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Nenhuma área encontrada ',
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
                              context.go(RouteName.areas);
                            },
                            child: Text(
                              'Criar Área!',
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
                      value: model.state.selectedArea,
                      decoration: InputDecoration(
                        labelText: 'Selecione a área',
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
                      onChanged: (lot) => widget.store.update(
                        model.state.copyWith(selectedArea: lot),
                      ),
                      items: areaList.map((option) {
                        var selected = option.name;
                        if (!areaList.contains(option)) {
                          selected = '';
                        }

                        return DropdownMenuItem<String?>(
                          value: selected,
                          child: Text(option.name ?? '-'),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                FFInput(
                  floatingLabel: 'Total de animais recomendados*',
                  labelText: 'Insira a quantidade máxima de animais do lote',
                  controller: widget.store.animalsAmountController,
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
                  'Observações',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: const Color(0xFF292524),
                      ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 8),
                FFInput(
                  labelText: 'Observações adicionais do lote',
                  controller: widget.store.notesController,
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
            text: _isCreateView() ? 'Adicionar lote' : 'Salvar alterações',
            onPressed: () => _isCreateView()
                ? widget.store.insert(context)
                : widget.store.edit(
                    widget.model!.ffRef!,
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
