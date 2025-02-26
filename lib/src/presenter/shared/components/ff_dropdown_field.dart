import 'package:farmbov/src/common/helpers/custom_validators.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class FFDropdownField<T, M> extends StatelessWidget {
  final T? value;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>>? customItems;
  final Future<List<M>>? future;
  final String? labelText;
  final String? notFoundText;
  final Function(M)? selectedItemBuilder;
  final String Function(M)? futureItemsLabelBuilder;
  final bool isRequired;

  const FFDropdownField({
    super.key,
    this.onChanged,
    this.customItems,
    this.labelText,
    this.value,
    this.future,
    required this.selectedItemBuilder,
    this.futureItemsLabelBuilder,
    this.notFoundText,
    this.isRequired = true,
  });

  List<DropdownMenuItem<T>> _buildFutureItems(
    List<M>? futureItems,
  ) {
    if (futureItems == null) {
      return [];
    }

    if (futureItemsLabelBuilder != null) {
      return futureItems.map((e) {
        return DropdownMenuItem<T>(
          value: selectedItemBuilder!(e) as T?,
          child: Text(
            futureItemsLabelBuilder!(e),
          ),
        );
      }).toList();
    }

    return futureItems.map((e) {
      return DropdownMenuItem<T>(
        value: futureItemsLabelBuilder!(e) as T,
        child: Text(
          e.toString(),
        ),
      );
    }).toList();
  }

  String? Function(T?)? _buildValidator() {
    if (isRequired) {
      return NotNullRequiredValidator(errorText: 'Este campo é obrigatório.').call;
    }

    return null;
  }

  Widget _buildWidget(
    BuildContext context, {
    List<M>? futureItems,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText ?? 'Selecione',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  
                  color: const Color(0xFF44403C),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<T>(
            value: value,
            decoration: InputDecoration(
                labelText: labelText ?? 'Selecione',
                labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10)),
            onChanged: onChanged,
            items: customItems ?? _buildFutureItems(futureItems),
            validator: _buildValidator(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return DropdownButtonHideUnderline(
    //   child: DropdownButton2<String>(
    //     isExpanded: true,
    //     hint: Text(
    //       'Select Item',
    //       style: TextStyle(
    //         fontSize: 14,
    //         color: Theme.of(context).hintColor,
    //       ),
    //     ),
    //     items: items
    //         .map((String item) => DropdownMenuItem<String>(
    //               value: item,
    //               child: Text(
    //                 item,
    //                 style: const TextStyle(
    //                   fontSize: 14,
    //                 ),
    //               ),
    //             ))
    //         .toList(),
    //     value: selectedValue,
    //     onChanged: (String? value) {
    //       setState(() {
    //         selectedValue = value;
    //       });
    //     },
    //     buttonStyleData: const ButtonStyleData(
    //       padding: EdgeInsets.symmetric(horizontal: 16),
    //       height: 40,
    //       width: 140,
    //     ),
    //     menuItemStyleData: const MenuItemStyleData(
    //       height: 40,
    //     ),
    //   ),
    // );

    if (future != null) {
      return FutureBuilder<List<M>>(
        future: future,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                color: AppColors.primaryGreen,
              ),
            );
          }

          final data = snapshot.data;

          if (data == null || data.isEmpty) {
            return Text(
              notFoundText ?? 'Nenhum item encontrado',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF292524),
                  ),
              textAlign: TextAlign.start,
            );
          }

          return _buildWidget(
            context,
            futureItems: data,
          );
        },
      );
    }

    return _buildWidget(context);
  }
}
