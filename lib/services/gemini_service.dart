import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class GeminiService {
  final String apiKey;

  GeminiService() : apiKey = ApiConfig.geminiApiKey {
    print("✅ API Key loaded");
  }

  Future<String> sendMessage(String userMessage, String language) async {
    if (apiKey.isEmpty) {
      return "Please add your API key in Run Configuration";
    }

    // ✅ CORRECT URL - NO DUPLICATE "models"
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent?key=$apiKey',
    );

    print("📤 Calling Gemini API...");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": "You are a $language language tutor. "
                      "Respond only in $language to this beginner student: '$userMessage'. "
                      "Keep it simple and helpful."
                }
              ]
            }
          ]
        }),
      );

      print("📥 Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['candidates'][0]['content']['parts'][0]['text'];
      } else {
        // If 404/503, try different model
        return await _tryFallbackModel(userMessage, language);
      }
    } catch (e) {
      print("❌ Error: $e");
      return "Connection error. Check internet and API setup.";
    }
  }

  Future<String> _tryFallbackModel(String userMessage, String language) async {
    print("🔄 Trying fallback model...");

    // Try gemini-1.0-pro (more likely to work)
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.0-pro:generateContent?key=$apiKey',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": "Say 'Hello, how are you?' in $language"}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['candidates'][0]['content']['parts'][0]['text'];
      }
    } catch (e) {
      // Fall through
    }

    return "API temporarily unavailable. Please check billing setup in Google Cloud.";
  }
}