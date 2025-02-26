import 'package:farmbov/src/common/themes/farm_bov_icons.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/extensions/backend.dart';
import '../../../../domain/models/firestore/lot_model.dart';
import '../../../shared/components/generic_card_tile.dart';
import '../../../shared/components/generic_card_tile_item.dart';
import '../../../shared/components/generic_page_content.dart';
import '../../../shared/components/no_content_page.dart';
import '../../../shared/pages/generic_page/generic_page_mixin.dart';
import '../../lots/lots_page_store.dart';

class LotsAreaPage extends StatefulWidget {
  final LotsPageStore store;
  final String areaName;

  const LotsAreaPage({
    super.key,
    required this.store,
    required this.areaName,
  });

  @override
  State<LotsAreaPage> createState() => _LotsAreaPageState();
}

class _LotsAreaPageState extends State<LotsAreaPage> with GenericPageMixin {
  @override
  LotsPageStore get baseStore => widget.store;

  @override
  Widget get web => _buildContent(context);

  @override
  Widget get mobile => _buildContent(context);

  // Definindo o título da página com o nome da área
  @override
  String get title => 'Lotes ${widget.areaName}';

  @override
  bool get allowBackButton => true;

  @override
  Widget get noContentPage => NoContentPage(
        title: 'Nenhum lote encontrado',
        description: 'Você ainda não cadastrou nenhum lote para esta área.',
        actionTitle: 'Adicionar lote',
        action: () => widget.store.updateLoteModal(context),
      );

  Widget _buildContent(BuildContext context) {
    return StreamBuilder<List<LotModel>>(
      stream: queryLotModel(
        queryBuilder: (model) =>
            model.where('area', isEqualTo: widget.areaName),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final lots = snapshot.data;

        if (lots == null || lots.isEmpty) {
          return noContentPage;
        }

        final lotTiles = lots.map((lot) {
          return FutureBuilder<int?>(
            future: widget.store.getAnimalsCountByLot(lot.name ?? 'unknown'),
            builder: (context, animalsSnapshot) {
              final animalsCount = animalsSnapshot.data ?? 0;
              final animalsAmount =
                  NumberFormat.decimalPattern("pt-BR").format(animalsCount);
              final animalsCapacity = NumberFormat.decimalPattern("pt-BR")
                  .format(lot.animalsCapacity);

              return GenericCardTile(
                title: lot.name,
                customActions: [
                  IconButton(
                    icon: const Icon(
                      FarmBovIcons.cow,
                      size: 20,
                      color: AppColors.primaryGreen,
                    ),
                    visualDensity: const VisualDensity(vertical: -3),
                    onPressed: () => widget.store.showAnimals(context, lot),
                    splashRadius: 20,
                    tooltip: 'Visualizar animais',
                  ),
                ],
                updateAction: () =>
                    widget.store.updateLoteModal(context, model: lot),
                deleteAction: () =>
                    widget.store.deleteLoteModal(context, model: lot),
                items: [
                  GenericCardTileItem(
                    icon: FarmBovIcons.map,
                    title: 'Área: ${lot.area}',
                  ),
                  GenericCardTileItem(
                    icon: FarmBovIcons.cow,
                    title:
                        'Total de $animalsAmount ${animalsAmount == '1' ? 'animal' : 'animais'}',
                  ),
                  GenericCardTileItem(
                    icon: FarmBovIcons.cow,
                    title:
                        'Capacidade de $animalsCapacity ${animalsCapacity == '1' ? 'animal' : 'animais'}',
                  ),
                ],
                otherItems: [
                  GenericCardTileItem(
                    leadingText: 'Observação',
                    title: lot.notes ?? '-',
                  ),
                ],
              );
            },
          );
        }).toList();

        return GenericPageContent(
          title: title, // Usando o título dinâmico com o nome da área
          showBackButton: true,
          onBackButtonPressed: () => Navigator.pop(context),
          actionTitle: 'Adicionar lote',
          actionButton: () =>
              widget.store.updateLoteModal(context), // Botão de adicionar lote
          children: lotTiles,
        );
      },
    );
  }
}
