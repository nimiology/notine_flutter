import 'package:flutter/material.dart';
import 'package:notine_flutter/screens/home.dart';

import 'theme/theme_manager.dart';

void main() {
  runApp(const MyApp());
}

final themeManager = ThemeManager();

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (ctx) => const HomeScreen()
      },
    );
  }
}
