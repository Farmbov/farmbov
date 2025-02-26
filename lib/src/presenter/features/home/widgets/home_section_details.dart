import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';

import 'package:flutter/material.dart';

class HomeSectionDetails extends StatelessWidget {
  final String title;
  final Widget? titleWidget;
  final Widget? child;
  final List<Widget>? detailsTiles;
  final String? morePageRoute;
  final Function? onMorePageRoute;
  final String? nameMorePageRoute;
  final bool defaultSeeAllOption;

  const HomeSectionDetails({
    super.key,
    required this.title,
    this.titleWidget,
    this.child,
    this.detailsTiles,
    this.morePageRoute,
    this.onMorePageRoute,
    this.nameMorePageRoute,
    this.defaultSeeAllOption = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            titleWidget ??
                Flexible(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          color: const Color(0xFF292524),
                        ),
                    textAlign: TextAlign.start,
                    softWrap: true,
                  ),
                ),
            if (morePageRoute?.isNotEmpty ?? false) ...[
              TextButton(
                onPressed: () => onMorePageRoute != null
                    ? onMorePageRoute!()
                    : context.goNamedAuth(morePageRoute!),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.bottomRight,
                  foregroundColor: Theme.of(context).colorScheme.background,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      nameMorePageRoute ??
                          (defaultSeeAllOption ? 'Ver todos' : 'Ver todas'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreenDark),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 16,
                      color: AppColors.primaryGreenDark,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        if (detailsTiles != null && detailsTiles!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xffD7D3D0),
                style: BorderStyle.solid,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: detailsTiles!,
            ),
          )
        ],
        if (child != null) ...[
          const SizedBox(height: 8),
          child!,
        ],
      ],
    );
  }
}
