import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      colorScheme: ColorScheme.fromSeed(seedColor:const Color(0xFFC62828)),
      appBarTheme: const AppBarTheme(
        // color: Colors.white,
        backgroundColor: Color(0xFFC62828),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: IconThemeData(
          color: Color(0xFFC62828),
          // color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFFC62828),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: Size(double.infinity, 40),
        ),
      ),
      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black,
        ),
        displayMedium: TextStyle(
          fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black,
        ),
        displaySmall: TextStyle(
          fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black,
        ),
        bodyLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black,
        ),
        bodyMedium: TextStyle(
          fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black87,
        ),
        titleMedium: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54,
        ),
        bodySmall: TextStyle(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey,
        ),
      ),
    );
  }
}