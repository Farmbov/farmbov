import 'package:dropdown_search/dropdown_search.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/lot_model.dart';
import 'package:farmbov/src/domain/models/firestore/vaccine_model.dart';
import 'package:farmbov/src/presenter/features/vaccines/vaccine_lot/vaccine_lot_update_model.dart';
import 'package:farmbov/src/presenter/features/vaccines/vaccine_lot/vaccine_lot_update_page_store.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input_date_picker.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:farmbov/src/presenter/shared/modals/base_modal_bottom_sheet.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class VaccineLotUpdatePage extends StatefulWidget {
  final VaccineLotUpdatePageStore store;

  const VaccineLotUpdatePage({super.key, required this.store});

  @override
  VaccineLotUpdatePageState createState() => VaccineLotUpdatePageState();
}

class VaccineLotUpdatePageState extends State<VaccineLotUpdatePage> {
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
        builder: (context, Triple<VaccineLotUpdatePageModel> model) {
          return BaseModalBottomSheet(
            title: model.state.readOnly
                ? "Visualizar vacinação em lote"
                : _isCreateView()
                    ? 'Vacinação em lote'
                    : 'Editar vacinação em lote',
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              widget.store.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: widget.store.formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: DropdownSearch<VaccineModel>(
                                  selectedItem: model.state.selectedVaccine,
                                  asyncItems: (String filter) {
                                    return queryVaccineOnce(
                                      queryBuilder: (vaccine) => vaccine.where(
                                        'active',
                                        isEqualTo: true,
                                      ),
                                    );
                                  },
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: 'Selecione a vacina',
                                    ),
                                  ),
                                  popupProps: const PopupProps.menu(
                                    showSearchBox:
                                        false, // Desabilita a caixa de pesquisa, se necessário
                                    menuProps: MenuProps(
                                      backgroundColor: Colors
                                          .white, // Define o fundo branco do dropdown
                                    ),
                                  ),
                                  itemAsString: (VaccineModel item) =>
                                      ("${item.name}${item.dueDate?.isBefore(DateTime.now()) ?? false ? ' (vencida)' : ''}"),
                                  onChanged: model.state.readOnly
                                      ? null
                                      : (selectedVaccine) =>
                                          widget.store.update(
                                            model.state.copyWith(
                                                selectedVaccine:
                                                    selectedVaccine),
                                          ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownSearch<LotModel>(
                                  selectedItem: model.state.selectedLot,
                                  asyncItems: (String filter) {
                                    return queryLotModelOnce(
                                      queryBuilder: (lot) => lot.where(
                                        'active',
                                        isEqualTo: true,
                                      ),
                                    );
                                  },
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: 'Selecione o lote',
                                    ),
                                  ),
                                  popupProps: const PopupProps.menu(
                                    showSearchBox:
                                        false, // Desabilita a caixa de pesquisa, se necessário
                                    menuProps: MenuProps(
                                      backgroundColor: Colors
                                          .white, // Define o fundo branco do dropdown
                                    ),
                                  ),
                                  itemAsString: (item) => item.name ?? '-',
                                  onChanged: model.state.readOnly
                                      ? null
                                      : (selectedLot) => widget.store.update(
                                            model.state.copyWith(
                                                selectedLot: selectedLot),
                                          ),
                                ),
                              ),
                            ],
                          ),

                          // TODO: fix add vaccine info
                          // if (model.state.vaccineId != null) ...[
                          //   const SizedBox(height: 20),
                          //   Text(
                          //     'Informações da vacina',
                          //     style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          //           fontSize: 16,
                          //           color: const Color(0xFF292524),
                          //         ),
                          //     textAlign: TextAlign.start,
                          //   ),
                          // ],
                          const SizedBox(height: 20),
                          Text(
                            'Observações*:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontSize: 16,
                                  color: const Color(0xFF292524),
                                ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 8),
                          FFInput(
                            labelText: model.state.readOnly
                                ? 'Nenhuma observação'
                                : 'Observações adicionais da vacinação em lote',
                            readOnly: model.state.readOnly,
                            initialValue: widget.store.state.notes,
                            onChanged: (value) => widget.store
                                .update(model.state.copyWith(notes: value)),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          FFInputDatePicker(
                            floatingLabel: 'Data de aplicação*',
                            labelText: 'Insira a data de aplicação da vacina',
                            readOnly: model.state.readOnly,
                            initDate: model.state.applicationDate,
                            textInputAction: TextInputAction.done,
                            onSelectDate: (DateTime date) =>
                                widget.store.update(
                              model.state.copyWith(applicationDate: date),
                            ),
                            onFieldSubmitted: (_) => _isCreateView()
                                ? widget.store
                                    .insert(context)
                                    .then((value) => setState(() {}))
                                : widget.store
                                    .edit(
                                      widget.store.state.model!.ffRef!,
                                      context,
                                    )
                                    .then((value) => setState(() {})),
                          ),

                          const SizedBox(height: 40),
                          if (model.state.readOnly == false) ...[
                            FFButton(
                              text: _isCreateView()
                                  ? 'Confirmar'
                                  : 'Salvar alterações',
                              onPressed: () => _isCreateView()
                                  ? widget.store.insert(context)
                                  : widget.store.edit(
                                      widget.store.state.model!.ffRef!,
                                      context,
                                    ),
                            ),
                          ],
                        ],
                      ),
                    ),
              if (ResponsiveBreakpoints.of(context).isMobile ||
                  model.state.readOnly) ...[
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
          );
        });
  }
}
