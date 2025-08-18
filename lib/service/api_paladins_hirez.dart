// ignore_for_file: prefer_interpolation_to_compose_strings
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global/variables.dart';
import '../utils/functions.dart';

class ApiPaladinsHirez {
  static Future<List?> getCardChampion(
      {required String sessionId, required int champId}) async {
    var signature = UtilsFunctions.getSignature(path: 'getchampioncards');
    String timesTamp = UtilsFunctions.getTimestamp();
    var url = GlobalsVariables.urlPrefix +
        "getchampioncardsjson/${GlobalsVariables.devKey}"
            "/$signature/$sessionId/$timesTamp"
            "/$champId/${GlobalsVariables.lg}";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      print(
          'Request fail: getCardChampion() Message:${response.body} - CodStatus:${response.statusCode}');
      return null;
    }
  }

  static Future<String?> createSession() async {
    try {
      var signature = UtilsFunctions.getSignature(path: 'createsession');
      String timesTamp = UtilsFunctions.getTimestamp();
      var url = GlobalsVariables.urlPrefix +
          "createsessionJson/${GlobalsVariables.devKey}"
              "/$signature/$timesTamp";

      print('Trying to connect to: $url');
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print(
            'response createSession() - 200 -->> ${json.decode(response.body)}');
        if (json.decode(response.body)["ret_msg"] == "Approved") {
          return json.decode(response.body)["session_id"];
        } else {
          print(json.decode(response.body)["ret_msg"]);
          return null;
        }
      } else {
        print('Request fail'
            "MSG:${json.decode(response.body)["ret_msg"]}"
            " - CodStatus:${response.statusCode}");
        return null;
      }
    } catch (e) {
      print('Error in createSession: $e');
      return null;
    }
  }

  static Future<List?> getChampions({required String sessionId}) async {
    var signature = UtilsFunctions.getSignature(path: 'getchampions');
    String timesTamp = UtilsFunctions.getTimestamp();
    var url = GlobalsVariables.urlPrefix +
        "getchampionsjson/${GlobalsVariables.devKey}"
            "/$signature/$sessionId/$timesTamp"
            "/${GlobalsVariables.lg}";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('FRequest fail'
          "MSG:${json.decode(response.body)["ret_msg"]}"
          " - CodStatus:${response.statusCode}");
      return null;
    }
  }
}
