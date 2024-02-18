import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notine_flutter/screens/home.dart';

import 'screens/add_category.dart';
import 'screens/add_note.dart';
import 'screens/category_notes.dart';
import 'screens/choose_category.dart';
import 'screens/choose_color.dart';
import 'theme/theme_constants.dart';
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
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      statusBarColor: lightTheme.scaffoldBackgroundColor,
      statusBarIconBrightness: lightTheme.brightness == Brightness.light ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: lightTheme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: lightTheme.brightness == Brightness.light ? Brightness.dark : Brightness.light,

    ));
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeManager.themeMode,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (ctx) => const HomeScreen(),
        CategoryNote.routeName: (ctx) => CategoryNote(),
        AddNoteScreen.routeName: (ctx) =>  AddNoteScreen(),
        ChooseCategoryScreen.routeName: (ctx) =>  const ChooseCategoryScreen(),
        AddCategoryScreen.routeName: (ctx) =>  AddCategoryScreen(),
        ChooseColorScreen.routeName: (ctx) =>  const ChooseColorScreen(),
      },
    );
  }
}
