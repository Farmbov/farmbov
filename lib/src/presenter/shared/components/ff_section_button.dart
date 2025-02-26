import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:farmbov/src/presenter/shared/components/ff_button.dart';

class FFSectionButton extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final IconData? icon;
  final dynamic Function()? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final bool displayBorder;
  final double? fontSize;

  const FFSectionButton({
    super.key,
    required this.title,
    this.width = 150,
    this.height = 35,
    this.icon,
    this.onPressed,
    this.backgroundColor,
    this.color,
    this.displayBorder = true,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return FFButton(
      type: ResponsiveBreakpoints.of(context).isMobile
          ? FFButtonType.primary
          : FFButtonType.outlined,
      fullWidth: false,
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      backgroundColor: backgroundColor,
      borderColor: displayBorder ? null : Colors.transparent,
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: fontSize ??
                (ResponsiveBreakpoints.of(context).isMobile ? 12 : 14),
            color: color ??
                (ResponsiveBreakpoints.of(context).isMobile
                    ? Colors.white
                    : AppColors.primaryGreen),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: fontSize ??
                      (ResponsiveBreakpoints.of(context).isMobile ? 12 : 14),
                  color: color ??
                      (ResponsiveBreakpoints.of(context).isMobile
                          ? Colors.white
                          : AppColors.primaryGreen),
                ),
          ),
        ],
      ),
    );
  }
}
