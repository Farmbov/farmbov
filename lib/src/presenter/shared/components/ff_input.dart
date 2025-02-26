import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FFInput extends StatelessWidget {
  final String? floatingLabel;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final IconData? prefixIconData;
  final Widget? sufixIcon;
  final IconData? sufixIconData;
  final String? labelText;
  final String? helperText;
  final int? maxLines;
  final bool obscureText;
  final bool autoFocus;
  final bool showTwoPointsFloatingLabel;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final void Function()? onTap;
  final bool readOnly;
  final bool? disabledInput;
  final InputDecoration? decoration;
  final Color? textColor;
  final String? initialValue;
  final TextStyle? style;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(String)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;

  const FFInput({
    super.key,
    this.floatingLabel,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.prefixIconData,
    this.sufixIcon,
    this.sufixIconData,
    this.labelText,
    this.helperText,
    this.maxLines,
    this.onChanged,
    this.inputFormatters,
    this.focusNode,
    this.onTap,
    this.autoFocus = false,
    this.obscureText = false,
    this.showTwoPointsFloatingLabel = true,
    this.readOnly = false,
    this.disabledInput,
    this.decoration,
    this.textColor,
    this.initialValue,
    this.style,
    this.contentPadding,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return floatingLabel == null
        ? _textField(context)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _labelWidget(context),
              const SizedBox(height: 4),
              _textField(context),
              const SizedBox(height: 4),
              if (helperText != null) _helperWidget(context),
            ],
          );
  }

  Color _getTextColor() {
    if (textColor != null) return textColor!;

    if (disabledInput ?? false) {
      return const Color(0xFF79716B);
    }

    if (readOnly && disabledInput == null) {
      return const Color(0xFF79716B);
    }
    return Colors.black;
  }

  Widget _textField(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      autofocus: autoFocus,
      focusNode: focusNode,
      maxLines: maxLines,
      onTap: onTap,
      readOnly: readOnly,
      initialValue: initialValue,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      autofillHints: autofillHints,
      style: style ??
          Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
      decoration: decoration ??
          InputDecoration(
            label: Text(
              labelText ?? '',
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: const Color.fromRGBO(66, 66, 66, 1)),
            ),
            alignLabelWithHint: (maxLines ?? 1) > 1,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            prefixIcon: prefixIconData == null
                ? prefixIcon
                : Icon(
                    prefixIconData,
                    color: const Color(0xFF79716B),
                  ),
            suffixIcon: sufixIcon,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF79716B),
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xffD7D3D0),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xffD7D3D0),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xffD7D3D0),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
          ),
    );
  }

  Widget _labelWidget(BuildContext context) {
    return Text(
      showTwoPointsFloatingLabel ? "${floatingLabel!}:" : floatingLabel!,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
    );
  }

  Widget _helperWidget(BuildContext context) => Text(helperText!,
      style:
          Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey));
}
