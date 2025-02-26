import 'package:farmbov/src/common/helpers/context_extensions.dart';
import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/domain/models/authenticated_user.dart';
import 'package:farmbov/src/domain/models/firestore/user_model.dart';
import 'package:farmbov/src/domain/models/global_farm_model.dart';
import 'package:farmbov/src/domain/usecases/user_usecase.dart';
import 'package:farmbov/src/presenter/shared/pages/global_navigation/farm_local_storage_service.dart';
import 'package:farmbov/src/presenter/shared/repositories/i_local_storage_repository.dart';
import 'package:farmbov/src/presenter/shared/repositories/shared_preferences_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/farm_repository.dart';
import '../themes/theme_constants.dart';

FarmRepository farmRepository = FarmRepositoryImpl();

class AppManager extends ChangeNotifier {
  static final AppManager _instance = AppManager._internal();
  static AppManager get instance => _instance;

  AppManager._internal() {
    initLocalStorage();

    //Notificar partes do app quando fazenda for alterada.
    currentFarmNotifier =
        ValueNotifier<GlobalFarmModel?>(currentUser.currentFarm);
  }

  AuthenticatedUser? initialUser;
  AuthenticatedUser currentUser = AuthenticatedUser(null);

  late ValueNotifier<GlobalFarmModel?> currentFarmNotifier;

  bool loadingCurrentFarm = true;

  String? _redirectLocation;
  late SharedPreferences prefs;

  static bool isDEV = true;
  static bool isUAT = false;
  static bool isPROD = false;

  static late FirebaseAnalytics analytics;
  static late FirebaseAnalyticsObserver observer;

  static void configureAnalytics() {
    analytics = FirebaseAnalytics.instance;
    observer = FirebaseAnalyticsObserver(analytics: analytics);
  }

  //Settings up LocalStorage
  late final ILocalStorageRepository _localStorageRepository;
  late final FarmLocalStorageService _farmLocalStorageService;

  void initLocalStorage() async {
    _localStorageRepository = SharedPreferencesRepository();
    _farmLocalStorageService = FarmLocalStorageService(_localStorageRepository);

    prefs = await SharedPreferences.getInstance();
    notifyListeners();
  }

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  // TODO: fix global loading
  bool _loading = false;
  bool get loading => _loading;
  bool get loggedIn => currentUser.loggedIn;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void updateUser(AuthenticatedUser? newUser) async {
    if (newUser == null) return;

    initialUser ??= newUser;
    currentUser = newUser;

    // Refresh the app on auth change unless explicitly marked otherwise.
    if (notifyOnAuthChange) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void updateFarm(
    BuildContext context,
    GlobalFarmModel? farm, {
    bool fromInsert = false,
  }) async {
    if (farm == null || farm.id == currentUser.currentFarm?.id) return;
    bool? confirmed = true;
    if (fromInsert == false) {
      confirmed = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Confirmação',
                  style: TextStyle(color: AppColors.primaryGreen),
                ),
                content: const Text('Desejar alternar a fazenda atual?'),
                actions: [
                  TextButton(
                    onPressed: () => GoRouter.of(context).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => GoRouter.of(context).pop(true),
                    child: const Text('Confirmar'),
                  ),
                ],
              );
            },
          ) ??
          false;
    }

    if (confirmed) {
      _loading = true;
      notifyListeners();
      currentUser.currentFarm = farm;
      //TODO: Talvez há uma forma melhor de criar essa notificação, mas no momento terá que ser assim :/
      currentFarmNotifier.value = farm;
      _farmLocalStorageService.saveFarm(farm);
      _loading = false;
      notifyListeners();
    }

    notifyListeners();
  }

  void clearUser() {
    initialUser = null;
    currentUser = AuthenticatedUser(null);
    //TODO: Talvez há uma forma melhor de criar essa notificação, mas no momento terá que ser assim :/
    currentFarmNotifier.value = null;
    _farmLocalStorageService.deleteFarm();
    notifyListeners();
  }

  Future<GlobalFarmModel?> loadFarm(String userId) async {
    GlobalFarmModel? currentFarm = await _farmLocalStorageService.readFarm();

    if (currentFarm != null) {
      currentUser.currentFarm = currentFarm;
      notifyListeners();
      return currentFarm;
    } else {
      try {
        final farms = await farmRepository.getSharedFarmsToUser(userId);
        GlobalFarmModel currentFarm;
        if (farms.isNotEmpty) {
          currentFarm = GlobalFarmModel(
            id: farms.first.reference.id,
            name: farms.first.name,
            userId: farms.first.ownerId,
          );
          await _farmLocalStorageService.saveFarm(currentFarm);
          notifyListeners();
          return currentFarm;
        }
      } catch (e) {
        Logger().e(e);
        return null;
      }
    }
    return null;
  }

  Future<UserModel?> loadUserDetails(String userId) async {
    return await UserUseCase().findUserByFirebaseUserId(userId);
  }

  Stream<AuthenticatedUser?> firebaseUserStream() => FirebaseAuth.instance
          .authStateChanges()
          .debounce((user) => user == null && !loggedIn
              ? TimerStream(true, const Duration(seconds: 1))
              : Stream.value(user))
          .asyncMap<AuthenticatedUser?>(
        (user) async {
          if (user == null) {
            NavigationService.rootNavigatorKey.currentContext?.goRoot();
            return null;
          }

          GlobalFarmModel? globalFarm;
          UserModel? userModel;

          if (user.uid.isNotEmpty) {
            await Future.wait([
              loadFarm(user.uid).then((value) => globalFarm = value),
              loadUserDetails(user.uid).then((value) => userModel = value),
            ]);
          }

          loadingCurrentFarm = false;

          currentUser.currentFarm = globalFarm;
          //TODO: Talvez há uma forma melhor de criar essa notificação, mas no momento terá que ser assim :/
          currentFarmNotifier.value = globalFarm;
          notifyListeners();

          return AuthenticatedUser(
            user,
            currentFarm: globalFarm,
            userDetails: userModel,
          );
        },
      );
}
