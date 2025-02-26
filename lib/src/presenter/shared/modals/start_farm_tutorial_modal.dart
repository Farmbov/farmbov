import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class StartFarmTutorialModal extends StatelessWidget {
  const StartFarmTutorialModal({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Container(
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: isMobile
          ? Center(child: _buildColumnLayout(context))
          : Center(child: _buildRowLayout(context)),
    );
  }

  Widget _buildColumnLayout(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Cadastre sua primeira fazenda!',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryGreenDark,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        SvgPicture.asset(
          'assets/images/illustrations/farm-find.svg',
          semanticsLabel: 'Nenhuma fazenda cadastrada',
          height: 150,
        ),
        const SizedBox(height: 24),
        Text(
          'Para usufruir o máximo da experiência Farmbov, é necessário criar sua primeira fazenda ou que alguém compartilhe uma fazenda com você.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: const Color(0xFF79716B),
              ),
        ),
        const SizedBox(height: 16),
        Text(
          'Crie agora e comece a organizar suas atividades na fazenda com total facilidade!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: const Color(0xFF79716B),
              ),
        ),
        const SizedBox(height: 40),
        FFButton(
          text: 'Cadastrar minha fazenda',
          onPressed: () => context.goNamed(RouteName.farms),
        ),
      ],
    );
  }

  Widget _buildRowLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: SvgPicture.asset(
              'assets/images/illustrations/farm-find.svg',
              semanticsLabel: 'Nenhuma fazenda cadastrada',
              height: 200,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cadastre sua primeira fazenda!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.primaryGreenDark,
                        fontSize: 24,
                      ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Para usufruir o máximo da experiência Farmbov, é necessário criar sua primeira fazenda ou que alguém compartilhe uma fazenda com você.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: const Color(0xFF79716B),
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Crie agora e comece a organizar suas atividades na fazenda com total facilidade!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: const Color(0xFF79716B),
                      ),
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FFButton(
                    text: 'Cadastrar minha fazenda',
                    onPressed: () => context.goNamed(RouteName.farms),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
