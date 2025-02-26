import 'package:farmbov/src/presenter/features/animals/widgets/animals_listing.dart';
import 'package:farmbov/src/presenter/features/lots/lot_visualize/lot_visualize_page_store.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/domain/models/firestore/lot_model.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/modals/base_modal_bottom_sheet.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LotVisualizePage extends StatefulWidget {
  final LotModel? model;
  final LotVisualizePageStore store;

  const LotVisualizePage({
    super.key,
    required this.store,
    this.model,
  });

  @override
  LotUpdatePageState createState() => LotUpdatePageState();
}

class LotUpdatePageState extends State<LotVisualizePage> {
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

  int get animalsCount => widget.model?.animalsCapacity ?? 0;

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder(
      store: widget.store,
      onState: (_, model) => BaseModalBottomSheet(
        title: (widget.model?.name?.isEmpty ?? true)
            ? 'Visualizar lote'
            : 'Lote: ${widget.model?.name}',
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.model?.animalsCapacity == 0
                    ? 'Nenhum animal encontrado'
                    : 'Capacidade recomendada de $animalsCount ${animalsCount == 1 ? 'animal' : 'animais'}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF292524),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 24),
            ],
          ),
          const SizedBox(height: 20),
          AnimalsListing(
            showActionButtons: false,
            lotNameFilter: widget.model?.name,
          ),
          const SizedBox(height: 40),
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
