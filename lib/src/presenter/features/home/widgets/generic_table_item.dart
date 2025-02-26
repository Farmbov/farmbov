import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class GenericTableItem extends StatelessWidget {
  final String? text;
  final Widget? child;
  final bool header;
  final double fontSize;
  final TextAlign textAlign;
  final Alignment? alignment;
  final bool goToAnimalDetails;
  final AnimalModel? animal;
  final bool showBorder;

  const GenericTableItem({
    super.key,
    this.text,
    this.child,
    this.header = false,
    this.fontSize = 12,
    this.textAlign = TextAlign.center,
    this.alignment,
    this.goToAnimalDetails = false,
    this.animal,
    this.showBorder = true,
  });

  Alignment? _getAlignment() {
    if (textAlign == TextAlign.center) {
      return Alignment.center;
    } else if (textAlign == TextAlign.right) {
      return Alignment.centerRight;
    }
    return Alignment.centerLeft;
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 60,
        maxHeight: 80,
      ),
      alignment: alignment ?? _getAlignment(),
      decoration: showBorder
          ? BoxDecoration(
              color: header ? const Color(0xFFFAFAF9) : null,
              border: const Border(
                bottom: BorderSide(
                  width: 1,
                  color: Color(0xFFE7E5E4),
                ),
              ),
            )
          : null,
      padding: ResponsiveBreakpoints.of(context).isMobile
          ? null
          : const EdgeInsets.symmetric(horizontal: 8),
      child: child ??
          Text(
            (text?.isEmpty ?? true) ? '-' : text!,
            textAlign: textAlign,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: header ? 13 : fontSize,
                  color:
                      header ? AppColors.primaryGreen : const Color(0xFF1C1917),
                  fontWeight: header ? FontWeight.w700 : FontWeight.w500,
                  decoration: goToAnimalDetails ? TextDecoration.none : null,
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return goToAnimalDetails &&
            ResponsiveBreakpoints.of(context).isMobile == false
        ? MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
              onTap: () => context.goNamedAuth(
                RouteName.animalVisualize,
                params: {"id": animal!.ffRef!.id},
                extra: {"model": animal},
              ),
              child: _buildContent(context),
            ),
          )
        : _buildContent(context);
  }
}
