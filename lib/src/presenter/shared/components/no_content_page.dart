import 'package:farmbov/src/presenter/shared/components/ff_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoContentPage extends StatelessWidget {
  final String title;
  final String description;
  final String? actionTitle;
  final VoidCallback? action;

  const NoContentPage({
    super.key,
    this.title = 'Ops!',
    this.description = 'Nada encontrado',
    this.actionTitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final availableHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: availableHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(),
            SvgPicture.asset(
              'assets/images/icons/featured_search_icon.svg',
              semanticsLabel: 'Chave',
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    color: const Color(0xFF292524),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
            if (actionTitle?.isNotEmpty ?? false) ...[
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: FFButton(
                  text: actionTitle,
                  onPressed: action,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
