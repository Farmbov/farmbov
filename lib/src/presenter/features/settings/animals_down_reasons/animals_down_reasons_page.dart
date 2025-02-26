import 'package:farmbov/src/domain/models/animal_down_reason_model.dart';
import 'package:farmbov/src/presenter/features/settings/animals_down_reasons/animals_down_reasons_page_store.dart';

import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:farmbov/src/presenter/shared/components/generic_page_content.dart';
import 'package:farmbov/src/presenter/shared/components/no_content_page.dart';
import 'package:farmbov/src/presenter/shared/pages/generic_page/generic_page_mixin.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';

import '../../../../domain/repositories/animal_down_reasons_repository.dart';
import '../../../shared/components/ff_button.dart';

class AnimalsDownReasonsPage extends StatefulWidget {
  final AnimalsDownReasonsPageStore store;

  const AnimalsDownReasonsPage({super.key, required this.store});

  @override
  AnimalsDownReasonsPageState createState() => AnimalsDownReasonsPageState();
}

class AnimalsDownReasonsPageState extends State<AnimalsDownReasonsPage>
    with GenericPageMixin {
  @override
  AnimalsDownReasonsPageStore get baseStore => widget.store;

  @override
  Widget get web => _buildContent(context);

  @override
  Widget get mobile => _buildContent(context);

  @override
  String get title => 'Motivos de Baixa';

  @override
  bool get allowBackButton => false;

  @override
  Widget get noContentPage => const NoContentPage(
        title: 'Nenhum motivo de baixa',
        description: 'Você ainda não cadastrou nenhum motivo de baixa.',
      );

  Widget _buildContent(BuildContext context) {
    return TripleBuilder(
      store: widget.store,
      builder: (_, model) => GenericPageContent(
        title: 'Motivos de Baixa',
        useGridRows: false,
        showBackButton: true,
        onBackButtonPressed: () => context.pop(),
        children: [
          _buildListing(context),
        ],
      ),
    );
  }

  Widget _buildListing(BuildContext context) {
    final scrollController = ScrollController();

    return FutureBuilder<List<AnimalDownReasonModel>>(
      future: getAnimalDownReasons(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: AppColors.primaryGreen,
              ),
            ),
          );
        }

        final modelList = snapshot.data ?? [];

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (modelList.isEmpty)
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/icons/featured_search_icon.svg',
                    semanticsLabel: 'Chave',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum motivo de baixa',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          color: const Color(0xFF292524),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Você ainda não cadastrou nenhum motivo de baixa.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            Container(
              constraints: const BoxConstraints(maxHeight: 400),
              color: AppColors.neutralBlack.withOpacity(0.05),
              child: Scrollbar(
                thumbVisibility: true,
                controller: scrollController,
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: scrollController,
                  itemCount: modelList.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(modelList[index].name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        widget.store.deleteReason(
                          context,
                          model: modelList[index],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  flex: 2,
                  child: FFInput(
                    floatingLabel: 'Nome do Motivo',
                    controller: widget.store.reasonController,
                  ),
                ),
                const SizedBox(width: 20),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      FFButton(
                        text: 'Adicionar Motivo',
                        onPressed: () => widget.store.addReason(context),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => _buildContent(context);
}
