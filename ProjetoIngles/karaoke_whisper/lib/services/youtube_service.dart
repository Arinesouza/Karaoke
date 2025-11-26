import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/pronunciation_result.dart';

class YoutubeService {
  static const String baseUrl = "http://10.0.2.2:8000";
  static Future<Map<String, dynamic>> generateKaraoke(String url) async {
    final uri = Uri.parse("$baseUrl/generate_karaoke");
    final response = await http.post(uri, body: {"url": url});

    if (response.statusCode != 200) {
      throw Exception("Erro ao gerar karaoke: ${response.body}");
    }

    return jsonDecode(response.body);
  }

  static Future<PronunciationResult> evaluatePronunciation(
    File audioFile,
    String originalText,
  ) async {
    final uri = Uri.parse("$baseUrl/evaluate");

    final request = http.MultipartRequest("POST", uri);
    request.fields["original_text"] = originalText;
    request.files.add(
      await http.MultipartFile.fromPath("audio", audioFile.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception("Erro na avaliação: ${response.body}");
    }

    final data = jsonDecode(response.body);
    return PronunciationResult(
      score: data["score"],
      transcript: data["transcript"],
      feedback: data["feedback"],
    );
  }
}
