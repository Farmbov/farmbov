import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../common/helpers/custom_validators.dart';

import '../../../../common/themes/theme_constants.dart';
import '../../../../domain/models/vaccine_batch_model.dart';
import '../../../../domain/models/vaccine_model.dart';
import '../../../shared/modals/base_modal_bottom_sheet.dart';
import 'vaccine_batches_page_store.dart';

class VaccineBatchFormModal extends StatefulWidget {
  final VaccineBatchModel? batch;
  final VaccineModel vaccineModel;
  final VaccineBatchesPageStore store;

  const VaccineBatchFormModal({
    super.key,
    this.batch,
    required this.store,
    required this.vaccineModel,
  });

  @override
  VaccineBatchFormModalState createState() => VaccineBatchFormModalState();
}

class VaccineBatchFormModalState extends State<VaccineBatchFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController batchNumberController;
  late TextEditingController manufactureDateController;
  late TextEditingController expirationDateController;
  late TextEditingController quantityController;
  late TextEditingController initialQuantityController;
  late TextEditingController availableQuantityController;
  late TextEditingController storageLocationController;
  late TextEditingController supplierController;

  @override
  void initState() {
    batchNumberController =
        TextEditingController(text: widget.batch?.batchNumber ?? "");
    manufactureDateController = TextEditingController(
      text: widget.batch != null
          ? _formatDate(widget.batch!.manufactureDate)
          : "",
    );
    expirationDateController = TextEditingController(
      text: widget.batch != null
          ? _formatDate(widget.batch!.expirationDate)
          : "",
    );
    quantityController = TextEditingController();
    initialQuantityController = TextEditingController(
      text: widget.batch?.initialQuantity.toString() ?? "",
    );
    availableQuantityController = TextEditingController(
      text: widget.batch?.availableQuantity.toString() ?? "",
    );
    storageLocationController =
        TextEditingController(text: widget.batch?.storageLocation ?? "");
    supplierController =
        TextEditingController(text: widget.batch?.supplier ?? "");
    super.initState();
  }

  @override
  void dispose() {
    batchNumberController.dispose();
    manufactureDateController.dispose();
    expirationDateController.dispose();
    quantityController.dispose();
    initialQuantityController.dispose();
    availableQuantityController.dispose();
    storageLocationController.dispose();
    supplierController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat('dd/MM/yyyy').format(date) : '';
  }

  Future<void> _pickDate(
      BuildContext context, TextEditingController controller) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      controller.text = _formatDate(selectedDate);
    }
  }

  InputDecoration _buildInputDecoration(String label, Icon icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          width: 0.5,
          color: AppColors.lightGray,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseModalBottomSheet(
      title: widget.batch == null ? 'Cadastrar Lote' : 'Editar Lote',
      showCloseButton: true,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: batchNumberController,
                decoration: _buildInputDecoration(
                  'Número do Lote',
                  const Icon(Icons.vaccines, color: AppColors.primaryGreen),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, insira o número do lote'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: manufactureDateController,
                readOnly: true,
                decoration: _buildInputDecoration(
                  'Data de Fabricação',
                  const Icon(Icons.calendar_month, color: AppColors.primaryGreen),
                ),
                onTap: () => _pickDate(context, manufactureDateController),
                validator: MultiValidator([DefaultRequiredValidator()]).call,
                
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: expirationDateController,
                readOnly: true,
                decoration: _buildInputDecoration(
                  'Data de Validade',
                  const Icon(Icons.calendar_today, color: AppColors.primaryGreen),
                ),
                onTap: () => _pickDate(context, expirationDateController),
                validator: MultiValidator([DefaultRequiredValidator()]).call,
              ),
              const SizedBox(height: 16),
              if (widget.batch == null)
                TextFormField(
                  controller: quantityController,
                  decoration: _buildInputDecoration(
                    'Quantidade',
                    const Icon(Icons.add_box, color: AppColors.primaryGreen),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Por favor, insira a quantidade'
                      : null,
                  onChanged: (value) {
                    if (int.tryParse(value) == null) {
                      quantityController.clear();
                    }
                  },
                ),
              if (widget.batch != null) ...[
                TextFormField(
                  controller: initialQuantityController,
                  decoration: _buildInputDecoration(
                    'Quantidade Inicial',
                    const Icon(Icons.numbers, color: AppColors.primaryGreen),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Por favor, insira a quantidade inicial'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: availableQuantityController,
                  decoration: _buildInputDecoration(
                    'Quantidade Disponível',
                    const Icon(Icons.tag, color: AppColors.primaryGreen),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Por favor, insira a quantidade disponível'
                      : null,
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: storageLocationController,
                decoration: _buildInputDecoration(
                  'Local de Armazenamento',
                  const Icon(Icons.location_on, color: AppColors.primaryGreen),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, insira o local de armazenamento'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: supplierController,
                decoration: _buildInputDecoration(
                  'Fornecedor',
                  const Icon(Icons.business, color: AppColors.primaryGreen),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, insira o fornecedor'
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final int quantity =
                            int.tryParse(quantityController.text) ?? 0;
                        final batch = widget.batch?.copyWith(
                              batchNumber: batchNumberController.text,
                              manufactureDate: DateFormat('dd/MM/yyyy')
                                  .parse(manufactureDateController.text),
                              expirationDate: DateFormat('dd/MM/yyyy')
                                  .parse(expirationDateController.text),
                              initialQuantity: widget.batch != null
                                  ? int.tryParse(initialQuantityController.text)
                                  : quantity,
                              availableQuantity: widget.batch != null
                                  ? int.tryParse(
                                      availableQuantityController.text)
                                  : quantity,
                              storageLocation: storageLocationController.text,
                              supplier: supplierController.text,
                            ) ??
                            VaccineBatchModel(
                              batchNumber: batchNumberController.text,
                              manufactureDate: DateFormat('dd/MM/yyyy')
                                  .parse(manufactureDateController.text),
                              expirationDate: DateFormat('dd/MM/yyyy')
                                  .parse(expirationDateController.text),
                              initialQuantity: quantity,
                              availableQuantity: quantity,
                              storageLocation: storageLocationController.text,
                              supplier: supplierController.text,
                              active: true,
                              createdAt: Timestamp.now(),
                              updatedAt: Timestamp.now(),
                            );

                        if (widget.batch == null) {
                          widget.store.createVaccineBatch(
                              vaccineModel: widget.vaccineModel, batch: batch);
                        } else {
                          widget.store.editVaccineBatch(batch);
                        }
                        context.pop();
                      }
                    },
                    child: Text(
                      widget.batch == null ? 'Cadastrar' : 'Atualizar',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
