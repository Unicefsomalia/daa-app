import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../navigation/navigation.dart';
import '../models.dart';

const primary = Color(0xFF00AEEE);

var sisitechTheme = CustomTheme(
  theme: FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: primary,
      primaryContainer: Color(0xff95f0ff),
      secondary: Color(0xffd4ab13),
      secondaryContainer: Color(0xfffff8f0),
      tertiary: Color(0xff018786),
      tertiaryContainer: Color(0xff95f0ff),
      appBarColor: Color(0xfffff8f0),
      error: Color(0xffb00020),
    ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 15,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      defaultRadius: 17.0,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    // To use the playground font, add GoogleFonts package and uncomment
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  ),
  darkTheme: FlexThemeData.dark(
    colors: const FlexSchemeColor(
      primary: primary,
      primaryContainer: Color(0xff013945),
      secondary: Color(0xffd4ab13),
      secondaryContainer: Color(0xff6c5809),
      tertiary: Color(0xff86d2e1),
      tertiaryContainer: Color(0xff48727a),
      appBarColor: Color(0xff6c5809),
      error: Color(0xffcf6679),
    ),
    surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
    blendLevel: 18,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 13,
      defaultRadius: 17.0,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    // To use the Playground font, add GoogleFonts package and uncomment
    // fontFamily: GoogleFonts.notoSans().fontFamily,
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
  ),
);
