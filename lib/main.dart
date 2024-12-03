import 'package:cookieclicker/auth/auth_service.dart';
import 'package:cookieclicker/pages/login_page.dart';
import 'package:cookieclicker/database/user/sembast_user_repository.dart';
import 'package:cookieclicker/database/user/user_repository.dart';
import 'package:cookieclicker/model/user.dart';
import 'package:cookieclicker/pages/cookie_clicker_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final getIt = GetIt.instance;

  // Initialize Sembast Database
  final appDir = await getApplicationDocumentsDirectory();
  final dbPath = '${appDir.path}/cookieclicker.db';
  final database = await databaseFactoryIo.openDatabase(dbPath);

  // Register Database in GetIt
  getIt.registerSingleton<Database>(database);

  // Register SembastUserRepository both as UserRepository and SembastUserRepository
  getIt.registerSingleton<SembastUserRepository>(SembastUserRepository());
  getIt.registerSingleton<UserRepository>(getIt<SembastUserRepository>()); // Register SembastUserRepository as UserRepository

  // Register AuthService with SembastUserRepository
  getIt.registerSingleton<AuthService>(AuthService(getIt<SembastUserRepository>()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = GetIt.I<AuthService>(); // Retrieve AuthService from GetIt
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cookie Clicker',
      theme: ThemeData(primarySwatch: Colors.brown),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(authService: authService),
        '/cookie_clicker': (context) => CookieClickerPage(
              user: ModalRoute.of(context)!.settings.arguments as User,
            ),
      },
    );
  }
}