import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/components/init_page_background.dart';
import 'package:farmbov/src/presenter/shared/components/image_responsive.dart';
import 'package:farmbov/src/common/router/route_name.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Widget _buildMobile(BuildContext context) {
    return InitPageBackground(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: ImageResponsive(
                  path: 'assets/images/logos/logo_white.svg',
                  semanticsLabel: 'Farmbov logo',
                  width: Adaptive.w(70),
                  maxWidth: 400,
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    FFButton(
                      text: 'Entrar',
                      onPressed: () => context.goNamed(RouteName.signin),
                      backgroundColor: Colors.white,
                      textColor: AppColors.primaryGreen,
                    ),
                    const SizedBox(height: 16),
                    FFButton(
                      text: 'Cadastrar-se',
                      onPressed: () => context.goNamed(RouteName.signup),
                      type: FFButtonType.outlined,
                      backgroundColor: Colors.white,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeb(BuildContext context) {
    return InitPageBackground(
      children: [
        FFButton(
          text: 'Entrar',
          onPressed: () => context.goNamed(RouteName.signin),
        ),
        const SizedBox(height: 16),
        FFButton(
          text: 'Cadastrar-se',
          onPressed: () => context.goNamed(RouteName.signup),
          type: FFButtonType.outlined,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBreakpoints.of(context).isMobile
          ? _buildMobile(context)
          : _buildWeb(context),
    );
  }
}
