import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/presenter/features/animals/animals_page_store.dart';
import 'package:farmbov/src/presenter/features/animals/widgets/animals_listing.dart';
import 'package:farmbov/src/presenter/features/home/widgets/section_action_button.dart';
import 'package:farmbov/src/presenter/features/search_animal/search_animal_widget.dart';
import 'package:farmbov/src/presenter/shared/components/ff_section_button.dart';
import 'package:farmbov/src/presenter/shared/components/generic_page_content.dart';
import 'package:farmbov/src/presenter/shared/components/no_content_page.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/shared/pages/generic_page/generic_page_mixin.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../shared/components/animal_situation_label.dart';
import '../home/widgets/generic_table_item.dart';
import '../home/widgets/generic_table_item_action.dart';

import 'widgets/advanced_filter_bottom_sheet.dart';

class AnimalsPage extends StatefulWidget {
  final AnimalsPageStore store;

  const AnimalsPage({super.key, required this.store});

  @override
  AnimalsPageState createState() => AnimalsPageState();
}

class AnimalsPageState extends State<AnimalsPage> with GenericPageMixin {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget get web => _buildWeb(context);

  @override
  Widget get mobile => _buildMobile(context);

  @override
  String get title => 'Animais';

  @override
  bool get allowBackButton => true;

  @override
  Widget get noContentPage => NoContentPage(
        title: 'Nenhum animal cadastrado',
        description: 'Você ainda não cadastrou nenhum animal.',
        actionTitle: 'Adicionar animal',
        action: showAnimalCreateModal(context),
      );

  Widget _buildSearchBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchAnimalWidget(
          onlyActive: !widget.store.showDownAnimal,
          searchController: _searchController,
        ),
        const SizedBox(height: 2),
        IconButton(
            onPressed: () {
              showAdvancedFilterBottomSheet(context, widget.store);
            },
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.filter_list,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text('Busca Avançada',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.primaryGreen, fontSize: 14)),
              ],
            )),
        const SizedBox(height: 14),
      ],
    );
  }

  void showAdvancedFilterBottomSheet(
      BuildContext context, AnimalsPageStore store) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AdvancedFilterBottomSheet(store: store);
      },
    );
  }

  Widget _buildListing(BuildContext context) {
    return Observer(builder: (_) {
      return ValueListenableBuilder(
          valueListenable: AppManager.instance.currentFarmNotifier,
          builder: (context, _, __) {
            return AnimalsListing(
              searchQuery: widget.store.searchController.text,
              showDownAnimals: widget.store.showDownAnimal,
              deleteAction: (animal) => widget.store.deleteAnimalModal(
                context,
                animal,
              ),
            );
          });
    });
  }

  Column _generateAnimalRow(animal, BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => context.goNamedAuth(
            RouteName.animalVisualize,
            params: {"id": animal!.ffRef!.id},
            extra: {"model": animal},
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GenericTableItem(
                  showBorder: false,
                  text: animal.tagNumber,
                  fontSize: 12,
                  animal: animal,
                ),
              ),
              Expanded(
                child: GenericTableItem(
                  showBorder: false,
                  text: animal.lot,
                  fontSize: 12,
                  animal: animal,
                ),
              ),
              Expanded(
                child: GenericTableItem(
                  showBorder: false,
                  text: animal.birthDate == null
                      ? '-'
                      : DateFormat('dd/MM/yyyy').format(
                          animal.birthDate!,
                        ),
                  fontSize: 12,
                ),
              ),
              Expanded(
                child: GenericTableItem(
                  showBorder: false,
                  fontSize: 12,
                  alignment: Alignment.center,
                  child: AnimalSituationLabel(active: animal.active),
                ),
              ),
              Expanded(
                child: GenericTableItem(
                  showBorder: false,
                  alignment: Alignment.center,
                  child: animal.active
                      ? GenericTableItemAction(
                          id: animal.ffRef?.id ?? "-1",
                          detailsAction: () => context.goNamedAuth(
                            RouteName.animalVisualize,
                            params: {"id": animal.ffRef?.id ?? "-1"},
                            extra: {"model": animal},
                          ),
                          editAction: () => context.goNamedAuth(
                            RouteName.animalUpdate,
                            params: {"id": animal.ffRef?.id ?? "-1"},
                            extra: {"model": animal},
                          ),
                          deleteAction: () =>
                              widget.store.deleteAnimalModal(context, animal),
                        )
                      : const SizedBox(width: 50, child: Divider()),
                ),
              ),
            ],
          ),
        ),
        const Divider()
      ],
    );
  }

  Widget _buildDashboardListAnimals(BuildContext context) {
    return Column(
      children: [
        const AnimalsTableHeader(),
        const Divider(),
        Observer(builder: (_) {
          final bool hasToLoadMore = widget.store.hasMoreAnimalsToLoad;

          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.store.animalsList.length + 1,
              itemBuilder: (_, index) {
                if (index < widget.store.animalsList.length) {
                  final animal = widget.store.animalsList[index];
                  return _generateAnimalRow(animal, context);
                } else {
                  if (hasToLoadMore == true) {
                    return VisibilityDetector(
                        key: const Key('circular-loading'),
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction > 0) {
                            widget.store.loadAnimals(); // Carrega mais animais
                          }
                        },
                        child:
                            const Center(child: CircularProgressIndicator()));
                  } else {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 130),
                      child: Text(
                        'Não há mais animais para carregar!',
                        style: TextStyle(
                            fontSize: 15, color: AppColors.neutralGray),
                      ),
                    ));
                  }
                }
              });
        }),
      ],
    );
  }

  Widget _buildActionButtons() {
    return ResponsiveBreakpoints.of(context).isMobile
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FFSectionButton(
                title: "Dar baixa",
                width: 120,
                height: 40,
                icon: Icons.remove,
                onPressed: () => context.goNamedAuth(RouteName.animalDown),
                backgroundColor: AppColors.feedbackDanger,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              FFSectionButton(
                title: 'Cadastrar animais',
                width: 170,
                height: 40,
                icon: Icons.add,
                onPressed: () => showAnimalCreateModal(context),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SectionActionButton(
                title: "Dar baixa",
                width: 120,
                height: 40,
                icon: Icons.remove,
                onPressed: () => context.goNamedAuth(RouteName.animalDown),
                color: AppColors.feedbackDanger,
                displayBorder: false,
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () => showAnimalCreateModal(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(color: AppColors.primaryGreen),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      Text(
                        'Cadastrar Animais',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
  }

  Widget _buildWeb(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        const SizedBox(height: 20),
        // _buildListing(context),

        _buildDashboardListAnimals(context),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      children: [_buildSearchBar(), _buildDashboardListAnimals(context)],
    );
  }

  Widget _buildContent(BuildContext context) {
    return GenericPageContent(
      title: 'Meus Animais',
      actionWidget: _buildActionButtons(),
      useGridRows: false,
      showBackButton: true,
      onBackButtonPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.goNamed(RouteName.dashboard);
        }
      },
      padding: ResponsiveBreakpoints.of(context).isMobile
          ? const EdgeInsets.symmetric(horizontal: 8)
          : const EdgeInsets.all(24),
      children: [
        ResponsiveBreakpoints.of(context).isMobile
            ? _buildMobile(context)
            : _buildWeb(context)
      ],
    );
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
      valueListenable: AppManager.instance.currentFarmNotifier,
      builder: (context, _, ___) {
        return _buildContent(context);
      });
}

class AnimalsTableHeader extends StatelessWidget {
  const AnimalsTableHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GenericTableItem(
            text: "Nº Brinco",
            header: true,
            showBorder: false,
          ),
        ),
        Expanded(
          child: GenericTableItem(
            text: "Lote",
            header: true,
            showBorder: false,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: GenericTableItem(
            text: "Nasc",
            header: true,
            showBorder: false,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: GenericTableItem(
            text: "Situação",
            header: true,
            showBorder: false,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: GenericTableItem(
            text: "Ação",
            header: true,
            showBorder: false,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
