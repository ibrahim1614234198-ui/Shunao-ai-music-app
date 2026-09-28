import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  // এখানে পরে আমাদের আসল AI music backend/API URL বসাবো
  static const String baseUrl = 'https://example.com/api';

  Future<String> generateSong(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/generate'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'prompt': prompt,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data['message'] ??
            data['audio_url'] ??
            'Song generated successfully';
      }

      throw Exception(
        'Server error: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception('API error: $e');
    }
  }
}
