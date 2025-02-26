import 'package:farmbov/src/domain/models/firestore/animal_breed_model.dart';
import 'package:farmbov/src/presenter/features/settings/animals_breeds/animals_breeds_page_store.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:farmbov/src/presenter/shared/components/generic_page_content.dart';
import 'package:farmbov/src/presenter/shared/components/no_content_page.dart';
import 'package:farmbov/src/presenter/shared/pages/generic_page/generic_page_mixin.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';

class AnimalsBreedsPage extends StatefulWidget {
  final AnimalsBreedsPageStore store;

  const AnimalsBreedsPage({super.key, required this.store});

  @override
  AnimalsBreedsPageState createState() => AnimalsBreedsPageState();
}

class AnimalsBreedsPageState extends State<AnimalsBreedsPage>
    with GenericPageMixin {
  @override
  AnimalsBreedsPageStore get baseStore => widget.store;

  @override
  Widget get web => _buildContent(context);

  @override
  Widget get mobile => _buildContent(context);

  @override
  String get title => 'Raças de animais';

  @override
  bool get allowBackButton => false;

  @override
  Widget get noContentPage => const NoContentPage(
        title: 'Nenhuma raça de animal',
        description: 'Você ainda não cadastrou nenhuma raça.',
      );

  Widget _buildContent(BuildContext context) {
    return TripleBuilder(
      store: widget.store,
      builder: (_, model) => GenericPageContent(
        title: 'Raças de animais',
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

    return FutureBuilder<List<AnimalBreedModel>>(
      future: getAnimalsBreedsWithDefault(),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                        'Nenhuma raça de animal',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 16,
                                  color: const Color(0xFF292524),
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Você ainda não cadastrou nenhuma raça.',
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
                        title: Text(modelList[index].name ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              widget.store.deleteBreed(
                                context,
                                model: modelList[index],
                              );
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  flex: 2,
                  child: FFInput(
                    floatingLabel: 'Nome da raça',
                    controller: widget.store.breedNameController,
                  ),
                ),
                const SizedBox(width: 20),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      FFButton(
                        text: 'Adicionar raça',
                        onPressed: () => widget.store.addBreed(context),
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
