// domain/repositories/base_repository.dart
// base_repository.dart
mixin BaseRepository<T> {
  Future<T?> getById(String id);
  Future<List<T>> getAll();
  Future<void> create(T item);
  Future<void> update(T item);
  Future<void> delete(String id);
}