import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData getThemeData(ThemeMode mode) {
  return ThemeData(
    brightness: mode == ThemeMode.dark ? Brightness.dark : Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFFF5B7B1),
      brightness: mode == ThemeMode.dark ? Brightness.dark : Brightness.light,
    ),
    textTheme: GoogleFonts.nunitoTextTheme(
      ThemeData(brightness: mode == ThemeMode.dark ? Brightness.dark : Brightness.light).textTheme,
    ),
    useMaterial3: true,
  );
}