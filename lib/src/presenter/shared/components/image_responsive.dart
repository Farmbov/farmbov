import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageResponsive extends StatelessWidget {
  final String path;
  final String? semanticsLabel;
  final double width;
  final double? maxWidth;

  const ImageResponsive({
    super.key,
    required this.path,
    this.semanticsLabel,
    required this.width,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final calculatedWidth = width > (maxWidth ?? width) ? maxWidth : width;

    return SvgPicture.asset(
      path,
      semanticsLabel: semanticsLabel,
      width: calculatedWidth,
    );
  }
}
