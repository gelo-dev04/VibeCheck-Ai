import 'dart:typed_data';
import 'package:firebase_ai/firebase_ai.dart';
import 'dart:convert';

class VibeAIService {
  // Initialize Gemini 3.0 Flash with Google AI backend
  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-1.5-flash',
    generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    systemInstruction: Content.system(
      "You are an empathetic mood assistant. Analyze the audio and return JSON with: 'summary' (3 sentences), 'mood' (one word), and 'color' (hex code).",
    ),
  );

  Future<Map<String, dynamic>> processVibe(Uint8List audioBytes) async {
    final prompt = [
      Content.multi([
        TextPart("Analyze my current vibe from this audio."),
        InlineDataPart('audio/mp3', audioBytes),
      ]),
    ];

    final response = await model.generateContent(prompt);
    return jsonDecode(response.text ?? '{}');
  }
}
