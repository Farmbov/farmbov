import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/presenter/shared/components/ff_button.dart';

class SectionActionButton extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final IconData? icon;
  final dynamic Function()? onPressed;
  final Color? color;
  final bool displayBorder;

  const SectionActionButton({
    super.key,
    required this.title,
    this.width = 150,
    this.height = 35,
    this.icon,
    this.onPressed,
    this.color,
    this.displayBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return FFButton(
      type: FFButtonType.outlined,
      fullWidth: false,
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      borderColor: displayBorder ? null : Colors.transparent,
      splashColor: color?.withOpacity(0.1),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color ?? AppColors.primaryGreen,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 12,
                  color: color ?? AppColors.primaryGreen,
                ),
          ),
        ],
      ),
    );
  }
}
