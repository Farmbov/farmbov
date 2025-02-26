import 'package:flutter/material.dart';

import '../../../../../common/themes/theme_constants.dart';
import '../../../../shared/components/ff_button.dart';
import '../animal_import_page_store.dart';

class DownloadTemplateSection extends StatelessWidget {
  final AnimalImportPageStore store;

  const DownloadTemplateSection({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Baixar planilha',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  color: const Color(0xFF292524),
                ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 20),
          Text(
            'Você ainda não possui animais cadastrados',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
          ),
          const SizedBox(height: 20),
          FFButton(
            type: FFButtonType.outlined,
            onPressed: () => store.downloadTemplate(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.download_outlined,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Baixar planilha de exemplo',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: AppColors.primaryGreen,
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
