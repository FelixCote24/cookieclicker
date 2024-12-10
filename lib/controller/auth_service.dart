import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cookieclicker/database/user/sembast_user_repository.dart';
import 'package:cookieclicker/model/user.dart';
import 'dart:math';

class AuthService {
  final SembastUserRepository _userRepository;

  AuthService(this._userRepository);

  /// Registers a new user with a hashed password.
  /// Returns `true` if registration is successful, `false` if the username is already taken.
  Future<bool> register(String username, String password) async {
    print("Registering user: $username");

    final users = await _userRepository.getUsers();
    print("Existing users: ${users.map((u) => u.nom).toList()}");

    // Check if username already exists
    if (users.any((user) => user.nom == username)) {
      print("Username already taken.");
      return false; // Return false if username is already taken
    }

    // Hash the password and create a new user with a random id
    final passwordHash = _hashPassword(password);

    final newUser = User(
      id: Random().nextInt(1000000), // Create a random ID
      nom: username,
      motDePasse: passwordHash,
    );

    await _userRepository
        .createUser(newUser); // Save the new user to the repository
    print("User registered successfully: ${newUser.nom}");
    return true;
  }

  /// Attempts to log in a user.
  /// Returns the `User` object if login is successful, or `null` if credentials are invalid.
  Future<User?> login(String username, String password) async {
    print("Attempting login for user: $username");

    final users = await _userRepository.getUsers();
    print("Retrieved users: ${users.map((u) => u.nom).toList()}");

    try {
      final user = users.firstWhere((user) => user.nom == username);
      final inputHash = _hashPassword(password);

      print("Input hash: $inputHash, Stored hash: ${user.motDePasse}");

      if (user.motDePasse == inputHash) {
        print("Login successful for user: $username");
        return user;
      }

      print("Password mismatch.");
      return null;
    } catch (e) {
      print("User not found or error occurred: $e");
      return null;
    }
  }

  /// Logs out the user. This is a placeholder for any sign-out logic (e.g., clearing session data).
  Future<void> signOut() async {
    print("User signed out.");
  }

  /// Hashes a password using SHA-256.
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
