import 'package:farmbov/src/domain/models/firestore/user_model.dart';
import 'package:farmbov/src/domain/models/global_farm_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticatedUser {
  AuthenticatedUser(
    this.user, {
    this.userDetails,
    this.currentFarm,
  });

  /// Firebase User
  User? user;

  /// User Model from database
  UserModel? userDetails;

  bool get loggedIn => user != null;

  GlobalFarmModel? currentFarm;
}
