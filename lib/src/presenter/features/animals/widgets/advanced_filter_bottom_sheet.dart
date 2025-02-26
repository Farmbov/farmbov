import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/modals/base_modal_bottom_sheet.dart';
import '../animals_page_store.dart';

class AdvancedFilterBottomSheet extends StatelessWidget {
  final AnimalsPageStore store;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy'); // Formato de data

  AdvancedFilterBottomSheet({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return BaseModalBottomSheet(
      title: 'Busca Avançada',
      showCloseButton: true,
      children: [
        // Campo de Raça
        FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('farms')
                .doc(AppManager.instance.currentUser.currentFarm?.id)
                .collection('animal_breeds')
                .get(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.done:
                  return Observer(builder: (_) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Raça',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    color: Colors.black,
                                    backgroundColor: Colors.transparent,
                                    fontWeight: FontWeight.normal)),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xffD7D3D0),
                            ),
                          ),
                          child: DropdownButton<String>(
                            padding: const EdgeInsets.only(left: 10),
                            value: store.selectedBreed,
                            hint: const Text('Selecione a Raça'),
                            items: snapshot.data?.docs
                                .map((breed) => DropdownMenuItem<String>(
                                      value: breed['name'],
                                      child: Text(breed['name']),
                                    ))
                                .toList(),
                            onChanged: store.setSelectedBreed,
                            isExpanded: true,
                            underline: Container(),
                          ),
                        ),
                      ],
                    );
                  });
              }
            }),
        const SizedBox(height: 8),
        // Campo de Lote
        FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('farms')
                .doc(AppManager.instance.currentUser.currentFarm?.id)
                .collection('lots')
                .get(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.done:
                  return Observer(builder: (_) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lote',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    color: Colors.black,
                                    backgroundColor: Colors.transparent,
                                    fontWeight: FontWeight.normal)),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xffD7D3D0),
                            ),
                          ),
                          child: DropdownButton<String>(
                            padding: const EdgeInsets.only(left: 10),
                            value: store.selectedLot,
                            hint: const Text('Selecione um Lote'),
                            items: snapshot.data?.docs
                                .map((lot) => DropdownMenuItem<String>(
                                      value: lot['name'],
                                      child: Text(lot['name']),
                                    ))
                                .toList(),
                            onChanged: store.setSelectedLot,
                            isExpanded: true,
                            underline: Container(),
                          ),
                        ),
                      ],
                    );
                  });
              }
            }),
        const SizedBox(height: 8),
        // Campo de Sexo
        Observer(
          builder: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sexo',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.black,
                      backgroundColor: Colors.transparent,
                      fontWeight: FontWeight.normal)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xffD7D3D0),
                  ),
                ),
                child: DropdownButton<String>(
                  padding: const EdgeInsets.only(left: 10),
                  value: store.selectedSex,
                  hint: const Text('Selecione o Sexo'),
                  items: ['Macho', 'Fêmea']
                      .map((sex) => DropdownMenuItem<String>(
                            value: sex,
                            child: Text(sex),
                          ))
                      .toList(),
                  onChanged: store.setSelectedSex,
                  isExpanded: true,
                  underline: Container(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Campo de Situação
        Observer(
          builder: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.black,
                      backgroundColor: Colors.transparent,
                      fontWeight: FontWeight.normal)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xffD7D3D0),
                  ),
                ),
                child: DropdownButton<String>(
                  padding: const EdgeInsets.only(left: 10),
                  value: store.selectedStatus,
                  hint: const Text('Selecione a Situação'),
                  items: ['Ativo', 'Baixado']
                      .map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: store.setSelectedStatus,
                  isExpanded: true,
                  underline: Container(), // Remove a linha padrão
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Campo de Range de Data de Nascimento (Início e Fim)
        Observer(
          builder: (_) => Column(
            children: [
              // Data de Início
              FFInputDatePicker(
                labelText: store.birthDateStart != null
                    ? DateFormat('dd/MM/yyyy').format(store.birthDateStart!)
                    : '',
                floatingLabel: 'Data Nascimento Início',
                onSelectDate: store.setBirthDateStart,
              ),
              const SizedBox(height: 8),
              // Data de Fim
              FFInputDatePicker(
                labelText: store.birthDateEnd != null
                    ? DateFormat('dd/MM/yyyy').format(store.birthDateEnd!)
                    : '',
                floatingLabel: 'Data Nascimento Fim',
                onSelectDate: store.setBirthDateEnd,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                GoRouter.of(context).pop();
                store.clearFilters();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)))),
              onPressed: () {
                store.advancedAnimalsSearch(context);
                GoRouter.of(context).pop();
              },
              child: const Text(
                'Buscar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
