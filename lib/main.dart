import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'models/category.dart';
import 'models/note.dart';
import 'models/sync_queue.dart';
import 'screens/add_category.dart';
import 'screens/add_note.dart';
import 'screens/category_notes.dart';
import 'screens/choose_category.dart';
import 'screens/choose_color.dart';
import 'screens/email_sent.dart';
import 'screens/forgot_password.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/sync_queue.dart';
import 'theme/theme_constants.dart';
import 'theme/theme_manager.dart';
import 'widgets/my_custom_scroll_behavior.dart';

void main() {
  if (Platform.isWindows) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

final themeManager = ThemeManager();

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: lightTheme.scaffoldBackgroundColor,
      statusBarIconBrightness: lightTheme.brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
      systemNavigationBarColor: lightTheme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness:
          lightTheme.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CategoryProvider()),
        ChangeNotifierProvider.value(value: NoteProvider()),
        ChangeNotifierProvider.value(value: SyncQueueProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: navigatorKey,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeManager.themeMode,
        initialRoute: HomeScreen.routeName,
        scrollBehavior: Platform.isWindows ? MyCustomScrollBehavior() : null,
        routes: {
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          CategoryNote.routeName: (ctx) => CategoryNote(),
          AddNoteScreen.routeName: (ctx) => AddNoteScreen(),
          ChooseCategoryScreen.routeName: (ctx) => const ChooseCategoryScreen(),
          AddCategoryScreen.routeName: (ctx) => AddCategoryScreen(),
          ChooseColorScreen.routeName: (ctx) => const ChooseColorScreen(),
          SignUpScreen.routeName: (ctx) => const SignUpScreen(),
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          ForgotPasswordScreen.routeName: (ctx) => const ForgotPasswordScreen(),
          EmailSentScreen.routeName: (ctx) => const EmailSentScreen(),
          SyncQueueScreen.routeName: (ctx) => SyncQueueScreen(),
        },
      ),
    );
  }
}
