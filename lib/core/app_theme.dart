import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color seedColor = Color(0xFF4318FF);
  static const Color darkBackground = Color(0xFF14112A);

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: seedColor,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: seedColor,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      scaffoldBackgroundColor: darkBackground,
    );
  }
}
