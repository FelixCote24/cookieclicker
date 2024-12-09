import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cookieclicker/model/user.dart';
import 'package:cookieclicker/database/user/user_repository.dart';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:cookieclicker/pages/statictic_page.dart';

class CookieClickerPage extends StatefulWidget {
  final User user;

  const CookieClickerPage({super.key, required this.user});

  @override
  _CookieClickerPageState createState() => _CookieClickerPageState();
}

class _CookieClickerPageState extends State<CookieClickerPage>
    with SingleTickerProviderStateMixin {
  late User _currentUser;
  late Timer _saveTimer;
  Timer? _grandmaTimer;
  Timer? _usineTimer;
  final UserRepository _userRepository = GetIt.I<UserRepository>();
  late String _backgroundImage;
  late AnimationController _cookieController;

  static const double shakeThreshold = 5.0;
  AccelerometerEvent? _previousEvent;
  bool _shakeCooldown = false;

  @override
  void initState() {
    super.initState();
    _initializeShakeDetection();
    _currentUser = widget.user;

    _updateBackgroundAndStatus();

    // Start a timer for periodic saving
    _saveTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        _updateBackgroundAndStatus();
        _saveUserData();
      });
    });

    // Start the grandma timer
    _startGrandmaTimer();
    _startUsineTimer();

    _cookieController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _grandmaTimer?.cancel();
    _saveTimer.cancel();
    _usineTimer?.cancel();
    _cookieController.dispose();
    super.dispose();
  }

  void _initializeShakeDetection() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (_previousEvent != null) {
        final deltaX = event.x - _previousEvent!.x;
        final deltaY = event.y - _previousEvent!.y;
        final deltaZ = event.z - _previousEvent!.z;
        final magnitude =
            sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ);

        if (magnitude > shakeThreshold && !_shakeCooldown) {
          _shakeCooldown = true;
          _clickCookie(); // Simulate a click
          Future.delayed(const Duration(seconds: 1), () {
            _shakeCooldown = false;
          });
        }
      }
      _previousEvent = event;
    });
  }

  // Update background image and cookieMaster status
  void _updateBackgroundAndStatus() {
    if (_currentUser.cookiesGeneresDepuisCreation >= 10000) {
      _currentUser.cookieMaster = true;
    }
    _backgroundImage = _currentUser.cookieMaster
        ? 'assets/background2.png'
        : 'assets/background.png';
  }

  void _startGrandmaTimer() {
    _grandmaTimer?.cancel();
    if (_currentUser.nombreGrandMeres <= 0) {
      return;
    }
    final milliseconds = _currentUser.nombreGrandMeres == 0
        ? double.infinity.toInt()
        : 10000 ~/ _currentUser.nombreGrandMeres;

    _grandmaTimer =
        Timer.periodic(Duration(milliseconds: milliseconds), (timer) {
      setState(() {
        _currentUser.nombreCookies++;
        _currentUser.cookiesGeneresDepuisCreation++;
        _updateBackgroundAndStatus();
      });
    });
  }

  void _startUsineTimer() {
    _usineTimer?.cancel();
    if (_currentUser.nombreUsines <= 0) {
      return;
    }
    final milliseconds = _currentUser.nombreUsines == 0
        ? double.infinity.toInt()
        : 1000 ~/ _currentUser.nombreUsines;

    _usineTimer = Timer.periodic(Duration(milliseconds: milliseconds), (timer) {
      setState(() {
        _currentUser.nombreCookies++;
        _currentUser.cookiesGeneresDepuisCreation++;
        _updateBackgroundAndStatus();
      });
    });
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
      _updateBackgroundAndStatus(); // Update background if needed
    });
    _cookieController.forward().then((_) => _cookieController.reverse());
  }

  // Handle buying a grandma
  void _buyGrandma() {
    final grandmaCost =
        (100 * pow(1.01, _currentUser.nombreGrandMeres)).toInt();
    if (_currentUser.nombreCookies >= grandmaCost) {
      setState(() {
        _currentUser.nombreCookies -= grandmaCost;
        _currentUser.nombreGrandMeres++;
        _startGrandmaTimer(); // Restart grandma timer with updated interval
      });
    }
  }

  void _buyUsine() {
    final usineCost = (1000 * pow(1.01, _currentUser.nombreUsines)).toInt();
    if (_currentUser.nombreCookies >= usineCost) {
      setState(() {
        _currentUser.nombreCookies -= usineCost;
        _currentUser.nombreUsines++;
        _startUsineTimer();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final grandmaCost =
        (100 * pow(1.01, _currentUser.nombreGrandMeres)).toInt();
    final usineCost = (1000 * pow(1.01, _currentUser.nombreUsines)).toInt();

    return Scaffold(
        body: PageView(children: [
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 120), // Add space at the top
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Cookies: ${_currentUser.nombreCookies}",
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 4,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: _clickCookie,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 1.0, end: 1.2)
                            .animate(_cookieController),
                        child: Image.asset(
                          'assets/cookie.png',
                          width: 300,
                          height: 300,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    if (_currentUser.cookieMaster)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Grandmas: ${_currentUser.nombreGrandMeres}",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Usines: ${_currentUser.nombreUsines}",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      Center(
                        child: Text(
                          "Grandmas: ${_currentUser.nombreGrandMeres}",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 4,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (_currentUser.cookieMaster)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Buy Grandma Button
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ElevatedButton(
                                onPressed: _buyGrandma,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 24),
                                  side: const BorderSide(
                                      color: Colors.black, width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Buy Grandma ($grandmaCost Cookies)",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Buy Usine Button
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2),
                                color:
                                    Colors.amber[300], // Golden color for Usine
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ElevatedButton(
                                onPressed: _buyUsine,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber[300],
                                  foregroundColor: Colors.black,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 24),
                                  side: const BorderSide(
                                      color: Colors.black, width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Buy Usine ($usineCost Cookies)",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton(
                          onPressed: _buyGrandma,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 1, // Reduced horizontal padding
                            ),
                            side:
                                const BorderSide(color: Colors.black, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Buy Grandma ($grandmaCost Cookies)",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 30,
              right: 20,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shadowColor: Colors.transparent,
                    padding:
                        const EdgeInsets.all(16), // Makes the button bulkier
                    side: const BorderSide(color: Colors.black, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.logout, size: 24),
                      SizedBox(width: 8),
                      Text(
                        "Logout",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      StatisticsPage(_currentUser),
    ]));
  }
}
