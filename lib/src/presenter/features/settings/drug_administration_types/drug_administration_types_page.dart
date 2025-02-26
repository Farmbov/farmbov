import 'package:farmbov/src/domain/repositories/drug_adminstration_types_repository.dart';

import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:farmbov/src/presenter/shared/components/generic_page_content.dart';
import 'package:farmbov/src/presenter/shared/components/no_content_page.dart';
import 'package:farmbov/src/presenter/shared/pages/generic_page/generic_page_mixin.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';

import '../../../../domain/models/drug_administration_type.dart';
import '../../../shared/components/ff_button.dart';
import 'drug_administration_types_page_store.dart';

class DrugAdministrationTypesPage extends StatefulWidget {
  final DrugAdministrationTypesPageStore store;

  const DrugAdministrationTypesPage({super.key, required this.store});

  @override
  DrugAdministrationTypesPageState createState() =>
      DrugAdministrationTypesPageState();
}

class DrugAdministrationTypesPageState
    extends State<DrugAdministrationTypesPage> with GenericPageMixin {
  @override
  DrugAdministrationTypesPageStore get baseStore => widget.store;

  @override
  Widget get web => _buildContent(context);

  @override
  Widget get mobile => _buildContent(context);

  @override
  String get title => 'Vias de Administração de Vacinas';

  @override
  bool get allowBackButton => false;

  @override
  Widget get noContentPage => const NoContentPage(
      title: 'Nenhuma Via de Administração de Vacinas',
      description:
          'Você ainda não cadastrou nenhuma via de admnistração de vacinas.');

  Widget _buildContent(BuildContext context) {
    return TripleBuilder(
      store: widget.store,
      builder: (_, model) => GenericPageContent(
        title: 'Vias de Administração de Vacinas',
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

    return FutureBuilder<List<DrugAdministrationType>>(
      future: getDrugAdministrationTypes(context),
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
                    'Nenhuma via de administração',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          color: const Color(0xFF292524),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Você ainda não cadastrou nenhuma via de administração de vacinas',
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
                        widget.store.deleteDrugAdmType(
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
                    floatingLabel: 'Nome da Via de Administração',
                    controller: widget.store.typeController,
                  ),
                ),
                const SizedBox(width: 20),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      FFButton(
                        text: 'Adicionar Tipo',
                        onPressed: () => widget.store.addType(context),
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
