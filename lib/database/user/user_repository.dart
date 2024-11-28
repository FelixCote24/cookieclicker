
import 'package:cookieclicker/model/user.dart';

abstract class UserRepository {
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(User user);
  Future<User> getUser(String id);
  Future<List<User>> getUsers();
}