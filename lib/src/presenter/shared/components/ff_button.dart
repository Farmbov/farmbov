import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/common/themes/flutter_flow_widgets.dart';

import 'package:flutter/material.dart';

enum FFButtonType { primary, outlined, ghost }

enum FFButtonColor { primary, dark, medium }

class FFButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Function()? onPressed;
  final bool fullWidth;
  final FFButtonType type;
  final FFButtonColor color;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? splashColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final double height;
  final double? width;
  final bool loading;
  final Widget? icon;

  const FFButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.type = FFButtonType.primary,
    this.color = FFButtonColor.primary,
    this.backgroundColor,
    this.textColor,
    this.splashColor,
    this.borderColor,
    this.padding,
    this.height = 44,
    this.width,
    this.fullWidth = true,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FFButtonWidget(
      onPressed: onPressed,
      text: text ?? '',
      options: _getStyleOptions(context),
      showLoadingIndicator: loading,
      icon: icon,
      child: child,
    );
  }

  FFButtonOptions _getStyleOptions(BuildContext context) {
    if (type == FFButtonType.primary) return _buttonPrimary(context);

    if (type == FFButtonType.outlined) return _buttonOutlined(context);

    if (type == FFButtonType.ghost) return _buttonGhost(context);

    return _buttonPrimary(context);
  }

  FFButtonOptions _buttonPrimary(BuildContext context) {
    return FFButtonOptions(
      width: fullWidth ? MediaQuery.of(context).size.width : (width ?? 350),
      height: height,
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 18,
          ),
      splashColor: splashColor ?? AppColors.primaryGreenDark.withOpacity(0.2),
      color: backgroundColor ?? AppColors.primaryGreen,
      textStyle: TextStyle(color: textColor ?? Colors.white),
      elevation: 0,
      borderSide: BorderSide(
        color: onPressed == null || loading
            ? const Color(0xffD7D3D0)
            : (borderColor ?? (backgroundColor ?? AppColors.primaryGreen)),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(8),
      disabledColor: const Color(0xffD7D3D0),
      disabledTextColor: const Color(0xffA9A29D),
    );
  }

  FFButtonOptions _buttonOutlined(BuildContext context) {
    return FFButtonOptions(
      width: fullWidth ? MediaQuery.of(context).size.width : (width ?? 350),
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      splashColor: splashColor ?? AppColors.primaryGreen.withOpacity(0.2),
      color: Colors.transparent,
      textStyle: TextStyle(
        color: textColor ?? AppColors.primaryGreen,
        fontWeight: FontWeight.w600,
      ),
      elevation: 0,
      borderSide: BorderSide(
        color: onPressed == null || loading
            ? const Color(0xffD7D3D0)
            : (borderColor ?? (backgroundColor ?? AppColors.primaryGreen)),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(8),
      disabledColor: const Color(0xffD7D3D0),
      disabledTextColor: const Color(0xffA9A29D),
    );
  }

  FFButtonOptions _buttonGhost(BuildContext context) {
    return FFButtonOptions(
      width: fullWidth ? MediaQuery.of(context).size.width : (width ?? 350),
      height: height,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 18,
      ),
      color: Colors.transparent,
      textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.w600,
          ),
      elevation: 0,
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(8),
      disabledColor: const Color(0xffD7D3D0),
      disabledTextColor: const Color(0xffA9A29D),
    );
  }
}
