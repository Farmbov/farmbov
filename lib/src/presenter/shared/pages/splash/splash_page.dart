import 'package:farmbov/src/presenter/shared/components/ff_circular_loader.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        backgroundBlendMode: BlendMode.multiply,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF449152),
            Color(0xFF064B11),
          ],
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            // ResponsiveBreakpoints.of(context).isMobile
            //     ? 'assets/images/logos/logo_icon_white.svg'
            //     : 'assets/images/logos/logo_white.svg',
            'assets/images/logos/logo_white.svg',
            semanticsLabel: 'Farmbov logo',
          ),
          const SizedBox(height: 125),
          const FFCircularLoader(),
        ],
      ),
    );
  }
}
