import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/pronunciation_result.dart';
import '../config/api_config.dart';

class ApiService {
  static Future<Map<String, dynamic>> generateKaraoke(String youtubeUrl) async {
    final base = ApiConfig.BASE_URL;
    final uri = Uri.parse("$base/generate_karaoke");

    final request = http.MultipartRequest("POST", uri)
      ..fields["url"] = youtubeUrl;

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(body);
    } else {
      throw Exception(
        "Erro ao gerar karaokê (Status: ${response.statusCode}): $body",
      );
    }
  }

  static Future<PronunciationResult> sendAudio({
    required File audio,
    required String originalLyrics,
  }) async {
    final base = ApiConfig.BASE_URL;
    final uri = Uri.parse("$base/evaluate");

    final request =
        http.MultipartRequest("POST", uri)
          ..fields["original_text"] = originalLyrics
          ..files.add(await http.MultipartFile.fromPath("audio", audio.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return PronunciationResult.fromJson(jsonDecode(body));
    } else {
      throw Exception(
        "Erro ao enviar áudio (Status: ${response.statusCode}): $body",
      );
    }
  }
}
