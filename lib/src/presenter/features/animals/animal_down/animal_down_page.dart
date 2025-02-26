import 'package:farmbov/src/domain/models/animal_down_reason_model.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';
import 'package:farmbov/src/presenter/features/animals/animal_down/animal_down_page_store.dart';
import 'package:farmbov/src/presenter/features/search_animal/search_animal_widget.dart';
import 'package:farmbov/src/presenter/shared/components/image_network_preview.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:farmbov/src/presenter/shared/modals/base_modal_bottom_sheet.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AnimalDownPage extends StatefulWidget {
  final AnimalModel? model;
  final AnimalDownPageStore store;

  const AnimalDownPage({super.key, required this.store, this.model});

  @override
  AnimalDownPageState createState() => AnimalDownPageState();
}

class AnimalDownPageState extends State<AnimalDownPage> {
  final TextEditingController _searchAnimal = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.store.init(model: widget.model);
  }

  @override
  void dispose() {
    widget.store.dispose();
    _searchAnimal.dispose();
    super.dispose();
  }

  Widget _animalDetails(String title, String leading) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(vertical: -3),
      trailing: Text(
        leading,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TripleBuilder(
      store: widget.store,
      builder: (_, model) => BaseModalBottomSheet(
        title: 'Dar baixa no meu animal',
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Form(
            key: widget.store.formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informações do animal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: const Color(0xFF292524),
                      ),
                  textAlign: TextAlign.start,
                ),
                if (widget.store.selectedAnimal.value == null) ...[
                  SearchAnimalWidget(
                    searchController: _searchAnimal,
                    onAnimalSelected: widget.store.selectAnimal,
                  ),
                  const SizedBox(height: 200),
                ] else ...[
                  Observer(
                    builder: (_) => StreamBuilder<AnimalModel>(
                      stream: AnimalModel.getDocument(
                          widget.store.selectedAnimal.value!.ffRef!),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              color: AppColors.primaryGreen,
                            ),
                          );
                        }

                        final animal = snapshot.data;

                        if (animal == null) {
                          return Text(
                            'Animal não encontrado',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: const Color(0xFF292524),
                                ),
                            textAlign: TextAlign.start,
                          );
                        }

                        return Column(
                          children: [
                            _animalDetails(
                              'Brinco do animal:',
                              animal.tagNumber ?? '-',
                            ),
                            const Divider(),
                            _animalDetails(
                              'Lote:',
                              animal.lot ?? '-',
                            ),
                            if (animal.photoUrl?.isNotEmpty ?? false) ...[
                              ImageNetworkPreview(imageUrl: animal.photoUrl!),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Motivo da baixa:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF44403C),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder<List<AnimalDownReasonModel>>(
                    future: widget.store.getAnimalDownReason(context),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            color: AppColors.primaryGreen,
                          ),
                        );
                      }

                      final motivos = snapshot.data;

                      if (motivos == null || motivos.isEmpty) {
                        return Text(
                          'Nenhum motivo encontrado',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF292524),
                                  ),
                          textAlign: TextAlign.start,
                        );
                      }

                      return DropdownButtonFormField<AnimalDownReasonModel>(
                        value: widget.store.selectedAnimalDownReason.value,
                        decoration: InputDecoration(
                          labelText: 'Selecione o motivo',
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 10),
                        ),
                        dropdownColor: Theme.of(context).colorScheme.background,
                        onChanged: (selected) =>
                            widget.store.selectAnimalDownReason(selected),
                        items: motivos.map((motivo) {
                          return DropdownMenuItem<AnimalDownReasonModel>(
                            value: motivo,
                            child: Text(motivo.name ?? ''),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Observações',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          color: const Color(0xFF292524),
                        ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 8),
                  FFInput(
                    labelText: 'Observações adicionais da baixa',
                    controller: widget.store.notesController,
                    maxLines: 8,
                    validator: MultiValidator([
                      LengthRangeValidator(
                          min: 0,
                          max: 512,
                          errorText:
                              'O campo deve ter no máximo 512 caracteres.')
                    ]).call,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 40),
          FFButton(
            text: 'Confirmar',
            onPressed: widget.store.formIsValid()
                ? () => widget.store.finish(context)
                : null,
          ),
          if (ResponsiveBreakpoints.of(context).isMobile) ...[
            const SizedBox(height: 16),
            FFButton(
              text: 'Cancelar',
              type: FFButtonType.outlined,
              onPressed: () => context.pop(),
              backgroundColor: Colors.transparent,
              borderColor: AppColors.primaryGreen,
              splashColor: AppColors.primaryGreen.withOpacity(0.1),
            ),
          ],
        ],
      ),
    );
  }
}
