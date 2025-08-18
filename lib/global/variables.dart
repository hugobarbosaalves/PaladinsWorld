import 'package:flutter/material.dart';
import '../service/api_paladins_hirez.dart';

class GlobalsVariables {
  static var sessionId = '';
  static var api = ApiPaladinsHirez();

  // API Configuration
  static const String urlPrefix = 'https://api.paladins.com/paladinsapi.svc/';
  static const String devKey = '3712'; // Your dev key
  static const String authKey =
      'A95E29F9212A4155988E6DB70036A290'; // Your auth key
  static const String lg = '1'; // Language code (1 = English)

// 1 - English
// 2 - German
// 3 - French
// 5 - Chinese
// 7 - Spanish
// 9 - Spanish (Latin America)
// 10 - Portuguese
// 11 - Russian
// 12 - Polish
// 13 - Turkish

  // Modern Tech Colors - Neon Blue Theme
  static const Color primaryDark = Color(0xFF0A0E1A); // Deep space dark
  static const Color secondaryDark = Color(0xFF1A1F2E); // Card/container dark
  static const Color accentDark = Color(0xFF252B3A); // Elevated surfaces

  // Neon Colors
  static const Color neonBlue = Color(0xFF00D4FF); // Primary neon blue
  static const Color neonCyan = Color(0xFF00FFFF); // Bright cyan accent
  static const Color neonPurple = Color(0xFF8A2BE2); // Neon purple
  static const Color neonGreen = Color(0xFF00FF88); // Success/accent green

  // UI Colors
  static const Color textPrimary = Color(0xFFFFFFFF); // White text
  static const Color textSecondary = Color(0xFFB0BEC5); // Light grey text
  static const Color textAccent = Color(0xFF00D4FF); // Neon blue text

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A0E1A), Color(0xFF1A1F2E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A1F2E), Color(0xFF252B3A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Legacy Colors (for backward compatibility)
  static const Color backgroundColorLight = Color(0xFFF5F5F5);
  static const Color backgroundColorDark = primaryDark;
  static const Color purpleTitles = neonPurple;
  static const Color buttonBlueDark = neonBlue;
  static const Color textButtonGrey = textSecondary;
}
