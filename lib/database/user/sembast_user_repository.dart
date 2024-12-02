import 'package:cookieclicker/database/user/user_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:cookieclicker/model/user.dart';
import 'package:sembast/sembast.dart';

class SembastUserRepository extends UserRepository {
  final Database _database = GetIt.I.get(); // Obtenir la base de données via GetIt
  final StoreRef<int, Map<String, dynamic>> _store =
      intMapStoreFactory.store("user_store"); // Stockage des utilisateurs

  @override
  Future<void> createUser(User user) async {
    final record = _store.record(user.id);
    await record.put(_database, user.toMap());
  }

  @override
  Future<void> updateUser(User user) async {
    final record = _store.record(user.id);
    await record.update(_database, user.toMap());
  }

  @override
  Future<void> deleteUser(User user) async {
    await _store.record(user.id).delete(_database);
  }

  @override
  Future<User> getUser(String id) async {
  final snapshot = await _store.record(int.parse(id)).getSnapshot(_database);
  if (snapshot == null) {
    throw UserNotFoundException(id);
  }
  return User.fromMap({...snapshot.value, 'id': snapshot.key});
}

  @override
  Future<List<User>> getUsers() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map((snapshot) => User.fromMap({
              ...snapshot.value,
              'id': snapshot.key, // Include the key in the map explicitly
            }))
        .toList(growable: false);
  }
}

class UserNotFoundException implements Exception {
  final String userId;
  UserNotFoundException(this.userId);

  @override
  String toString() => 'User with ID $userId not found.';
}