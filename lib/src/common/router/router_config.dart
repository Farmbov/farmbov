import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/common/helpers/strings_helpers.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/domain/constants/animal_handling_types.dart';
import 'package:farmbov/src/domain/models/vaccine_model.dart';
import 'package:farmbov/src/presenter/features/account/account_update_page.dart';
import 'package:farmbov/src/presenter/features/account/account_update_page.store.dart';
import 'package:farmbov/src/presenter/features/animal_handlings/animal_handling_update/animal_handling_update_page.dart';
import 'package:farmbov/src/presenter/features/animal_handlings/animal_handling_update/animal_handling_update_page_store.dart';
import 'package:farmbov/src/presenter/features/animals/animal_down/animal_down_page.dart';
import 'package:farmbov/src/presenter/features/animals/animal_down/animal_down_page_store.dart';
import 'package:farmbov/src/presenter/features/animals/animal_import/animal_import_page.dart';
import 'package:farmbov/src/presenter/features/animals/animal_import/animal_import_page_store.dart';
import 'package:farmbov/src/presenter/features/animals/animal_update/animal_update_page.dart';
import 'package:farmbov/src/presenter/features/animals/animal_update/animal_update_page_store.dart';
import 'package:farmbov/src/presenter/features/animals/animal_visualize/animal_visualize_page.dart';
import 'package:farmbov/src/presenter/features/animals/animal_visualize/animal_visualize_page_store.dart';
import 'package:farmbov/src/presenter/features/areas/area_update/area_update_page.dart';
import 'package:farmbov/src/presenter/features/areas/area_update/area_update_page_store.dart';
import 'package:farmbov/src/presenter/features/delete_account/delete_account_page.dart';
import 'package:farmbov/src/presenter/features/farms/farm_shared_users/farm_shared_users_modal.dart';
import 'package:farmbov/src/presenter/features/farms/farm_update/farm_update_page.dart';
import 'package:farmbov/src/presenter/features/farms/farm_update/farm_update_page.store.dart';
import 'package:farmbov/src/presenter/features/farms/farms_page.dart';
import 'package:farmbov/src/presenter/features/farms/farms_page_store.dart';
import 'package:farmbov/src/presenter/features/lots/lot_update/lot_update_page.dart';
import 'package:farmbov/src/presenter/features/lots/lot_update/lot_update_page_store.dart';
import 'package:farmbov/src/presenter/features/lots/lot_visualize/lot_visualize_page.dart';
import 'package:farmbov/src/presenter/features/lots/lot_visualize/lot_visualize_page_store.dart';
import 'package:farmbov/src/presenter/features/privacy_policy/privacy_policy_page.dart';
import 'package:farmbov/src/presenter/features/reports/reports_page.dart';
import 'package:farmbov/src/presenter/features/settings/animals_breeds/animals_breeds_page.dart';
import 'package:farmbov/src/presenter/features/settings/animals_breeds/animals_breeds_page_store.dart';
import 'package:farmbov/src/presenter/features/settings/settings_page.dart';
import 'package:farmbov/src/presenter/features/settings/vaccines/vaccines_configuration_page.dart';
import 'package:farmbov/src/presenter/features/terms_conditions/terms_conditions_page.dart';
import 'package:farmbov/src/presenter/features/vaccines/vaccine_lot/vaccine_lot_update_page.dart';
import 'package:farmbov/src/presenter/features/vaccines/vaccine_lot/vaccine_lot_update_page_store.dart';
import 'package:farmbov/src/presenter/shared/pages/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/presenter/features/animals/animals_page.dart';
import 'package:farmbov/src/presenter/features/animals/animals_page_store.dart';
import 'package:farmbov/src/presenter/features/lots/lots_page.dart';
import 'package:farmbov/src/presenter/features/lots/lots_page_store.dart';
import 'package:farmbov/src/presenter/features/dashboard/dashboard_page.dart';
import 'package:farmbov/src/presenter/features/dashboard/dashboard_page_store.dart';
import 'package:farmbov/src/presenter/shared/pages/preload/preload_page.dart';
import 'package:farmbov/src/presenter/features/reports/reports_page_store.dart';
import 'package:farmbov/src/presenter/features/sign_in/sign_in_page.dart';
import 'package:farmbov/src/presenter/features/sign_in/sign_in_page_store.dart';
import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/presenter/features/sign_up/sign_up_page.dart';
import 'package:farmbov/src/presenter/features/sign_up/sign_up_page_store.dart';
import 'package:farmbov/src/presenter/features/welcome/welcome_page.dart';
import 'package:farmbov/src/presenter/features/home/home_page.dart';
import 'package:farmbov/src/presenter/features/home/home_page_store.dart';
import 'package:farmbov/src/presenter/features/reset_password/reset_password_page.dart';
import 'package:farmbov/src/presenter/features/reset_password/reset_password_store.dart';
import 'package:farmbov/src/presenter/shared/pages/global_navigation/global_navigation_tabs.dart';
import 'package:farmbov/src/presenter/shared/pages/preload/preload_page_store.dart';
import 'package:farmbov/src/presenter/shared/pages/under_maintenace/under_maintenance_page.dart';
import 'package:farmbov/src/presenter/features/areas/area_page.dart';
import 'package:farmbov/src/presenter/features/areas/areas_page_store.dart';
import 'package:farmbov/src/presenter/features/faq/faq_page.dart';
import 'package:farmbov/src/presenter/features/reports/report_down_animals/report_down_animals_page.dart';
import 'package:farmbov/src/presenter/features/reports/report_down_animals/report_down_animals_page_store.dart';
import 'package:farmbov/src/presenter/features/reports/report_inventory_animals/report_inventory_animals_page.dart';
import 'package:farmbov/src/presenter/features/reports/report_inventory_animals/report_inventory_animals_page_store.dart';
import 'package:farmbov/src/presenter/features/reports/report_management_animals/report_management_animals_page.dart';
import 'package:farmbov/src/presenter/features/reports/report_management_animals/report_management_animals_page_store.dart';
import 'package:farmbov/src/presenter/features/vaccines/vaccines_page.dart';
import 'package:farmbov/src/presenter/features/vaccines/vaccines_page_store.dart';
import 'package:farmbov/src/presenter/shared/pages/dialog_page/dialog_page.dart';

import '../../domain/models/firestore/animal_model.dart';
import '../../presenter/features/animal_handlings/widgets/reproduction_handling_modal.dart';
import '../../presenter/features/animal_handlings/widgets/vaccine_application_modal.dart';
import '../../presenter/features/animal_handlings/widgets/weighing_handling_modal.dart';
import '../../presenter/features/settings/animals_down_reasons/animals_down_reasons_page.dart';
import '../../presenter/features/settings/animals_down_reasons/animals_down_reasons_page_store.dart';
import '../../presenter/features/settings/drug_administration_types/drug_administration_types_page.dart';
import '../../presenter/features/settings/drug_administration_types/drug_administration_types_page_store.dart';
import '../../presenter/features/settings/vaccines/vaccines_configuration_page_store.dart';
import '../../presenter/features/vaccines/vaccine_batches/vaccine_batches_page.dart';
import '../../presenter/features/vaccines/vaccine_batches/vaccine_batches_page_store.dart';
import '../../presenter/shared/modals/start_farm_tutorial_modal.dart';

class AppRouterConfig {
  /// Em DEV, desabilita o Observer do Firebase Analytics.
  static List<NavigatorObserver> _getObservers() =>
      AppManager.isDEV ? [] : <NavigatorObserver>[AppManager.observer];

  static GoRouter createRouter(
    AppManager appStateNotifier, {
    List<NavigatorObserver>? observers,
  }) =>
      GoRouter(
        initialLocation: RouteName.root,
        debugLogDiagnostics: true,
        refreshListenable: appStateNotifier,
        errorBuilder: (context, _) => const SplashPage(),
        navigatorKey: NavigationService.rootNavigatorKey,
        redirect: (context, state) {
          debugPrint('Rota atual: ${state.fullPath}');

          // Verificações de estado do usuário
          final isUserAuthenticated =
              appStateNotifier.currentUser.user?.email != null;
          final hasFarm =
              appStateNotifier.currentFarmNotifier.value?.id != null;

          // Verificações de rotas
          final isUserCreatingFarm = (state.fullPath == '/fazendas' ||
              state.fullPath == '/fazendas/:id');
          final isInTutorial = state.fullPath == '/nova-jornada/iniciar';

          // Se o usuário estiver autenticado, não tiver fazenda e não estiver em uma das rotas permitidas
          if (isUserAuthenticated && !hasFarm && !isUserCreatingFarm) {
            // Evitar loop de redirecionamento se o usuário já estiver na rota do tutorial
            if (!isInTutorial) {
              return '/nova-jornada/iniciar';
            }
          }

          return null;
        },
        routes: [
          AppRoute(
            name: RouteName.privacyPolicy,
            path: RouteName.privacyPolicy,
            requireAuth: false,
            builder: (_, __) => const PrivacyPolicyPage(),
          ).toRoute(appStateNotifier),
          AppRoute(
            name: RouteName.termsConditions,
            path: RouteName.termsConditions,
            requireAuth: false,
            builder: (_, __) => const TermsConditionsPage(),
          ).toRoute(appStateNotifier),
          AppRoute(
            name: RouteName.deleteAccount,
            path: RouteName.deleteAccount,
            requireAuth: false,
            builder: (_, __) => const DeleteAccountPage(),
          ).toRoute(appStateNotifier),
          GoRoute(
              path: '/nova-jornada/iniciar',
              builder: (_, __) => const StartFarmTutorialModal()),
          AppRoute(
            name: RouteName.root,
            path: RouteName.root,
            requireAuth: false,
            builder: (_, __) => PreloadPage(store: PreloadPageStore()),
            routes: [
              AppRoute(
                name: RouteName.welcome,
                path: RouteName.welcome,
                requireAuth: false,
                builder: (_, __) => const WelcomePage(),
              ),
              AppRoute(
                name: RouteName.signin,
                path: RouteName.signin,
                requireAuth: false,
                builder: (_, __) => SignInPage(store: SignInPageStore()),
              ),
              AppRoute(
                name: RouteName.signup,
                path: RouteName.signup,
                requireAuth: false,
                builder: (_, __) => SignUpPage(store: SignUpPageStore()),
              ),
              AppRoute(
                name: RouteName.resetPassword,
                path: RouteName.resetPassword,
                requireAuth: false,
                builder: (_, __) =>
                    ResetPasswordPage(store: ResetPasswordStore()),
              ),
            ].map((r) => r.toRoute(appStateNotifier)).toList(),
          ).toRoute(appStateNotifier),
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) => GlobalNavigationTabs(
              location: state.uri.toString(),
              navigationShell: navigationShell,
              child: navigationShell,
            ),
            branches: [
              StatefulShellBranch(
                navigatorKey: NavigationService.menuKey,
                initialLocation: RouteName.home,
                routes: <RouteBase>[
                  AppRoute(
                    name: RouteName.home,
                    path: RouteName.home,
                    builder: (_, __) => HomePage(store: HomePageStore()),
                    routes: [
                      // TODO: migrate to FARM!!!
                      GoRoute(
                        path: RouteName.genericId,
                        pageBuilder: (_, state) {
                          final model = state.extra as Map<String, dynamic>?;
                          return DialogPage(
                            builder: (_) => FarmUpdatePage(
                              store: FarmUpdatePageStore(),
                              model: model?['model'],
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        path: RouteName.genericCreate,
                        pageBuilder: (_, __) => DialogPage(
                          builder: (_) =>
                              FarmUpdatePage(store: FarmUpdatePageStore()),
                        ),
                      ),
                    ],
                  ).toRoute(appStateNotifier),
                  AppRoute(
                    name: RouteName.underMaintenance,
                    path: RouteName.underMaintenance,
                    builder: (_, __) => const UnderMaintenancePage(),
                  ).toRoute(appStateNotifier),
                  AppRoute(
                    name: RouteName.account,
                    path: RouteName.account,
                    builder: (_, __) =>
                        AccountUpdatePage(store: AccountUpdatePageStore()),
                  ).toRoute(appStateNotifier),
                  AppRoute(
                    name: RouteName.faq,
                    path: RouteName.faq,
                    builder: (_, __) => const FaqPage(),
                  ).toRoute(appStateNotifier),
                ],
              ),
              StatefulShellBranch(
                initialLocation: RouteName.reports,
                routes: <RouteBase>[
                  AppRoute(
                    name: RouteName.reports,
                    path: RouteName.reports,
                    builder: (_, __) => ReportsPage(store: ReportsPageStore()),
                    routes: [
                      AppRoute(
                        name: RouteName.animalsDown,
                        path: RouteName.animalsDown,
                        builder: (_, __) => ReportDownAnimalsPage(
                          store: ReportDownAnimalsPageStore(),
                          baseStore: ReportsPageStore(),
                        ),
                      ).toRoute(appStateNotifier),
                      AppRoute(
                        name: RouteName.animalsInventory,
                        path: RouteName.animalsInventory,
                        builder: (_, __) => ReportInventoryAnimalsPage(
                          store: ReportInventoryAnimalsPageStore(),
                          baseStore: ReportsPageStore(),
                        ),
                      ).toRoute(appStateNotifier),
                      AppRoute(
                        name: RouteName.animalsHandling,
                        path: RouteName.animalsHandling,
                        builder: (_, __) => ReportManagementAnimalsPage(
                          store: ReportManagementAnimalsPageStore(),
                          baseStore: ReportsPageStore(),
                        ),
                      ).toRoute(appStateNotifier),
                    ],
                  ).toRoute(appStateNotifier),
                ],
              ),
              StatefulShellBranch(
                initialLocation: RouteName.dashboard,
                routes: <RouteBase>[
                  AppRoute(
                      name: RouteName.dashboard,
                      path: RouteName.dashboard,
                      builder: (_, __) =>
                          DashboardPage(store: DashboardPageStore()),
                      routes: []).toRoute(appStateNotifier),
                  AppRoute(
                    name: RouteName.animals,
                    path: RouteName.animals,
                    builder: (_, params) {
                      final model = params.extra as Map<String, dynamic>?;
                      return AnimalsPage(
                        store: AnimalsPageStore(
                          showDownAnimal: model?['showDownAnimal'] ?? false,
                          showAllAnimals: model?['listAllAnimals'] ?? true,
                        ),
                      );
                    },
                    routes: [
                      GoRoute(
                        name: RouteName.animalsImport,
                        path: 'importar',
                        pageBuilder: (_, __) => NoTransitionPage(
                          child: AnimalImportPage(
                            store: AnimalImportPageStore(),
                          ),
                        ),
                      ),
                      GoRoute(
                        name: RouteName.animalCreate,
                        path: 'cadastrar',
                        pageBuilder: (_, state) => DialogPage(
                          builder: (_) => AnimalUpdatePage(
                            store: AnimalUpdatePageStore(),
                          ),
                        ),
                      ),
                      GoRoute(
                        name: RouteName.animalUpdate,
                        path: 'editar/:id',
                        pageBuilder: (_, state) {
                          final model = state.extra as Map<String, dynamic>?;
                          return DialogPage(
                            builder: (_) => AnimalUpdatePage(
                              store: AnimalUpdatePageStore(),
                              model: model?['model'],
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        name: RouteName.animalVisualize,
                        path: 'visualizar/:id',
                        pageBuilder: (context, state) {
                          final animalId = state.pathParameters['id'];
                          final model = state.extra as Map<String, dynamic>?;

                          // Caso o modelo já esteja disponível, renderiza diretamente
                          if (model != null && model['model'] != null) {
                            return NoTransitionPage(
                              child: AnimalVisualizePage(
                                store: AnimalVisualizePageStore(),
                                model: model['model'],
                              ),
                            );
                          }

                          // Caso contrário, busca o modelo no Firestore
                          return NoTransitionPage(
                            child: FutureBuilder<AnimalModel?>(
                              future: _fetchAnimalById(animalId!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Scaffold(
                                    body: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                if (snapshot.hasError ||
                                    snapshot.data == null) {
                                  // Redireciona para a tela de animais em caso de erro ou ID inválido
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    context.goNamed(RouteName.animals);
                                  });
                                  return const SizedBox.shrink();
                                }

                                final animalModel = snapshot.data!;
                                return AnimalVisualizePage(
                                  store: AnimalVisualizePageStore(),
                                  model: animalModel,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        name: RouteName.animalDown,
                        path: 'baixa',
                        pageBuilder: (_, state) {
                          return DialogPage(
                            builder: (_) => AnimalDownPage(
                              store: AnimalDownPageStore(),
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        name: RouteName.animalDownId,
                        path: 'baixa/:id',
                        pageBuilder: (_, state) {
                          final model = state.extra as Map<String, dynamic>?;
                          return DialogPage(
                            builder: (_) => AnimalDownPage(
                              store: AnimalDownPageStore(),
                              model: model?['model'],
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        name: RouteName.animalWeighingHandling,
                        path: 'manejos/pesagem/novo',
                        pageBuilder: (context, state) {
                          // Verifica se state.extra é null
                          if (state.extra == null) {
                            // Redireciona para outra rota
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              context.replace(RouteName.home);
                            });
                            // Retorna uma página vazia enquanto redireciona
                            return const MaterialPage(
                              child: SizedBox.shrink(),
                            );
                          }
                          final args = state.extra as Map<String, dynamic>?;

                          final animal = AnimalModel.getDocumentFromData(
                              args?['animal'],
                              reference: args?['reference']);

                          final store = AnimalHandlingUpdatePageStore(
                            animal: animal,
                            handlingType: AnimalHandlingTypes.pesagem,
                          );

                          return DialogPage(
                            useSafeArea: true,
                            builder: (_) => WeighingHandlingModal(store: store),
                          );
                        },
                      ),
                      GoRoute(
                        name: RouteName.animalVaccineHandling,
                        path: 'manejos/sanitario/novo',
                        pageBuilder: (context, state) {
                          // Verifica se state.extra é null
                          if (state.extra == null) {
                            // Redireciona para outra rota
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              context.replace(RouteName.home);
                            });
                            // Retorna uma página vazia enquanto redireciona
                            return const MaterialPage(
                              child: SizedBox.shrink(),
                            );
                          }
                          final args = state.extra as Map<String, dynamic>?;

                          final animal = AnimalModel.getDocumentFromData(
                              args?['animal'],
                              reference: args?['reference']);

                          final store = AnimalHandlingUpdatePageStore(
                            animal: animal,
                            handlingType: AnimalHandlingTypes.sanitario,
                          );
                          return DialogPage(
                            useSafeArea: true,
                            builder: (_) =>
                                VaccineApplicationModal(store: store),
                          );
                        },
                      ),
                      GoRoute(
                        name: RouteName.animalReproductionHandling,
                        path: 'manejos/reprodutivo/novo',
                        pageBuilder: (context, state) {
                          // Verifica se state.extra é null
                          if (state.extra == null) {
                            // Redireciona para outra rota
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              context.replace(RouteName.home);
                            });
                            // Retorna uma página vazia enquanto redireciona
                            return const MaterialPage(
                              child: SizedBox.shrink(),
                            );
                          }

                          final args = state.extra as Map<String, dynamic>?;

                          final animal = AnimalModel.getDocumentFromData(
                              args?['animal'],
                              reference: args?['reference']);

                          final store = AnimalHandlingUpdatePageStore(
                            animal: animal,
                            handlingType: AnimalHandlingTypes.reprodutivo,
                          );

                          return DialogPage(
                            useSafeArea: true,
                            builder: (_) =>
                                ReproductionHandlingModal(store: store),
                          );
                        },
                      ),
                      GoRoute(
                        name: 'manejos/:id',
                        path: 'manejos/:id',
                        pageBuilder: (_, state) {
                          final model = state.extra as Map<String, dynamic>?;
                          return DialogPage(
                            builder: (_) => AnimalHandlingUpdatePage(
                              store: AnimalHandlingUpdatePageStore(
                                model: model?['model'],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ).toRoute(appStateNotifier),
                ],
              ),
              StatefulShellBranch(
                  initialLocation: RouteName.vaccines,
                  routes: <RouteBase>[
                    AppRoute(
                      name: RouteName.vaccines,
                      path: RouteName.vaccines,
                      builder: (_, __) =>
                          VaccinesPage(store: VaccinesPageStore()),
                      routes: [
                        // GoRoute(
                        //   name: RouteName.vaccineCreate,
                        //   path: RouteName.genericCreate,
                        //   pageBuilder: (_, __) => DialogPage(
                        //     builder: (_) => VaccineModal(
                        //         store: VaccinesConfigurationPageStore()),
                        //   ),
                        // ),

                        // GoRoute(
                        //   name: RouteName.vaccineUpdate,
                        //   path: RouteName.genericId,
                        //   pageBuilder: (_, state) {
                        //     final model = state.extra as Map<String, dynamic>?;
                        //     return DialogPage(
                        //       builder: (_) => VaccineUpdatePage(
                        //         store: VaccineUpdatePageStore(
                        //           model: model?['model'],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),
                        GoRoute(
                          name: RouteName.vaccineLot,
                          path: RouteName.vaccineApplyLot,
                          pageBuilder: (_, state) {
                            final model = state.extra as Map<String, dynamic>?;
                            return DialogPage(
                              builder: (___) => VaccineLotUpdatePage(
                                store: VaccineLotUpdatePageStore(
                                  readOnly: model?['readOnly'] ?? false,
                                  model: model?['model'],
                                ),
                              ),
                            );
                          },
                        ),

                        GoRoute(
                          name: 'vacinaLotes',
                          path: ':vaccine_name/lotes',
                          pageBuilder: (context, state) {
                            final vaccineName =
                                state.pathParameters['vaccine_name'];

                            VaccineModel? vacina;
                            try {
                              vacina = state.extra as VaccineModel;

                              return NoTransitionPage(
                                child: VaccineBatchesPage(
                                  vaccineModel: vacina,
                                  store: VaccineBatchesPageStore(),
                                ),
                              );
                            } catch (e) {
                              return NoTransitionPage(
                                child: FutureBuilder<VaccineModel?>(
                                  future: _fetchVaccineByName(vaccineName!),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Scaffold(
                                        body: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }

                                    if (snapshot.hasError ||
                                        snapshot.data == null) {
                                      // Redireciona para a página de vacinas caso não encontre a vacina
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        context.goNamed(RouteName.vaccines);
                                      });
                                      return const SizedBox.shrink();
                                    }

                                    final vaccineModel = snapshot.data!;
                                    return VaccineBatchesPage(
                                      vaccineModel: vaccineModel,
                                      store: VaccineBatchesPageStore(),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                          redirect: (context, state) {
                            if (state.error != null) {
                              return RouteName.vaccines;
                            }
                            return null;
                          },
                        ),
                      ],
                    ).toRoute(appStateNotifier),
                  ]),
              StatefulShellBranch(
                initialLocation: RouteName.farms,
                routes: <RouteBase>[
                  AppRoute(
                    name: RouteName.farms,
                    path: RouteName.farms,
                    builder: (_, __) => FarmsPage(store: FarmsPageStore()),
                    routes: [
                      GoRoute(
                        path: RouteName.genericId,
                        pageBuilder: (_, state) {
                          final model = state.extra as Map<String, dynamic>?;
                          return DialogPage(
                            builder: (_) => FarmUpdatePage(
                              store: FarmUpdatePageStore(),
                              model: model?['model'],
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        name: 'compartilhados',
                        path: ':id/compartilhados',
                        pageBuilder: (_, state) {
                          String? farmId = state.pathParameters['id'];
                          return DialogPage(
                            builder: (_) => FarmSharedUsersModal(
                              farmId: farmId,
                              store: FarmUpdatePageStore(),
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        path: RouteName.genericCreate,
                        pageBuilder: (_, __) => DialogPage(
                          builder: (_) =>
                              FarmUpdatePage(store: FarmUpdatePageStore()),
                        ),
                      ),
                    ],
                  ).toRoute(appStateNotifier)
                ],
              ),
              StatefulShellBranch(
                initialLocation: RouteName.settings,
                routes: <RouteBase>[
                  AppRoute(
                    name: RouteName.settings,
                    path: RouteName.settings,
                    builder: (_, __) => const SettingsPage(),
                    routes: [
                      AppRoute(
                        name: RouteName.animalBreeds,
                        path: RouteName.animalBreeds,
                        builder: (_, __) =>
                            AnimalsBreedsPage(store: AnimalsBreedsPageStore()),
                      ).toRoute(appStateNotifier),
                      AppRoute(
                        name: RouteName.animalDownReasons,
                        path: RouteName.animalDownReasons,
                        builder: (_, __) => AnimalsDownReasonsPage(
                            store: AnimalsDownReasonsPageStore()),
                      ).toRoute(appStateNotifier),
                      AppRoute(
                        name: RouteName.drugAdministrationTypes,
                        path: RouteName.drugAdministrationTypes,
                        builder: (_, __) => DrugAdministrationTypesPage(
                            store: DrugAdministrationTypesPageStore()),
                      ).toRoute(appStateNotifier),
                      AppRoute(
                        name: RouteName.vaccinesConfiguration,
                        path: RouteName.vaccinesConfiguration,
                        builder: (_, __) => VaccinesConfigurationPage(
                            store: VaccinesConfigurationPageStore()),
                      ).toRoute(appStateNotifier),
                    ],
                  ).toRoute(appStateNotifier),
                ],
              ),
              StatefulShellBranch(
                initialLocation: RouteName.areas,
                routes: <RouteBase>[
                  AppRoute(
                    name: RouteName.areas,
                    path: RouteName.areas,
                    builder: (_, __) => AreasPage(store: AreasPageStore()),
                    routes: [
                      // TODO: fix to use FFRoute
                      GoRoute(
                        path: RouteName.genericId,
                        pageBuilder: (_, state) {
                          final model = state.extra as Map<String, dynamic>?;
                          return DialogPage(
                            builder: (
                              _,
                            ) =>
                                AreaUpdatePage(
                              store: AreaUpdatePageStore(),
                              model: model?['model'],
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        path: RouteName.genericCreate,
                        pageBuilder: (_, __) => DialogPage(
                          builder: (_) =>
                              AreaUpdatePage(store: AreaUpdatePageStore()),
                        ),
                      ),
                    ],
                  ).toRoute(appStateNotifier),
                ],
              ),
              StatefulShellBranch(
                initialLocation: RouteName.lots,
                routes: <RouteBase>[
                  AppRoute(
                    name: RouteName.lots,
                    path: RouteName.lots,
                    builder: (_, __) => LotsPage(store: LotsPageStore()),
                    routes: [
                      GoRoute(
                        path: RouteName.genericVisualize,
                        pageBuilder: (_, state) {
                          final model = state.extra as Map<String, dynamic>?;
                          return DialogPage(
                            builder: (_) => LotVisualizePage(
                              store: LotVisualizePageStore(),
                              model: model?['model'],
                            ),
                          );
                        },
                      ),
                      // TODO: fix to use FFRoute
                      GoRoute(
                        path: RouteName.genericId,
                        pageBuilder: (_, state) {
                          final model = state.extra as Map<String, dynamic>?;
                          return DialogPage(
                            builder: (_) => LotUpdatePage(
                              store: LotUpdatePageStore(),
                              model: model?['model'],
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        path: RouteName.genericCreate,
                        pageBuilder: (_, __) => DialogPage(
                          builder: (_) =>
                              LotUpdatePage(store: LotUpdatePageStore()),
                        ),
                      ),
                    ],
                  ).toRoute(appStateNotifier),
                ],
              ),
            ],
          ),
        ],
        observers: _getObservers(),
      );
}

//TODO: Procurar um lugar melhor para colocar esses helpers que nem deviam existir, poderia ter algum provider guardando o estado
Future<VaccineModel?> _fetchVaccineByName(String vaccineName) async {
  try {
    List<String> partsCapitalized = [];
    if (vaccineName.contains('-')) {
      final partsName = vaccineName.split('-');

      for (var element in partsName) {
        partsCapitalized.add(element.capitalize());
      }
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('farms')
        .doc(AppManager.instance.currentUser.currentFarm?.id)
        .collection('vaccines')
        .where('name',
            isEqualTo: !vaccineName.contains('-')
                ? vaccineName.capitalize()
                : partsCapitalized.join(' '))
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      return VaccineModel.fromJson(doc.data(), doc.reference);
    }
  } catch (e) {
    debugPrint('Erro ao buscar vacina: $e');
  }
  return null;
}

//TODO: Procurar um lugar melhor para colocar esses helpers que nem deviam existir, poderia ter algum provider guardando o estado
Future<AnimalModel?> _fetchAnimalById(String animalId) async {
  try {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('farms')
        .doc(AppManager.instance.currentUser.currentFarm?.id)
        .collection('animals')
        .doc(animalId)
        .get();

    if (docSnapshot.exists) {
      return AnimalModel.getDocumentFromData(docSnapshot.data()!);
    }
  } catch (e) {
    debugPrint('Erro ao buscar animal: $e');
  }
  return null;
}
