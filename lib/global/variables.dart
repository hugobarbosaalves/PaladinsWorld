import 'package:flutter/material.dart';
import '../service/api_paladins_hirez.dart';

class GlobalsVariables {
  static var sessionId = '';
  static var api = ApiPaladinsHirez();

  // API Configuration
  static const String urlPrefix = 'https://api.paladins.com/paladinsapi.svc/';
  static const String devKey = ''; // Your dev key
  static const String authKey = ''; // Your auth key
  static const String lg = '1'; // Language code (1 = English)

  // Colors
  static const Color backgroundColorLight = Color(0xFFF5F5F5);
  static const Color backgroundColorDark = Color(0xFF1A1A1A);
  static const Color purpleTitles = Color(0xFF6A0DAD);
  static const Color buttonBlueDark = Color(0xFF1E3A8A);
  static const Color textButtonGrey = Color(0xFF6B7280);
}
