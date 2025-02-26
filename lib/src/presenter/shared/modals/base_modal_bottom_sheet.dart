import 'package:farmbov/src/common/helpers/context_extensions.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class BaseModalBottomSheet extends StatefulWidget {
  final String? title;
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final bool showCloseButton;


  const BaseModalBottomSheet({
    super.key,
    this.title,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.showCloseButton = false,
  });

  @override
  State<BaseModalBottomSheet> createState() => _BaseModalBottomSheetState();
}

class _BaseModalBottomSheetState extends State<BaseModalBottomSheet> {
  ScrollController scrollController = ScrollController();

  Widget _buildTitle(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).isMobile == false ||
        widget.showCloseButton) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 24),
          Text(
            widget.title!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryGreenDark,
                ),
            textAlign: TextAlign.center,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            iconSize: 24,
            color: const Color(0xFF79716B),
            onPressed: () {
              if (context.canPop()) {
                return context.pop();
              }
              context.goHome();
            },
          ),
        ],
      );
    }

    return Align(
      alignment: Alignment.center,
      child: Text(
        widget.title!,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primaryGreenDark,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ScrollController? scrollController,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: ResponsiveBreakpoints.of(context).isMobile
            ? const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              )
            : const BorderRadius.all(
                Radius.circular(16),
              ),
      ),
      child: Scrollbar(
        thumbVisibility: !ResponsiveBreakpoints.of(context).isMobile,
        thickness: 10,
        radius: const Radius.circular(8),
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20)
                .copyWith(top: 10),
            child: Column(
              crossAxisAlignment: widget.crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (ResponsiveBreakpoints.of(context).isMobile) ...[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF79716B),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 10),
                if (widget.title?.isNotEmpty ?? false) ...[
                  _buildTitle(context),
                ],
                ...widget.children
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    

    return ResponsiveBreakpoints.of(context).isMobile
        ? SafeArea(child: _buildContent(context, scrollController))
        : Padding(
            padding: const EdgeInsets.all(24),
            child: Align(
              alignment: Alignment.center,
              child: SafeArea(
                child: _buildContent(context, scrollController),
              ),
            ),
          );
  }
}
