import 'dart:math';

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';

import 'package:farmbov/src/domain/services/domain/animal_data_service.dart';
import 'package:farmbov/src/presenter/features/animals/animal_visualize/widgets/handling_reproduction_bar_chart.dart';
import 'package:farmbov/src/presenter/features/home/widgets/section_action_button.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../animals/animals_page_store.dart';

final animalDataService = AnimalDataService();

class AnimalsUpsDownsChart extends StatefulWidget {
  final void Function()? onAnimalTerminateEvent;
  final void Function()? onAnimalCreateEvent;

  const AnimalsUpsDownsChart({
    super.key,
    this.onAnimalTerminateEvent,
    this.onAnimalCreateEvent,
  });

  @override
  State<AnimalsUpsDownsChart> createState() => _AnimalsUpsDownsChartState();
}

class _AnimalsUpsDownsChartState extends State<AnimalsUpsDownsChart> {
  late int _selectedYear;
  List<int> _availableYears = [];
  final String? _farmId = AppManager.instance.currentUser.currentFarm!.id;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
  }

  //TODO: APENAS PARA MOCK DE ANIMAIS MOVER PRA LUGAR MAIS ADEQUADO
  // @override
  // void didChangeDependencies() async {
  //   final repository = AnimalRepositoryFakeData();
  //   final success = await repository.deactivateRandomAnimals(
  //       farmId: AppManager.instance.currentUser.currentFarm!.id!,
  //       quantity: 995);

  //   if (success) {
  //     print('Baixa realizada com sucesso!');
  //   } else {
  //     print('Falha na operação');
  //   }
  //   super.didChangeDependencies();
  // }

  void _handleYearChanged(int newYear) {
    setState(() {
      _selectedYear = newYear;
    });
  }

  Future<DocumentSnapshot> _getEntryExitData() async {
    return await FirebaseFirestore.instance
        .collection('farms')
        .doc(_farmId)
        .collection('farm_statistics')
        .doc('entry_exit')
        .get();
  }

  Future<DocumentSnapshot> _getYearData(int year) async {
    return await FirebaseFirestore.instance
        .doc('farms/$_farmId/farm_statistics/entry_exit/years/$year')
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'Entrada e Baixa de animais',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
                color: const Color(0xFF292524),
              ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: FutureBuilder<DocumentSnapshot>(
            future: _getEntryExitData(),
            builder: (context, statsSnapshot) {
              if (statsSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!statsSnapshot.hasData || !statsSnapshot.data!.exists) {
                return _buildEmptyState(context);
              }

              _availableYears = List<int>.from(
                statsSnapshot.data!.get('available_years') ?? [],
              )..sort();

              if (_availableYears.isEmpty) {
                return _buildEmptyState(context);
              }

              if (!_availableYears.contains(_selectedYear)) {
                _selectedYear = _availableYears.last;
              }

              return FutureBuilder<DocumentSnapshot>(
                future: _getYearData(_selectedYear),
                builder: (context, yearSnapshot) {
                  if (yearSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!yearSnapshot.hasData || !yearSnapshot.data!.exists) {
                    return _buildEmptyState(context);
                  }
                  return ValueListenableBuilder(
                      valueListenable: AppManager.instance.currentFarmNotifier,
                      builder: (context, _, __) {
                        return HandlingReproductionBarChart(
                          farmId: AppManager
                              .instance.currentFarmNotifier.value!.id!,
                        );
                      });
                },
              );
            },
          ),
        ),
        if (ResponsiveBreakpoints.of(context).isMobile) ...[
          const Divider(height: 40, color: Color(0xFFE7E5E4)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SectionActionButton(
                title: "Dar baixa",
                width: 120,
                height: 35,
                icon: Icons.remove,
                onPressed: widget.onAnimalTerminateEvent,
                color: AppColors.feedbackDanger,
                displayBorder: false,
              ),
              const SizedBox(width: 10),
              SectionActionButton(
                title: 'Cadastrar animais',
                width: 170,
                height: 35,
                icon: Icons.add,
                onPressed: widget.onAnimalCreateEvent,
              ),
            ],
          ),
        ]
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Você ainda não possui animais cadastrados.\n\n',
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              WidgetSpan(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => showAnimalCreateModal(context),
                    child: Text(
                      'Cadastre Animais',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
              const TextSpan(
                text: ' e acompanhe a evolução do seu rebanho!',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TODO: Mover esse tipo de clase para algum lugar para gerar dummie data e fazer testes em massa
// Colocar esse código em algum stateful widget visível quando precisar criar animals_down e desativar animais em massa

class AnimalRepositoryFakeData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<int> years = [2022, 2023]; // Lista de anos configurável

  Future<bool> deactivateRandomAnimals({
    required String farmId,
    required int quantity,
  }) async {
    try {
      final activeAnimals = await _firestore
          .collection('farms/$farmId/animals')
          .where('active', isEqualTo: true)
          .get();

      if (activeAnimals.size < quantity) {
        throw Exception('Não há animais ativos suficientes');
      }

      final randomAnimals = activeAnimals.docs.toList()..shuffle();
      final selectedAnimals = randomAnimals.take(quantity).toList();
      const reasons = [
        'Acidente',
        'Morte',
        'Desaparecimento',
        'Doença',
        'Venda',
        'Abate',
        'Roubo'
      ];

      final batch = _firestore.batch();
      final random = Random();

      for (final animalDoc in selectedAnimals) {
        // Escolher ano aleatório da lista
        final year = years[random.nextInt(years.length)];
        final downDate = _generateRandomDateForYear(year);

        batch.update(animalDoc.reference, {'active': false});

        batch.set(
          _firestore.collection('farms/$farmId/animals_down').doc(),
          {
            'active': false,
            'down_date': Timestamp.fromDate(downDate),
            'down_reason': reasons[random.nextInt(reasons.length)],
            'notes': '',
            'tag_number': animalDoc['tag_number'],
          },
        );
      }

      await batch.commit();
      return true;
    } catch (e) {
      print('Erro na baixa de animais: $e');
      return false;
    }
  }

  // Gerar data aleatória dentro de um ano específico
  DateTime _generateRandomDateForYear(int year) {
    final random = Random();
    final month = random.nextInt(12) + 1;
    final day = random.nextInt(DateTime(year, month + 1, 0).day) + 1;
    return DateTime(year, month, day, random.nextInt(24), random.nextInt(60));
  }
}
