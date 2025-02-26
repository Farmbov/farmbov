import 'package:farmbov/src/domain/models/vaccine_model.dart';
import 'package:farmbov/src/presenter/features/vaccines/vaccine_batches/batch_status_table.dart';
import 'package:farmbov/src/presenter/features/vaccines/vaccine_batches/vaccine_batches_page_store.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:farmbov/src/presenter/shared/components/generic_page_content.dart';
import 'package:farmbov/src/presenter/shared/components/no_content_page.dart';
import 'package:farmbov/src/presenter/shared/pages/generic_page/generic_page_mixin.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:farmbov/src/presenter/shared/components/generic_card_tile.dart';
import 'package:farmbov/src/presenter/shared/components/generic_card_tile_item.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';

import '../../../../domain/models/vaccine_batch_model.dart';
import 'vaccine_batch_form_modal.dart';

DateFormat formatter = DateFormat('dd/MM/yyyy');

class VaccineBatchesPage extends StatefulWidget {
  final VaccineModel? vaccineModel;
  final VaccineBatchesPageStore store;

  const VaccineBatchesPage(
      {super.key, required this.vaccineModel, required this.store});

  @override
  VaccineBatchesPageState createState() => VaccineBatchesPageState();
}

class VaccineBatchesPageState extends State<VaccineBatchesPage>
    with GenericPageMixin {
  @override
  void didChangeDependencies() async {
    await widget.store.fetchVaccineBatches(vaccineModel: widget.vaccineModel!);

    super.didChangeDependencies();
  }

  @override
  Widget get web => _buildContent(context);

  @override
  Widget get mobile => _buildContent(context);

  @override
  String get title => 'Lotes ${widget.vaccineModel?.name}';

  @override
  bool get allowBackButton => false;

  @override
  Widget get noContentPage => NoContentPage(
        title: 'Nenhum lote de vacina cadastrado',
        description: 'Você ainda não cadastrou nenhum lote de vacina.',
        actionTitle: 'Adicionar Lote',
        action: () => {openBatchModal(context)},
      );

  Widget _buildContent(BuildContext context) {
    return GenericPageContent(
      title: 'Lotes ${widget.vaccineModel?.name}',
      useGridRows: false,
      showBackButton: true,
      onBackButtonPressed: () => context.pop(),
      actionTitle: 'Adiciona Novo Lote',
      actionButton: () {
        openBatchModal(
          context,
        );
      },
      children: [
        ResponsiveBreakpoints.of(context).isMobile
            ? _buildMobile(context)
            : _buildWeb(context)
      ],
    );
  }

  Widget _buildListing(BuildContext context) {
    final modelList = widget.store.vaccineBatches;

    if (widget.store.isLoading) {
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

    if (modelList.isEmpty) return noContentPage;

    return Observer(builder: (_) {
      return Column(
        children: [
          ...modelList.map(
            (VaccineBatchModel batch) => GenericCardTile(
              title: batch.batchNumber,
              updateAction: () {
                openBatchModal(context, batch: batch);
              },
              deleteAction: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return BaseAlertModal(
                          type: BaseModalType.danger,
                          title:
                              'Tem certeza que deseja deletar o lote ${batch.batchNumber} da vacina ${widget.vaccineModel?.name}',
                          actionButtonTitle: 'Deletar',
                          actionCallback: () {
                            widget.store.deleteVaccineBatch(batch);
                            context.pop();
                          },
                          cancelCallback: null);
                    });
              },
              items: [
                GenericCardTileItem(
                  leadingText: "Quantidade Disponível",
                  title:
                      '${batch.availableQuantity} ${batch.availableQuantity > 1 ? 'Doses' : 'Dose'}',
                ),
                GenericCardTileItem(
                  leadingText: 'Quantidade Inicial',
                  title:
                      '${batch.initialQuantity} ${batch.initialQuantity > 1 ? 'Doses' : 'Dose'}',
                ),
                GenericCardTileItem(
                    leadingText: 'Data de Fabricação',
                    title: formatter.format(batch.manufactureDate)),
                GenericCardTileItem(
                    leadingText: 'Data de Vencimento',
                    title: formatter.format(batch.expirationDate)),
                GenericCardTileItem(
                    leadingText: 'Status',
                    title: DateTime.now().isAfter(batch.expirationDate)
                        ? 'Vencida'
                        : 'Disponível'),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      children: [
        if (widget.store.vaccineBatches.isNotEmpty) ...[
          BatchStatusTable(vaccineBatches: widget.store.vaccineBatches),
          const Divider(
            height: 48,
            thickness: 1,
            color: Color(0xFFD7D3D0),
          )
        ],
        _buildListing(context),
      ],
    );
  }

  Widget _buildWeb(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _buildListing(context),
        ),
        SizedBox(width: Adaptive.px(30)),
        Expanded(
          flex: 1,
          child: widget.store.vaccineBatches.isNotEmpty
              ? BatchStatusTable(vaccineBatches: widget.store.vaccineBatches)
              : const SizedBox(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Observer(builder: (context) {
        return _buildContent(context);
      });

  void openBatchModal(BuildContext context, {VaccineBatchModel? batch}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return VaccineBatchFormModal(
          batch: batch,
          vaccineModel: widget.vaccineModel!,
          store: widget.store,
        );
      },
    );
  }
}
