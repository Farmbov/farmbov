import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/features/animals/animal_import/animal_import_page_model.dart';
import 'package:farmbov/src/presenter/features/animals/animal_import/animal_import_page_store.dart';
import 'package:flutter/material.dart';
import 'package:mobx_triple/mobx_triple.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AddSheetFileSection extends StatefulWidget {
  final AnimalImportPageStore store;
  final Triple<AnimalImportPageModel> model;

  const AddSheetFileSection(
      {super.key, required this.store, required this.model});

  @override
  State<AddSheetFileSection> createState() => _AddSheetFileSectionState();
}

class _AddSheetFileSectionState extends State<AddSheetFileSection> {
  Widget _fileUploadIndicator(String fileName, String size) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primaryGreen,
          style: BorderStyle.solid,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              maxRadius: 14,
              backgroundColor: Color(0xFFB5C9B8),
              child: Icon(
                Icons.insert_drive_file_outlined,
                size: 14,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    fileName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                Text(
                  size,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                ),
                const SizedBox(height: 10),
                LinearPercentIndicator(
                  lineHeight: 8,
                  percent: 1,
                  barRadius: const Radius.circular(8),
                  backgroundColor: Colors.grey[300],
                  progressColor: AppColors.primaryGreen,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Align(
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              maxRadius: 8,
              backgroundColor: AppColors.primaryGreen,
              child: Icon(
                Icons.check,
                size: 12,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
        left: 16,
        right: 16,
        bottom: 06,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Enviar planilha',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  color: const Color(0xFF292524),
                ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 20),
          if (widget.model.state.uploadedFiles.isNotEmpty) ...[
            ...widget.model.state.uploadedFiles.map(
              (f) => _fileUploadIndicator(
                f.name,
                widget.store.getFileSize(f.bytes!.length),
              ),
            ),
          ] else ...[
            Text(
              'Após preencher corretamente a planilha, envie a planilha no botão abaixo:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ],
          const SizedBox(height: 20),
          InkWell(
            onTap: () =>
                widget.store.selectFiles().then((value) => setState(() {})),
            splashColor: AppColors.primaryGreen.withOpacity(0.1),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFE7E5E4),
                  style: BorderStyle.solid,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 24,
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.upload_outlined,
                    color: Color(0xFF57534E),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Clique para enviar o arquivo',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreenDark,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'csv (Planilha excel)',
                    // 'xlsx, xlsm ou csv (Planilha excel)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF57534E),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
