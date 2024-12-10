import 'package:cookieclicker/controller/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:cookieclicker/database/user/sembast_user_repository.dart';
import 'package:cookieclicker/model/user.dart';
import 'package:sembast/sembast.dart';

void main() {
  late AuthService authService;
  late SembastUserRepository userRepository;
  late GetIt getIt;

  setUp(() async {
    // Initialize GetIt
    getIt = GetIt.instance;

    // Set up in-memory database for testing
    final db = await databaseFactoryMemory.openDatabase('test.db');
    getIt.registerSingleton<Database>(db);

    // Initialize the repository with the in-memory database
    userRepository = SembastUserRepository();
    authService = AuthService(userRepository);
  });

  tearDown(() async {
    // Reset GetIt after each test
    await getIt.reset();
  });

  group('AuthService', () {
    test('register should return true when user is successfully created', () async {
      final username = 'newUser';
      final password = 'password123';
      
      // Calling the register method
      final result = await authService.register(username, password);
      
      // Verifying that the result is true (user created successfully).
      expect(result, true);

      // Verifying that the user was added by checking if the user exists in the repository.
      final users = await userRepository.getUsers();
      expect(users.any((user) => user.nom == username), true);
    });

    test('register should return false when username is already taken', () async {
      final username = 'existingUser';
      final password = 'password123';
      
      // Registering the user first
      await authService.register(username, password);
      
      // Calling the register method with an already existing username
      final result = await authService.register(username, password);
      
      // Verifying that the result is false (user already exists).
      expect(result, false);
    });

    test('login should return a user when credentials are correct', () async {
      final username = 'existingUser';
      final password = 'password123';

      // Registering the user
      await authService.register(username, password);

      // Calling the login method
      final user = await authService.login(username, password);

      // Verifying that the returned user is the one we expect.
      expect(user, isNotNull);
      expect(user?.nom, username);
    });

    test('login should return null when password is incorrect', () async {
      final username = 'existingUser';
      final password = 'password123';
      final wrongPassword = 'wrongPassword';

      // Registering the user
      await authService.register(username, password);

      // Calling the login method with the wrong password
      final user = await authService.login(username, wrongPassword);

      // Verifying that the returned user is null since the password is incorrect.
      expect(user, isNull);
    });

    test('login should return null when username does not exist', () async {
      final username = 'nonExistentUser';
      final password = 'password123';

      // Calling the login method with a non-existing username
      final user = await authService.login(username, password);

      // Verifying that the returned user is null (user does not exist).
      expect(user, isNull);
    });
  });
}
