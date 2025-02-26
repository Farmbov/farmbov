import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:farmbov/src/presenter/shared/components/ff_section_button.dart';
import 'package:farmbov/src/presenter/shared/components/page_appbar.dart';
import 'package:farmbov/src/presenter/shared/pages/generic_page/widgets/generic_page_title.dart';

class GenericPageContent extends StatelessWidget {
  final String? title;
  final EdgeInsetsGeometry? titlePadding;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final Widget? actionWidget;
  final String? actionTitle;
  final void Function()? actionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final PreferredSizeWidget? appBar;
  final bool useGridRows;
  final bool loading;
  final MainAxisAlignment childrenMainAxisAlignment;
  final CrossAxisAlignment childrenCrossAxisAlignment;
  final bool showBackButton;
  final void Function()? onBackButtonPressed;

  const GenericPageContent({
    super.key,
    required this.children,
    this.title,
    this.titlePadding,
    this.actionWidget,
    this.actionTitle,
    this.actionButton,
    this.floatingActionButtonLocation = FloatingActionButtonLocation.endFloat,
    this.appBar,
    this.useGridRows = true,
    this.padding = const EdgeInsets.all(24),
    this.loading = false,
    this.childrenMainAxisAlignment = MainAxisAlignment.center,
    this.childrenCrossAxisAlignment = CrossAxisAlignment.center,
    this.showBackButton = false,
    this.onBackButtonPressed,
  });

  Widget _responsiveRow(
    BuildContext context, {
    EdgeInsetsGeometry? padding,
    bool isMobile = true,
  }) {
    return StaggeredGrid.count(
      crossAxisCount: isMobile ? 1 : 2,
      // mainAxisSpacing: 4,
      crossAxisSpacing: Adaptive.dp(0.1),
      children: children,
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).isDesktop) return null;

    if (appBar != null) return appBar;
    return PageAppBar(
      title: title ?? 'Farmbov',
      backButton: showBackButton,
      onBackButtonPressed: onBackButtonPressed,
    );
  }

  // TODO: make it primary
  Widget _buildActionWidget() {
    if (actionWidget != null) return actionWidget!;

    if (actionTitle == null && actionButton == null) {
      return const SizedBox.shrink();
    }

    return FFSectionButton(
      title: actionTitle ?? 'Adicionar',
      icon: Icons.add,
      onPressed: actionButton,
      height: 40,
      width: 200,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    return Scaffold(
      appBar: _buildAppBar(context),
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButton: isMobile ? _buildActionWidget() : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: isMobile
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Skeletonizer(
                        enabled: loading,
                        justifyMultiLineText: false,
                        textBoneBorderRadius:
                            const TextBoneBorderRadius.fromHeightFactor(.5),
                        child: Row(
                          children: [
                            if (showBackButton && isDesktop) ...[
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: AppColors.primaryGreen,
                                ),
                                onPressed: onBackButtonPressed ??
                                    () => context.pop(),
                              ),
                            ],
                            if (!isMobile)
                              GenericPageTitle(
                                title: title!,
                                padding: titlePadding,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (isMobile == false) ...[
                      _buildActionWidget(),
                    ]
                  ],
                ),
                SizedBox(height: isMobile ? 24 : 40),
              ],
              if (useGridRows) ...[
                _responsiveRow(context, padding: padding, isMobile: isMobile),
              ] else ...[
                Column(
                  mainAxisAlignment: childrenMainAxisAlignment,
                  crossAxisAlignment: childrenCrossAxisAlignment,
                  children: children,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
