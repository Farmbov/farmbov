import 'package:farmbov/src/common/themes/theme_constants.dart';

import 'package:flutter/material.dart';

class GenericCardTileItem extends StatelessWidget {
  final String? title;
  final Widget? titleContent;
  final IconData? icon;
  final String? leadingText;

  const GenericCardTileItem({
    super.key,
    this.title,
    this.titleContent,
    this.icon,
    this.leadingText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: AppColors.primaryGreen,
              size: 16,
            ),
            const SizedBox(width: 10),
          ] else if (leadingText != null) ...[
            Text(
              "${(leadingText ?? '-')}:",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 12,
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: titleContent ??
                Text(
                  title ?? '-',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 12,
                        color: AppColors.neutralGray,
                        fontWeight: FontWeight.normal,
                      ),
                  textAlign: TextAlign.start,
                ),
          ),
        ],
      ),
    );
  }
}
