import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cookieclicker/database/user/sembast_user_repository.dart';
import 'package:cookieclicker/model/user.dart';

class AuthService {
  final SembastUserRepository _userRepository;

  AuthService(this._userRepository);

  Future<bool> register(String username, String password) async {
    try {
      // Check if a user with the same name exists
      final users = await _userRepository.getUsers();
      if (users.any((user) => user.nom == username)) {
        return false; // User already exists
      }

      // Hash the password before storing
      final passwordHash = _hashPassword(password);
      final newUser = User(nom: username, motDePasse: passwordHash);

      await _userRepository.createUser(newUser);
      return true;
    } catch (e) {
      print("Error registering user: $e");
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final users = await _userRepository.getUsers();
      User? user;
      try {
        user = users.firstWhere((user) => user.nom == username);
      } catch (e) {
        print("Error logging in: $e");
        return false;
      }

      // Compare hashed passwords
      return user.motDePasse == _hashPassword(password);
    } catch (e) {
      print("Error logging in: $e");
      return false;
    }
  }

  Future<void> signOut() async {
    // Implement sign-out logic if needed, such as clearing session data
    print("User signed out.");
  }

  String _hashPassword(String password) {
    // Use SHA-256 to hash the password
    return sha256.convert(utf8.encode(password)).toString();
  }
}