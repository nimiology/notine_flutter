import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final textTheme = TextTheme(
  displayLarge: GoogleFonts.lato(
    fontSize: 57,
    height: 64.0 / 57.0,
  ),
  displayMedium: GoogleFonts.lato(
    fontSize: 45,
    height: 52.0 / 45.0,
  ),
  displaySmall: GoogleFonts.lato(
    fontSize: 36,
    height: 44.0 / 36.0,
  ),
  headlineLarge: GoogleFonts.lato(fontSize: 32, height: 40.0 / 32.0),
  headlineMedium: GoogleFonts.lato(fontSize: 28, height: 36.0 / 28.0),
  headlineSmall: GoogleFonts.lato(fontSize: 24, height: 32.0 / 24.0),
  titleLarge: GoogleFonts.lato(
    fontSize: 22,
    height: 28.0 / 22.0,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: GoogleFonts.lato(
      fontSize: 16,
      height: 24.0 / 16.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.15),
  titleSmall: GoogleFonts.lato(
      fontSize: 14,
      height: 20.0 / 14.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.1),
  labelLarge: GoogleFonts.lato(
      fontSize: 14,
      height: 20.0 / 14.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.1),
  labelMedium: GoogleFonts.lato(
      fontSize: 12,
      height: 16.0 / 12.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5),
  labelSmall: GoogleFonts.lato(
      fontSize: 11,
      height: 16.0 / 11.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5),
  bodyLarge:
  GoogleFonts.lato(fontSize: 16, height: 24.0 / 16.0, letterSpacing: 0.15),
  bodyMedium:
  GoogleFonts.lato(fontSize: 14, height: 20.0 / 14.0, letterSpacing: 0.25),
  bodySmall:
  GoogleFonts.lato(fontSize: 12, height: 16.0 / 12.0, letterSpacing: 0.4),
);

final lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: textTheme.apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ),
    colorScheme: const ColorScheme.light(
      primary: Color.fromRGBO(10, 106, 255, 1),
      secondary: Color.fromRGBO(120, 120, 120, 1),
      error: Color.fromRGBO(211, 46, 46, 1),
      onError: Color.fromRGBO(211, 70, 70, 1.0),
      onSecondary: Color.fromRGBO(30, 30, 30, 1),
      onBackground: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        )),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromRGBO(10, 106, 255, 1),
    ));
final darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    scaffoldBackgroundColor: const Color.fromRGBO(0, 0, 0, 1),
    unselectedWidgetColor: Colors.white,
    colorScheme: const ColorScheme.dark(
      primary: Color.fromRGBO(10, 106, 255, 1),
      secondary: Color.fromRGBO(30, 30, 30, 1),
      error: Color.fromRGBO(211, 46, 46, 1),
      onError: Color.fromRGBO(211, 70, 70, 1.0),
      onSecondary: Color.fromRGBO(120, 120, 120, 1),
      onBackground: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        )),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromRGBO(10, 106, 255, 1),
    ));
