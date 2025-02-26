import 'package:farmbov/src/domain/exceptions/errors.dart';
import 'package:farmbov/src/domain/models/firestore/user_model.dart';
import 'package:farmbov/src/domain/repositories/user_repository.dart';

class UserUseCase {
  Future<UserModel?> findUserByFirebaseUserId(String userId) async {
    try {
      if (userId.isEmpty) throw UserNotFoundException();

      return await UserRepository().findUserById(userId);
    } catch (e) {
      return null;
    }
  }
}
