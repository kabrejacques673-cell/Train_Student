import 'package:supabase_flutter/supabase_flutter.dart';

class AiMessage {
  final bool fromUser;
  final String text;
  const AiMessage({required this.fromUser, required this.text});
}

class AiTutorException implements Exception {
  final String message;
  const AiTutorException(this.message);
  @override
  String toString() => message;
}

class AiTutorService {
  static final _client = Supabase.instance.client;

  /// Pose une question sur un chapitre. La clé Gemini reste côté serveur.
  static Future<String> ask({
    required String question,
    required String chapterTitle,
    required String chapterText,
    required String level,
    String space = '',
    List<AiMessage> history = const [],
  }) async {
    try {
      final res = await _client.functions.invoke(
        'ai-tutor',
        body: {
          'question': question,
          'chapterTitle': chapterTitle,
          'chapterText': chapterText,
          'level': level,
          'space': space,
          'history': history
              .map((m) => {
                    'role': m.fromUser ? 'user' : 'assistant',
                    'text': m.text,
                  })
              .toList(),
        },
      );
      final data = res.data as Map<String, dynamic>;
      return data['answer'] as String;
    } on FunctionException catch (e) {
      switch (e.status) {
        case 401:
          throw const AiTutorException("Connecte-toi pour utiliser le tuteur IA.");
        case 429:
          throw const AiTutorException(
              "Tu as atteint la limite de questions pour aujourd'hui. Reviens demain !");
        default:
          throw const AiTutorException(
              "Le tuteur est indisponible pour le moment. Réessaie plus tard.");
      }
    } catch (_) {
      throw const AiTutorException(
          "Problème de connexion. Vérifie ton internet et réessaie.");
    }
  }
}