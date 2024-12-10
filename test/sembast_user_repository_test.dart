import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:cookieclicker/database/user/sembast_user_repository.dart';
import 'package:cookieclicker/model/user.dart';
import 'package:sembast/sembast_memory.dart';

void main() {
  final getIt = GetIt.instance;

  setUp(() async {
    final db = await databaseFactoryMemory.openDatabase('test.db');
    getIt.registerSingleton(db);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('SembastUserRepository CRUD operations', () {
    late SembastUserRepository repository;

    setUp(() {
      repository = SembastUserRepository();
    });

    test('insertUser and getUser', () async {
      final user = User(
        nom: 'TestUser',
        motDePasse: 'password123',
        nombreCookies: 100,
        nombreClics: 50,
        nombreGrandMeres: 1,
        nombreUsines: 2,
        cookiesGeneresDepuisCreation: 1000,
        cookieMaster: true,
      );

      await repository.createUser(user);
      final fetchedUser = await repository.getUser(user.id.toString());

      expect(fetchedUser, isNotNull);
      expect(fetchedUser!.nom, 'TestUser');
      expect(fetchedUser.nombreCookies, 100);
      expect(fetchedUser.cookieMaster, isTrue);
    });

    test('updateUser', () async {
      final user = User(
        nom: 'TestUser',
        motDePasse: 'password123',
        nombreCookies: 100,
        nombreClics: 50,
        nombreGrandMeres: 1,
        nombreUsines: 2,
        cookiesGeneresDepuisCreation: 1000,
        cookieMaster: true,
      );

      await repository.createUser(user);

      final updatedUser = User(
        id: user.id,
        nom: 'UpdatedUser',
        motDePasse: 'newpassword123',
        nombreCookies: 200,
        nombreClics: 100,
        nombreGrandMeres: 2,
        nombreUsines: 3,
        cookiesGeneresDepuisCreation: 2000,
        cookieMaster: false,
      );

      await repository.updateUser(updatedUser);
      final fetchedUser = await repository.getUser(updatedUser.id.toString());

      expect(fetchedUser, isNotNull);
      expect(fetchedUser!.nom, 'UpdatedUser');
      expect(fetchedUser.nombreCookies, 200);
      expect(fetchedUser.cookieMaster, isFalse);
    });

    test('deleteUser', () async {
      final user = User(
        id: 100,
        nom: 'TestUser',
        motDePasse: 'password123',
        nombreCookies: 100,
        nombreClics: 50,
        nombreGrandMeres: 1,
        nombreUsines: 2,
        cookiesGeneresDepuisCreation: 1000,
        cookieMaster: true,
      );

      await repository.createUser(user);
      await repository.deleteUser(user);
      bool userExists = false;
      final users = await repository.getUsers();
      //find in the list the user with the same id
      for (var u in users) {
        if (u.id == user.id) {
          userExists = true;
          break;
        }
      }

      expect(userExists, false);
    });

    test('getAllUsers', () async {
      final user1 = User(
        id: 100,
        nom: 'TestUser1',
        motDePasse: 'password123',
        nombreCookies: 100,
        nombreClics: 50,
        nombreGrandMeres: 1,
        nombreUsines: 2,
        cookiesGeneresDepuisCreation: 1000,
        cookieMaster: true,
      );

      final user2 = User(
        id: 101,
        nom: 'TestUser2',
        motDePasse: 'password123',
        nombreCookies: 100,
        nombreClics: 50,
        nombreGrandMeres: 1,
        nombreUsines: 2,
        cookiesGeneresDepuisCreation: 1000,
        cookieMaster: true,
      );

      await repository.createUser(user1);
      await repository.createUser(user2);

      final allUsers = await repository.getUsers();
      expect(allUsers.length, 2);
    });

    test('insertUser with default values', () async {
      final user = User(nom: 'DefaultUser', motDePasse: 'default123');

      await repository.createUser(user);
      final fetchedUser = await repository.getUser(user.id.toString());

      expect(fetchedUser, isNotNull);
      expect(fetchedUser!.nombreCookies, 0);
      expect(fetchedUser.nombreGrandMeres, 0);
      expect(fetchedUser.cookieMaster, isFalse);
    });
  });
}
