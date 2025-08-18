import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../global/variables.dart';
import '../service/api_paladins_hirez.dart';

class UtilsFunctions {
  static Future<void> createSession() async {
    try {
      var response = await ApiPaladinsHirez.createSession();
      if (response != null) {
        GlobalsVariables.sessionId = response;
        print('Session created successfully: $response');
      } else {
        print('Failed to create session - API returned null');
      }
    } catch (e) {
      print('Error creating session: $e');
      // Don't block the app if API is not available
      GlobalsVariables.sessionId = '';
    }
  }

  static Widget customLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static String getMD5(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }

  static String getSignature({required String path}) {
    var signature =
        '${GlobalsVariables.devKey}$path${GlobalsVariables.authKey}${DateFormat('yyyyMMddHHmmss').format(DateTime.now().toUtc())}';
    return UtilsFunctions.getMD5(signature);
  }

  static String getTimestamp() {
    return DateFormat('yyyyMMddHHmmss').format(DateTime.now().toUtc());
  }
}
