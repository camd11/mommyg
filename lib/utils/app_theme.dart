import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: Colors.pink[400]!,
        secondary: Colors.pinkAccent,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: GoogleFonts.nunito().fontFamily,
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.pink[700]),
        displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.pink[600]),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.pink[800]),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.pink[100],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.pink[700]),
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink[700]),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[400],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.pink[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.pink[400]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.pink[50],
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: Colors.pink[400]!,
        secondary: Colors.pinkAccent,
        surface: Colors.grey[900]!,
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      fontFamily: GoogleFonts.nunito().fontFamily,
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.pink[300]),
        displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.pink[200]),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.pink[100]),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[800],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.pink[300]),
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink[300]),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[400],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.pink[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.pink[400]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[800],
      ),
    );
  }
}