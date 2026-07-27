import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette
  static const Color bgDark = Color(0xFF14110F);
  static const Color cardDark = Color(0xFF1E1A17);
  static const Color surfaceDark = Color(0xFF28231F);
  static const Color primaryGold = Color(0xFFD4A373);
  static const Color primaryGoldDark = Color(0xFFBC8A5F);
  static const Color accentBronze = Color(0xFFE6A15C);
  static const Color textLight = Color(0xFFF4F1DE);
  static const Color textMuted = Color(0xFFA8A29E);
  static const Color borderDark = Color(0xFF38322D);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: primaryGold,
      colorScheme: const ColorScheme.dark(
        primary: primaryGold,
        secondary: accentBronze,
        surface: cardDark,
        onPrimary: Colors.black,
        onSurface: textLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: primaryGold,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
        iconTheme: IconThemeData(color: primaryGold),
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 4,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: borderDark, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGold,
          foregroundColor: Colors.black,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        hintStyle: const TextStyle(color: textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryGold, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceDark,
        selectedColor: primaryGold,
        disabledColor: surfaceDark,
        labelStyle: const TextStyle(color: textLight),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
      ),
    );
  }
}
