import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/domain/models/global_farm_model.dart';
import 'package:farmbov/src/domain/services/domain/vaccine_service.dart';
import 'package:farmbov/src/presenter/features/home/widgets/home_section_details.dart';
import 'package:farmbov/src/presenter/features/vaccines/vaccine_lot/vaccine_lot_update_model.dart';
import 'package:farmbov/src/presenter/features/vaccines/vaccine_lot/vaccine_lot_update_page_store.dart';
import 'package:farmbov/src/presenter/shared/components/ff_section_button.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/presenter/features/home/widgets/generic_table_item.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../common/themes/theme_constants.dart';
import '../../../../domain/models/vaccine_model.dart';

class VaccinesTableSection extends StatelessWidget {
  final VaccineLotUpdatePageStore? store;
  final bool mostRecent;
  final String? selectedLotId;

  const VaccinesTableSection({
    super.key,
    this.store,
    this.mostRecent = false,
    this.selectedLotId,
  });

  Widget _buildTable(
    BuildContext context,
    List<VaccineModel> vaccines,
    int amountActiveFarmAnimals,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.3),
          1: FlexColumnWidth(1.2),
          2: FlexColumnWidth(1.2),
        },
        children: [
          const TableRow(
            decoration: BoxDecoration(
              color: Color(0xFFFAFAF9),
            ),
            children: [
              GenericTableItem(
                text: "Vacina",
                header: true,
              ),
              GenericTableItem(
                text: "Imunização",
                header: true,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          ...vaccines.map(
            (vaccine) =>
                _buildTableContent(context, vaccine, amountActiveFarmAnimals),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableContent(
      BuildContext context, VaccineModel vaccine, int amountActiveFarmAnimals) {
    return TableRow(
      children: [
        GenericTableItem(text: vaccine.name),
        FutureBuilder<int>(
          //TODO: Mover para repository
          future: FirebaseFirestore.instance
              .collection('farms')
              .doc(AppManager.instance.currentUser.currentFarm?.id)
              .collection('animals_handlings')
              .where('handling_type', isEqualTo: 'sanitario')
              .where('vaccine', isEqualTo: vaccine.name)
              .count()
              .get()
              .then((value) => value.count!),
          builder: (context, snapshot) {
            if (snapshot.hasData == false || snapshot.data == null) {
              return const SizedBox(
                width: 15,
                height: 15,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final amountVaccineApplied = snapshot.data;
            return GenericTableItem(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text: '',
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      if (amountActiveFarmAnimals == 0) ...[
                        const TextSpan(
                          text: 'Sem Rebanho',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.neutralGray,
                          ),
                        ),
                      ] else if (amountActiveFarmAnimals ==
                          amountVaccineApplied) ...[
                        const TextSpan(
                          text: 'Rebanho Imunizado',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ] else if (amountVaccineApplied == 0) ...[
                        const TextSpan(
                          text: 'Nenhum Animal Imunizado',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.feedbackDanger,
                          ),
                        ),
                      ] else ...[
                        TextSpan(
                          text: '$amountVaccineApplied',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        const TextSpan(
                          text: ' de ',
                        ),
                        TextSpan(
                          text: '$amountActiveFarmAnimals',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        const TextSpan(
                          text: ' estão imunizados',
                        ),
                      ],
                    ],
                  ),
                ));
          },
        ),
      ],
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return const SizedBox(
      width: 50,
      height: 50,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildNotFoundWidget(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 40),
      child: Text(
        'Você ainda não aplicou vacinas.',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
      ),
    );
  }

  Query<Object?> queryVaccineBuilder(Query<Object?> vaccine) {
    var query = vaccine.where(
      'active',
      isEqualTo: true,
    );

    if (selectedLotId != null) {
      return query.where('lot_id', isEqualTo: selectedLotId);
    }

    return query;
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
          stream: VaccineService().listVaccinesAsStream(),
          builder: (context, snapshot) {
            if (snapshot.data == null || (snapshot.data?.isEmpty ?? false)) {
              return _buildNotFoundWidget(context);
            }

            final vaccines = snapshot.data!;
            vaccines.sort(
              (a, b) => a.name!.compareTo(b.name!),
            );

            return FutureBuilder<int>(
              //TODO: Mover para repository
              future: FirebaseFirestore.instance
                  .collection('farms')
                  .doc(AppManager.instance.currentUser.currentFarm?.id)
                  .collection('animals')
                  .where('active', isEqualTo: true)
                  .count()
                  .get()
                  .then((value) => value.count!),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox(
                    width: 15,
                    height: 15,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final amountActiveFarmAnimals = snapshot.data;
                return _buildTable(context, vaccines, amountActiveFarmAnimals!);
              },
            );
          },
        ),
        if (ResponsiveBreakpoints.of(context).isMobile) ...[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: FFSectionButton(
              title: 'Aplicar vacinação em lote',
              icon: Icons.add,
              width: 250,
              onPressed: () => context.go(RouteName.vaccineLot),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return TripleBuilder(
      store: store ?? VaccineLotUpdatePageStore(),
      builder: (context, Triple<VaccineLotUpdatePageModel> model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSectionDetails(
            title: 'Vacinas',
            defaultSeeAllOption: false,
            morePageRoute: mostRecent ? RouteName.vaccines : null,
            child: ValueListenableBuilder<GlobalFarmModel?>(
                valueListenable: AppManager.instance.currentFarmNotifier,
                builder: (context, value, child) {
                  return _buildContent(context);
                }),
          ),
        ],
      ),
    );
  }
}
