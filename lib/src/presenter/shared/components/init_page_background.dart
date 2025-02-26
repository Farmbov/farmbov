import 'package:farmbov/src/common/helpers/context_extensions.dart';
import 'package:farmbov/src/presenter/shared/components/image_responsive.dart';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class InitPageBackground extends StatefulWidget {
  final List<Widget> children;
  final bool customTopAlignment;

  const InitPageBackground({
    super.key,
    required this.children,
    this.customTopAlignment = false,
  });

  @override
  State<InitPageBackground> createState() => _InitPageBackgroundState();
}

class _InitPageBackgroundState extends State<InitPageBackground> {
  final scrollController = ScrollController();

  Widget _buildWeb(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SafeArea(
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(),
                        Column(
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => context.goRoot(),
                                child: ImageResponsive(
                                  path: 'assets/images/logos/logo.svg',
                                  semanticsLabel: 'Farmbov logo',
                                  width: Adaptive.w(30),
                                  maxWidth: 400,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 800),
                              child: Column(
                                children: widget.children,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            '© Farmbov',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.repeatY,
                    alignment: Alignment.centerRight,
                    image: Image.asset(
                      'assets/images/grass-field.png',
                    ).image,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.multiply,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF449152).withOpacity(0.8),
                      const Color(0xFF064B11).withOpacity(0.8),
                    ],
                    stops: const [0.0, 1.0],
                    tileMode: TileMode.clamp,
                    transform: const GradientRotation(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  repeat: ImageRepeat.repeatY,
                  alignment: widget.customTopAlignment
                      ? isKeyboardVisible
                          ? const Alignment(0, 2)
                          : Alignment.center
                      : Alignment.topCenter,
                  image: Image.asset(
                    'assets/images/grass-field.png',
                  ).image,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                backgroundBlendMode: BlendMode.multiply,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF449152).withOpacity(0.8),
                    const Color(0xFF064B11).withOpacity(0.8),
                  ],
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp,
                  transform: const GradientRotation(2),
                ),
              ),
            ),
            ...widget.children,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isMobile
        ? _buildMobile(context)
        : _buildWeb(context);
  }
}
