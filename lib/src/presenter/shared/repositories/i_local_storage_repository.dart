//TODO: Mover para local mais apropriado, após MVP

abstract class ILocalStorageRepository {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
}
