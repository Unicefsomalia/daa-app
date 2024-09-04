import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var primary = const Color(0xFF00AEEE);
var primaryMaterial = MaterialStateProperty.all<Color>(const Color(0xFF00AEEE));

final appLightTheme = ThemeData.light().copyWith(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: primary,
  textTheme: GoogleFonts.promptTextTheme(
    ThemeData.light().textTheme.copyWith(
          // For App Bars
          titleLarge: GoogleFonts.getFont(
            'Prompt',
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          // For Main Texts
          titleMedium: GoogleFonts.getFont(
            'Prompt',
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // For Secondary Texts
          titleSmall: GoogleFonts.getFont(
            'Prompt',
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // For tertiary texts (e.g. button text in app bar subtitle)
          labelMedium: GoogleFonts.getFont(
            'Prompt',
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // For small texts
          labelSmall: GoogleFonts.getFont(
            'Prompt',
            textStyle: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
              color: Colors.black,
            ),
          ),
          // For Display Messages
          bodySmall: GoogleFonts.getFont(
            'Prompt',
            textStyle: const TextStyle(
              color: Color.fromARGB(172, 147, 147, 147),
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
          ),
          // For light theme (a title medium in white)
          bodyMedium: GoogleFonts.getFont(
            'Prompt',
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
              fontSize: 14,
            ),
          ),
          // For light theme only (a title large in black)
          bodyLarge: GoogleFonts.getFont(
            'Prompt',
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      minimumSize: const Size(310, 45),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Colors.black,
    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    filled: false,
    hintStyle: TextStyle(color: Colors.black),
    labelStyle: TextStyle(
      fontSize: 13,
      color: Colors.black,
    ),
    border: OutlineInputBorder(),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    floatingLabelAlignment: FloatingLabelAlignment.start,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.white,
    unselectedItemColor: Color.fromARGB(255, 237, 237, 237),
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
      color: Color.fromARGB(255, 237, 237, 237),
      size: 20,
    ),
  ),
  chipTheme: const ChipThemeData(
    backgroundColor: Colors.white,
    labelStyle: TextStyle(
      color: Colors.black,
      fontSize: 9,
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    iconTheme: IconThemeData(
      size: 22,
      color: Colors.white,
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all<Color>(
      const Color(0xFFFFFFFF),
    ),
    fillColor: MaterialStateProperty.all<Color>(
      const Color(0xFFFF4747),
    ),
    shape: const CircleBorder(),
  ),
);
