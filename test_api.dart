import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

void main() async {
  print('🔄 Testando API do Paladins...\n');

  // Credenciais da Hi-Rez
  const String devKey = '';
  const String authKey = '';
  const String baseUrl = 'https://api.paladins.com/paladinsapi.svc/';

  try {
    // 1. Teste de conectividade básica
    print('📡 1. Testando conectividade com ${baseUrl}...');

    // 2. Criar assinatura para createSession
    String timestamp =
        DateFormat('yyyyMMddHHmmss').format(DateTime.now().toUtc());
    String signatureString = '${devKey}createsession${authKey}${timestamp}';
    String signature = md5.convert(utf8.encode(signatureString)).toString();

    print('🔐 2. Gerando assinatura...');
    print('   Timestamp: $timestamp');
    print('   Signature: $signature');

    // 3. URL completa para createSession
    String createSessionUrl =
        '${baseUrl}createsessionJson/$devKey/$signature/$timestamp';
    print('🌐 3. URL da sessão: $createSessionUrl');

    // 4. Fazer requisição HTTP
    print('\n⏳ 4. Fazendo requisição...');

    var client = HttpClient();
    var request = await client.getUrl(Uri.parse(createSessionUrl));
    var response = await request.close();

    print('📊 Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      String responseBody = await response.transform(utf8.decoder).join();
      print('✅ Resposta recebida:');
      print('📄 Body: $responseBody');

      var jsonResponse = json.decode(responseBody);

      if (jsonResponse['ret_msg'] == 'Approved') {
        print('🎉 SUCESSO! Sessão criada: ${jsonResponse['session_id']}');

        // Teste adicional: buscar lista de campeões
        await testGetChampions(
            baseUrl, devKey, authKey, jsonResponse['session_id']);
      } else {
        print('❌ Erro na API: ${jsonResponse['ret_msg']}');
      }
    } else {
      print('❌ Erro HTTP: ${response.statusCode}');
    }

    client.close();
  } catch (e) {
    print('💥 Erro: $e');
  }
}

Future<void> testGetChampions(
    String baseUrl, String devKey, String authKey, String sessionId) async {
  try {
    print('\n🏆 5. Testando busca de campeões...');

    String timestamp =
        DateFormat('yyyyMMddHHmmss').format(DateTime.now().toUtc());
    String signatureString = '${devKey}getchampions${authKey}${timestamp}';
    String signature = md5.convert(utf8.encode(signatureString)).toString();

    String championsUrl =
        '${baseUrl}getchampionsjson/$devKey/$signature/$sessionId/$timestamp/1';
    print('🌐 URL campeões: $championsUrl');

    var client = HttpClient();
    var request = await client.getUrl(Uri.parse(championsUrl));
    var response = await request.close();

    print('📊 Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      String responseBody = await response.transform(utf8.decoder).join();
      var champions = json.decode(responseBody);

      if (champions is List && champions.isNotEmpty) {
        print('🎉 SUCESSO! ${champions.length} campeões encontrados!');
        print('👥 Primeiros 3 campeões:');
        for (int i = 0; i < 3 && i < champions.length; i++) {
          print(
              '   ${i + 1}. ${champions[i]['Name']} (${champions[i]['Role']})');
        }
      } else {
        print('⚠️  Lista de campeões vazia ou inválida');
      }
    } else {
      print('❌ Erro HTTP: ${response.statusCode}');
    }

    client.close();
  } catch (e) {
    print('💥 Erro ao buscar campeões: $e');
  }
}
