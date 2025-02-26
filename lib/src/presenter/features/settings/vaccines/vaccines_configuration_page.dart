import 'package:farmbov/src/presenter/features/settings/vaccines/vaccine_modal.dart';

import 'package:farmbov/src/presenter/shared/components/generic_page_content.dart';
import 'package:farmbov/src/presenter/shared/components/no_content_page.dart';
import 'package:farmbov/src/presenter/shared/pages/generic_page/generic_page_mixin.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/components/ff_button.dart';
import 'vaccines_configuration_page_store.dart';

class VaccinesConfigurationPage extends StatefulWidget {
  final VaccinesConfigurationPageStore store;

  const VaccinesConfigurationPage({super.key, required this.store});

  @override
  VaccinesConfigurationPageState createState() =>
      VaccinesConfigurationPageState();
}

class VaccinesConfigurationPageState extends State<VaccinesConfigurationPage>
    with GenericPageMixin {
  @override
  void didChangeDependencies() async {
    await widget.store.fetchFarmVaccines();
    await widget.store.fetchDrugAdministrationTypes();
    super.didChangeDependencies();
  }

  @override
  Widget get web => _buildContent(context);

  @override
  Widget get mobile => _buildContent(context);

  @override
  String get title => 'Vacinas';

  @override
  bool get allowBackButton => true;

  @override
  Widget get noContentPage => const NoContentPage(
      title: 'Nenhuma Vacina Cadastrada',
      description:
          'Você ainda não cadastrou nenhuma vacina!');

  Widget _buildContent(BuildContext context) {
    return Observer(
      builder: (context) => GenericPageContent(
        title: 'Vacinas',
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

    final modelList = widget.store.vaccinesList;
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
                'Nenhuma Vacina!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      color: const Color(0xFF292524),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                'Você ainda não cadastrou nenhuma vacina',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        Observer(builder: (_) {
          return Container(
            constraints: const BoxConstraints(maxHeight: 400),
            color: AppColors.neutralBlack.withOpacity(0.05),
            child: Scrollbar(
              thumbVisibility: true,
              controller: scrollController,
              child: ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
                itemCount: modelList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(modelList[index].name!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                enableDrag: true,
                                context: context,
                                builder: (context) => VaccineModal(
                                    vaccine: modelList[index],
                                    store: widget.store),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              widget.store.deleteVaccine(
                                context,
                                vaccineModel: modelList[index],
                              );
                            },
                          ),
                        ],
                      ));
                },
              ),
            ),
          );
        }),
        const SizedBox(height: 40),

        //Input
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  Observer(builder: (_) {
                    return FFButton(
                      text: 'Cadastrar Vacina',
                      loading: widget.store.isLoading,
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          enableDrag: true,
                          context: context,
                          builder: (context) =>
                              VaccineModal(store: widget.store),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => _buildContent(context);
}
