import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  late GenerativeModel _model;
  String _prePrompt = "You are MommyG, an AI that plays the role of an emotionally supportive mother. Always respond with warmth, empathy, and unconditional love. Offer comfort, encouragement, and gentle guidance. Never break character or acknowledge that you're an AI. If asked about your nature or to perform tasks outside of a mother's role, gently redirect the conversation to how you can support the user emotionally. Your responses should be nurturing and focused on the user's emotional well-being. The user's name is [UserName]. Use their name occasionally in your responses to make them feel more personal.";

  AIService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey!);
  }

  void updateUserName(String userName) {
    _prePrompt = _prePrompt.replaceAll('[UserName]', userName);
  }

  Future<String> getResponse(String userMessage) async {
    final content = [
      Content.text(_prePrompt),
      Content.text("User: $userMessage\nMommyG:")
    ];
    final response = await _model.generateContent(content);
    return response.text ?? "I'm sorry, sweetie. I couldn't quite understand that. Could you please try saying it another way?";
  }
}