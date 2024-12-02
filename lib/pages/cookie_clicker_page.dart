import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cookieclicker/model/user.dart';
import 'package:cookieclicker/database/user/user_repository.dart';

class CookieClickerPage extends StatefulWidget {
  final User user;

  const CookieClickerPage({super.key, required this.user});

  @override
  _CookieClickerPageState createState() => _CookieClickerPageState();
}

class _CookieClickerPageState extends State<CookieClickerPage> {
  late User _currentUser;
  late Timer _grandmaTimer;
  final UserRepository _userRepository = GetIt.I<UserRepository>();

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;

    // Start a timer for grandma cookie generation
    _grandmaTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        _currentUser.nombreCookies += _currentUser.nombreGrandMeres;
        _saveUserData();
      });
    });
  }

  @override
  void dispose() {
    _grandmaTimer.cancel();
    super.dispose();
  }

  // Save user progress to the database
  Future<void> _saveUserData() async {
    await _userRepository.updateUser(_currentUser);
  }

  // Handle logout
  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login'); // Go back to LoginPage
  }

  // Handle clicking for cookies
  void _clickCookie() {
  setState(() {
    _currentUser.nombreCookies++;
    _currentUser.nombreClics++;
    _currentUser.cookiesGeneresDepuisCreation++;
    _currentUser.validate();  // Validate before saving
    _saveUserData();
  });
}

  // Handle buying a grandma
  void _buyGrandma() {
    const grandmaCost = 100; // Set the cost of a grandma
    if (_currentUser.nombreCookies >= grandmaCost) {
      setState(() {
        _currentUser.nombreCookies -= grandmaCost;
        _currentUser.nombreGrandMeres++;
        _saveUserData();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough cookies to buy a Grandma!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cookie Clicker"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context), // Logout button
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: _clickCookie,
                child: Image.asset(
                  'assets/cookie.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ),
          Text(
            "Cookies: ${_currentUser.nombreCookies}",
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          Text(
            "Grandmas: ${_currentUser.nombreGrandMeres}",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _buyGrandma,
            child: const Text("Buy Grandma (100 Cookies)"),
          ),
        ],
      ),
    );
  }
}