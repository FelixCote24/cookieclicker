import 'package:flutter/material.dart';
import 'package:cookieclicker/auth/auth_service.dart';
import 'package:cookieclicker/database/user/sembast_user_repository.dart';
import 'package:cookieclicker/auth/login_page.dart';

void main() {
  // Initialize the user repository and AuthService
  final userRepository = SembastUserRepository();
  final authService = AuthService(userRepository);

  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cookie Clicker',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: LoginPage(authService: authService), // Pass AuthService to LoginPage
    );
  }
}