import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nasari_test/app/screens/home_screen.dart';
import 'package:nasari_test/app/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  var authBox = await Hive.openBox("auth");
  final isAuthenticated = authBox.get("token") != null;
  authBox.close();

  runApp(MyApp(
    isAuthenticated: isAuthenticated,
  ));
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;

  const MyApp({super.key, required this.isAuthenticated});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
        initialLocation: isAuthenticated ? "/home" : "/login",
        routes: <RouteBase>[
          GoRoute(
              name: "home",
              path: "/home",
              builder: (context, state) => const HomeScreen()),
          GoRoute(
              name: "login",
              path: "/login",
              builder: (context, state) => const LoginScreen())
        ],
        debugLogDiagnostics: true);

    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
