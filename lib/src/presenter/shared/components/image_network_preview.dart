import 'package:farmbov/src/common/themes/theme_constants.dart';

import 'package:flutter/material.dart';

class ImageNetworkPreview extends StatelessWidget {
  final String imageUrl;

  const ImageNetworkPreview({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      width: MediaQuery.of(context).size.width,
      height: 200,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
          InteractiveViewer(
        panEnabled: false,
        boundaryMargin: const EdgeInsets.all(100),
        alignment: Alignment.center,
        minScale: 0.5,
        maxScale: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: child,
        ),
      ),
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return InteractiveViewer(
            panEnabled: false,
            boundaryMargin: const EdgeInsets.all(100),
            minScale: 0.5,
            maxScale: 2,
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: child,
            ),
          );
        }

        return const SizedBox(
          height: 200,
          child: Center(
            child: SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                color: AppColors.primaryGreen,
              ),
            ),
          ),
        );
      },
    );
  }
}
