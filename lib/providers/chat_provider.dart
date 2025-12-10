import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../models/message.dart';

class ChatProvider extends ChangeNotifier {
  String selectedLanguage = "";
  bool isLoading = false;

  final List<Message> messages = [];
  final GeminiService _geminiService = GeminiService(); // <-- ADD THIS

  void setLanguage(String lang) {
    selectedLanguage = lang;
    notifyListeners();
  }

  void addUserMessage(String text) {
    messages.add(Message(text: text, isUser: true));
    notifyListeners();
  }

  Future<void> sendMessageToGemini(String userMessage) async {
    isLoading = true;
    notifyListeners();

    final response = await _geminiService.sendMessage(userMessage);

    messages.add(Message(text: response, isUser: false));
    isLoading = false;
    notifyListeners();
  }

  void clearChat() {
    messages.clear();
    notifyListeners();
  }
}
