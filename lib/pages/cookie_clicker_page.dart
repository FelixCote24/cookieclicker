import 'package:flutter/material.dart';

class CookieClickerPage extends StatefulWidget {
  const CookieClickerPage({super.key});

  @override
  _CookieClickerPageState createState() => _CookieClickerPageState();
}

class _CookieClickerPageState extends State<CookieClickerPage> {
  int cookies = 0;

  void _incrementCookies() {
    setState(() {
      cookies++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cookie Clicker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$cookies Cookies',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCookies,
              child: const Text('Click Me!'),
            ),
          ],
        ),
      ),
    );
  }
}