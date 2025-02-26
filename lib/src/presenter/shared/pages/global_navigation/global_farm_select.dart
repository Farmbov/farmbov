import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/models/firestore/farm_model.dart';
import 'package:farmbov/src/domain/models/global_farm_model.dart';
import 'package:farmbov/src/domain/repositories/farm_repository.dart';
import 'package:farmbov/src/presenter/shared/components/shared_label.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

FarmRepositoryImpl farmRepository = FarmRepositoryImpl();

class GlobalFarmSelect extends StatelessWidget {
  const GlobalFarmSelect({super.key});

  Widget _selectFarmBuilder(
    BuildContext context,
    List<DropdownMenuItem<GlobalFarmModel?>> items,
  ) {
    return ValueListenableBuilder(
        valueListenable: AppManager.instance.currentFarmNotifier,
        builder: (context, value, child) {
          return DropdownButtonHideUnderline(
            child: DropdownButton2<GlobalFarmModel?>(
              value: AppManager.instance.currentFarmNotifier.value,
              alignment: Alignment.center,
              isDense: true,
              iconStyleData: ResponsiveBreakpoints.of(context).isMobile
                  ? const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                    )
                  : const IconStyleData(
                      icon: Padding(
                        padding: EdgeInsets.only(right: 60),
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
              buttonStyleData: ButtonStyleData(
                height: 40,
                padding: const EdgeInsets.only(right: 10),
                decoration: ResponsiveBreakpoints.of(context).isMobile
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primaryGreenDark.withOpacity(0.2),
                      )
                    : null,
              ),
              selectedItemBuilder: (context) => items
                  .map((item) => Text(
                      '${AppManager.instance.currentUser.currentFarm!.name}',
                      style: ResponsiveBreakpoints.of(context).isMobile
                          ? const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.normal)
                          : const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.normal)))
                  .toList(),
              dropdownStyleData: DropdownStyleData(
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                ),
                offset: const Offset(-20, 0),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: MaterialStateProperty.all<double>(6),
                  thumbVisibility: MaterialStateProperty.all<bool>(true),
                ),
              ),
              onChanged: (farm) =>
                  Provider.of<AppManager>(context, listen: false)
                      .updateFarm(context, farm),
              items: items,
            ),
          );
        });
  }

  Widget _menuItem(BuildContext context,
      {String? farmName = '...',
      bool isShared = false,
      bool selected = false}) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Container(
          decoration: selected
              ? const BoxDecoration(
                  color: AppColors.primaryGreen,
                )
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  farmName ?? 'Fazendas',
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ),
              if (isShared) ...[
                SharedLabel(selected: selected),
              ],
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<GlobalFarmModel?>(
        valueListenable: AppManager.instance.currentFarmNotifier,
        builder: (context, globalFarmModel, child) {
          return FutureBuilder<List<FarmModel>>(
            future: farmRepository.getSharedFarmsToUser(
                FirebaseAuth.instance.currentUser?.uid ?? ''),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return _selectFarmBuilder(
                  context,
                  [
                    DropdownMenuItem<GlobalFarmModel>(
                      value: Provider.of<AppManager>(context)
                          .currentUser
                          .currentFarm,
                      child: _menuItem(context, farmName: 'Carregando...'),
                    ),
                  ],
                );
              }

              if (snapshot.data!.isEmpty) {
                return const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Você ainda não possui fazendas',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 14),
                  ),
                );
              } else {
                return _selectFarmBuilder(
                  context,
                  snapshot.data!.map(
                    (farm) {
                      final isShared = farm.ownerId !=
                          AppManager.instance.currentUser.user?.uid;

                      final menuItem = _menuItem(context,
                          farmName: farm.name,
                          isShared: isShared,
                          selected: farm.name ==
                              AppManager
                                  .instance.currentUser.currentFarm?.name);

                      return DropdownMenuItem<GlobalFarmModel>(
                        value: GlobalFarmModel(
                          id: farm.ffRef?.id,
                          name: farm.name,
                          userId: farm.ownerId,
                        ),
                        child: farm.name ==
                                AppManager
                                    .instance.currentUser.currentFarm?.name
                            ? Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                decoration: const BoxDecoration(
                                    color: AppColors.primaryGreen,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3))),
                                child: menuItem,
                              )
                            : menuItem,
                      );
                    },
                  ).toList(),
                );
              }
            },
          );
        });
  }
}
