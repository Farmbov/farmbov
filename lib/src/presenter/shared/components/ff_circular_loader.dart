import 'package:flutter/material.dart';

import 'package:farmbov/src/common/themes/theme_constants.dart';

class FFCircularLoader extends StatelessWidget {
  final double width;
  final double height;

  const FFCircularLoader({
    super.key,
    this.width = 60,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white.withOpacity(0.3),
          valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryGreen),
          strokeWidth: 2,
        ),
      ),
    );
  }
}
