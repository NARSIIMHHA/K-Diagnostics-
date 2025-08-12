import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiService {
  final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  Future<String> explainReport(Map<String, dynamic> values) async {
    final prompt = _buildPrompt(values);
    final resp = await http.post(Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey'
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {'role': 'system', 'content': 'You are a helpful medical assistant that explains lab reports in simple terms and suggests non-prescription advice.'},
            {'role': 'user', 'content': prompt}
          ]
        }));

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('AI error ${resp.statusCode} - ${resp.body}');
    }
  }

  String _buildPrompt(Map<String, dynamic> values) {
    final buffer = StringBuffer();
    buffer.writeln('Explain the following blood test values:');
    values.forEach((k, v) => buffer.writeln('$k: $v'));
    buffer.writeln('Give a short explanation and suggest non-prescription advice and warning to see a doctor if serious.');
    return buffer.toString();
  }
}
