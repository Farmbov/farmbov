import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/features/animals/animal_import/widgets/add_sheet_file_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/features/animals/animal_import/animal_import_page_model.dart';
import 'package:farmbov/src/presenter/features/animals/animal_import/animal_import_page_store.dart';
import 'package:farmbov/src/presenter/shared/components/page_appbar.dart';

import '../../../../common/helpers/custom_validators.dart';
import '../../../../common/providers/app_manager.dart';
import '../../../../domain/extensions/backend.dart';
import '../../../../domain/models/firestore/animal_breed_model.dart';
import '../../../../domain/models/firestore/lot_model.dart';
import '../../../shared/modals/base_alert_modal.dart';
import 'widgets/download_template_section.dart';

class AnimalImportPage extends StatefulWidget {
  final AnimalImportPageStore store;

  const AnimalImportPage({super.key, required this.store});

  @override
  AnimalImportPageState createState() => AnimalImportPageState();
}

class AnimalImportPageState extends State<AnimalImportPage> {
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndShowAlerts(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }


    Future<void> checkAndShowAlerts(BuildContext context) async {
    String? farmId = AppManager.instance.currentUser.currentFarm!.id;
    // Funções para verificar se há áreas e lotes ativos
    bool hasActiveLots = await _hasActiveDocuments('farms/$farmId/lots');

    if (!hasActiveLots) {
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => BaseAlertModal(
            type: BaseModalType.warning,
            title: 'Nenhum lote encontrado',
            description: 'Você precisa criar um lote ativo para continuar.',
            actionButtonTitle: 'Criar Lote',
            canPop: true,

            actionCallback: () {
              context.pop();
              context.pushNamed(RouteName.lots);
            }),
      );
    }
  }

// Função para verificar documentos ativos no Firestore
  Future<bool> _hasActiveDocuments(String collectionPath) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(collectionPath)
        .where('active', isEqualTo: true)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveBreakpoints.of(context).isMobile
          ? const PageAppBar(
              title: "Cadastrar meus animais",
              backButton: true,
            )
          : const PageAppBar(
              title: "Cadastrar meus animais",
              invertedColors: true,
            ),
      body: TripleBuilder<AnimalImportPageStore, AnimalImportPageModel>(
        store: widget.store,
        builder: (context, Triple<AnimalImportPageModel> model) =>
            CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: widget.store.isLoading
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                            child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Cadastrando Animais do arquivo...')
                          ],
                        )),
                      ],
                    )
                  : Column(
                      children: [
                        DownloadTemplateSection(store: widget.store),
                        const Divider(
                          thickness: 1,
                          color: Color(0xFFD7D3D0),
                        ),
                        AddSheetFileSection(
                          store: widget.store,
                          model: model,
                        ),
                        const Divider(),

                        //Raça
                        DropdownBreedAnimals(widget: widget, model: model),

                        //Lote
                        DropdownLotAnimals(
                          widget: widget,
                          model: model,
                        ),

                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: FFButton(
                            text: 'Cadastrar animais',
                            onPressed: model.state.uploadedFiles.isEmpty ||
                                    (model.state.selectedBreed == null ||
                                        model.state.selectedLot == null)
                                ? null
                                : () => widget.store.submit(context),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownBreedAnimals extends StatelessWidget {
  final AnimalImportPage widget;
  final Triple<AnimalImportPageModel> model;

  const DropdownBreedAnimals({
    super.key,
    required this.widget,
    required this.model,
  });

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
            'Configurações de Importação',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  color: const Color(0xFF292524),
                ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<AnimalBreedModel>>(
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

              var racaRacaRecordList = snapshot.data;

              if (racaRacaRecordList == null || racaRacaRecordList.isEmpty) {
                return Row(
                  children: [
                    Text(
                      'Nenhuma raça encontrada!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF292524),
                          ),
                      textAlign: TextAlign.start,
                    ),
                    TextButton(
                      onPressed: () => context.goNamedAuth(RouteName.settings),
                      child: const Text(
                        'Ir para página de configurações',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                );
              }

              final selectedBreed = model.state.selectedBreed;

              return DropdownButtonFormField<String?>(
                value: selectedBreed,
                decoration: InputDecoration(
                  labelText: 'Raça dos Animais',
                  labelStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: .1,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
                onChanged: (breed) {
                  widget.store
                      .update(model.state.copyWith(selectedBreed: breed));
                },
                items: racaRacaRecordList.map((option) {
                  return DropdownMenuItem<String?>(
                    value: option.name,
                    child: Text(option.name ?? '-'),
                  );
                }).toList(),
                validator: NotNullRequiredValidator(
                        errorText: 'Este campo é obrigatório.')
                    .call,
              );
            },
          ),
        ],
      ),
    );
  }
}

class DropdownLotAnimals extends StatelessWidget {
  final AnimalImportPage widget;
  final Triple<AnimalImportPageModel> model;

  const DropdownLotAnimals({
    super.key,
    required this.widget,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        left: 16,
        right: 16,
        bottom: 5,
      ),
      child: StreamBuilder<List<LotModel>>(
        stream: queryLotModel(),
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

          final loteList = snapshot.data;

          if (loteList == null || loteList.isEmpty) {
            return Row(
              children: [
                Text(
                  'Nenhum lote encontrado!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF292524),
                      ),
                  textAlign: TextAlign.start,
                ),
                TextButton(
                  onPressed: () => context.goNamedAuth(RouteName.lots),
                  child: const Text(
                    'Ir para página de lotes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            );
          }

          final selectedLot = model.state.selectedLot;

          return DropdownButtonFormField<String?>(
            value: selectedLot,
            decoration: InputDecoration(
              labelText: 'Lote dos animais',
              labelStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: .1,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
            onChanged: (lot) {
              widget.store.update(model.state.copyWith(selectedLot: lot));
            },
            items: loteList.map((option) {
              return DropdownMenuItem<String?>(
                value: option.name,
                child: Text(option.name ?? '-'),
              );
            }).toList(),
            validator:
                NotNullRequiredValidator(errorText: 'Este campo é obrigatório.')
                    .call,
          );
        },
      ),
    );
  }
}
