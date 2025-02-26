import 'package:farmbov/src/common/themes/farm_bov_icons.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/shared/components/generic_card_tile_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class GenericCardTile extends StatelessWidget {
  final String? title;
  final Widget? extraTitleWidget;
  final VoidCallback? updateAction;
  final VoidCallback? deleteAction;
  final List<GenericCardTileItem>? items;
  final List<GenericCardTileItem>? otherItems;
  final List<Widget>? children;
  final List<Widget>? customActions;

  const GenericCardTile({
    super.key,
    this.title,
    this.extraTitleWidget,
    this.updateAction,
    this.deleteAction,
    this.items,
    this.otherItems,
    this.children,
    this.customActions,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xffD7D3D0),
            style: BorderStyle.solid,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.only(bottom: 20),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      title ?? '-',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                            color: const Color(0xFF292524),
                          ),
                    ),
                    if (extraTitleWidget != null) ...[
                      const SizedBox(width: 15),
                      extraTitleWidget!,
                    ],
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (customActions != null) ...[
                      ...customActions!,
                    ],
                    if (updateAction != null) ...[
                      IconButton(
                        icon: const Icon(
                          FarmBovIcons.edit,
                          size: 20,
                          color: AppColors.primaryGreen,
                        ),
                        visualDensity: const VisualDensity(vertical: -3),
                        onPressed: updateAction,
                        splashRadius: 20,
                      ),
                    ],
                    if (deleteAction != null) ...[
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.primaryGreen,
                        ),
                        visualDensity: const VisualDensity(vertical: -3),
                        onPressed: deleteAction,
                        splashRadius: 20,
                      ),
                    ],
                  ],
                )
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                  thickness: 1,
                  indent: 0,
                  height: 12,
                  color: Color(0xFFE7E5E4),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (items != null) ...[
                  ...items!,
                ] else if (children != null) ...[
                  ...children!,
                ],
                if (otherItems != null) ...[
                  const Divider(
                    thickness: 1,
                    indent: 0,
                    height: 12,
                    color: Color(0xFFE7E5E4),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ...otherItems!,
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}
