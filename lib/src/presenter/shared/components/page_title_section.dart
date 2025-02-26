import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class PageTitleSection extends StatelessWidget {
  final String title;
  final List<Widget>? content;

  const PageTitleSection({
    super.key,
    required this.title,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryGreenDark,
              ),
          textAlign: TextAlign.start,
        ),
        if (content != null) ...[
          // TODO: change sizes mobile vs desktop
          const SizedBox(height: 16),
          ...content!,
          const SizedBox(height: 24),
        ],
      ],
    );
  }
}
