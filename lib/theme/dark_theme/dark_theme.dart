import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var primary = const Color(0xFF00AEEE);
// var primary = Colors.teal;
var primaryMaterial = MaterialStateProperty.all<Color>(const Color(0xFF00AEEE));

final appDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: 'Prompt',
).copyWith(
  scaffoldBackgroundColor: Colors.black,
  primaryColor: primary,
  brightness: Brightness.dark,
  textTheme: GoogleFonts.promptTextTheme(
    ThemeData.dark().textTheme.copyWith(
          // For App Bars
          titleLarge: GoogleFonts.getFont(
            'Prompt',
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          // For Main Texts
          titleMedium: GoogleFonts.getFont(
            'Prompt',
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          // For Secondary Texts
          titleSmall: GoogleFonts.getFont(
            'Prompt',
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          // For tertiary texts (e.g. button text in app bar subtitle)
          labelMedium: GoogleFonts.getFont(
            'Prompt',
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          // For small texts
          labelSmall: GoogleFonts.getFont(
            'Prompt',
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
          ),
          // For dark theme (a title medium in white)
          bodyMedium: GoogleFonts.getFont(
            'Prompt',
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
              fontSize: 14,
            ),
          ),
          // For Display Messages
          bodySmall: GoogleFonts.getFont(
            'Prompt',
            textStyle: const TextStyle(
              color: Color.fromARGB(172, 255, 255, 255),
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
          ),
          // For dark theme only (a title large in white)
          bodyLarge: GoogleFonts.getFont(
            'Prompt',
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: primary,
      disabledBackgroundColor: Colors.grey,
      foregroundColor: Colors.white,
      minimumSize: const Size(310, 45),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    filled: false,
    hintStyle: TextStyle(color: Colors.white),
    labelStyle: TextStyle(
      fontSize: 13,
      color: Colors.white,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    floatingLabelAlignment: FloatingLabelAlignment.start,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white60,
    showUnselectedLabels: true,
    selectedLabelStyle: TextStyle(
      fontSize: 12,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 11,
    ),
    selectedIconTheme: IconThemeData(
      color: Colors.white,
      size: 22,
    ),
    unselectedIconTheme: IconThemeData(
      color: Colors.white60,
      size: 20,
    ),
  ),
  chipTheme: const ChipThemeData(
    backgroundColor: Colors.black,
    labelStyle: TextStyle(
      color: Colors.white,
      fontSize: 9,
    ),
  ),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
      size: 22,
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all<Color>(
      const Color(0xFFFFFFFF),
    ),
    side: const BorderSide(color: Colors.red),
    fillColor: MaterialStateProperty.all<Color>(
      Colors.transparent,
    ),
    shape: const CircleBorder(),
  ),
);
