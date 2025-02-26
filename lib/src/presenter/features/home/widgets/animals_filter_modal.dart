import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/constants/animal_sex.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/modals/base_modal_bottom_sheet.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnimalsFilterModal extends StatefulWidget {
  final Function(List<String>) onSexSelected;
  final Function(List<String>) onLoteSelected;
  final List<String> selectedSexItems;
  final List<String> selectedLoteItems;

  const AnimalsFilterModal({
    super.key,
    required this.onSexSelected,
    required this.onLoteSelected,
    required this.selectedSexItems,
    required this.selectedLoteItems,
  });

  @override
  State<AnimalsFilterModal> createState() => _AnimalsFilterModalState();
}

class _AnimalsFilterModalState extends State<AnimalsFilterModal> {
  var selectedSexItems = List<String>.from(animalSexList, growable: true);
  var selectedLoteItems = List<String>.empty(growable: true);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {
        selectedSexItems = widget.selectedSexItems;
        selectedLoteItems = widget.selectedLoteItems;
      }),
    );
  }

  void onPop(BuildContext context) {
    widget.onSexSelected(selectedSexItems);
    widget.onLoteSelected(selectedLoteItems);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => onPop(context),
      child: BaseModalBottomSheet(
        title: 'Filtrar pesquisa',
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            'Animais',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            children: animalSexList.map((dynamic sexo) {
              return FilterChip(
                label: Text(
                  sexo,
                  style: TextStyle(
                    color: selectedSexItems.contains(sexo)
                        ? Colors.white
                        : AppColors.neutralGray,
                  ),
                ),
                avatar: const Icon(
                  Icons.circle,
                  color: Color(0xFFA9A29D),
                  size: 6,
                ),
                selected: selectedSexItems.contains(sexo),
                backgroundColor: const Color(0xFFF5F5F4),
                onSelected: (bool value) {
                  setState(() {
                    if (value) {
                      if (!selectedSexItems.contains(sexo)) {
                        selectedSexItems.add(sexo);
                      }
                    } else {
                      selectedSexItems.removeWhere((dynamic name) {
                        return name == sexo;
                      });
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Lotes',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          // StreamBuilder<List<LotModel>>(
          //   stream: queryLotModel(),
          //   builder: (context, snapshot) {
          //     if (!snapshot.hasData) {
          //       return SizedBox(
          //         width: 15,
          //         height: 15,
          //         child: CircularProgressIndicator(
          //           color: AppColors.primaryColor,
          //         ),
          //       );
          //     }

          //     final loteList = snapshot.data;

          //     if (loteList == null || loteList.isEmpty) {
          //       return const SizedBox.shrink();
          //     }

          //     return Wrap(
          //       spacing: 12,
          //       children: loteList.map((LotModel lote) {
          //         return FilterChip(
          //           label: Text(
          //             lote.nome ?? '-',
          //             style: TextStyle(
          //               color: selectedLoteItems.contains(lote.nome)
          //                   ? Colors.white
          //                   : AppColors.neutralGray,
          //             ),
          //           ),
          //           avatar: const Icon(
          //             Icons.circle,
          //             color: Color(0xFFA9A29D),
          //             size: 6,
          //           ),
          //           selected: selectedLoteItems.contains(lote.nome),
          //           backgroundColor: const Color(0xFFF5F5F4),
          //           onSelected: (bool value) {
          //             setState(() {
          //               if (value) {
          //                 if (!selectedLoteItems.contains(lote.nome)) {
          //                   selectedLoteItems.add(lote.nome ?? '');
          //                 }
          //               } else {
          //                 selectedLoteItems.removeWhere((String name) {
          //                   return name == lote.nome;
          //                 });
          //               }
          //             });
          //           },
          //         );
          //       }).toList(),
          //     );
          //   },
          // ),
          const SizedBox(height: 44),
          FFButton(
            text: 'Aplicar filtro',
            onPressed: () => onPop(context),
          ),
        ],
      ),
    );
  }
}
