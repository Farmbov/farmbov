class UserNotFoundException implements Exception {
  @override
  String toString() => 'Exception: Usuário não encontrado';

  UserNotFoundException();
}
