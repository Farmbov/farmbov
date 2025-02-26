import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';


class GenericPageTitle extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? padding;

  const GenericPageTitle({
    super.key,
    required this.title,
    this.padding,
  });

  Widget _buildTitleMobile(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 16,
            color: const Color(0xFF292524),
          ),
      textAlign: TextAlign.start,
    );
  }

  Widget _buildTitleWeb(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 24,
            color: AppColors.primaryGreenDark,
          ),
      textAlign: TextAlign.start,
    );
  }

  Widget _buildContent(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return _buildTitleMobile(context, title);
    }

    return _buildTitleWeb(context, title);
  }

  @override
  Widget build(BuildContext context) {
    return padding == null
        ? _buildContent(context)
        : Padding(
            padding: padding!,
            child: _buildContent(context),
          );
  }
}
