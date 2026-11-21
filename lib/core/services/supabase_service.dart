import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/session/models/session_model.dart';
import '../constants/fallback_prompts.dart';
import '../constants/supabase_config.dart';

class SupabaseService {
  final SupabaseClient? _client;

  SupabaseService([this._client]);

  SupabaseClient? get client {
    if (_client != null) return _client;
    if (SupabaseConfig.isConfigured) {
      return Supabase.instance.client;
    }
    return null;
  }

  bool get isAvailable => client != null;

  String get currentUserId => client?.auth.currentUser?.id ?? 'anonymous';

  // --- Auth (Anonim & Kalıcı Giriş) ---

  Future<User?> signInAnonymously() async {
    if (!isAvailable) return null;
    try {
      final response = await client!.auth.signInAnonymously();
      return response.user;
    } catch (e) {
      debugPrint('Supabase signInAnonymously error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    if (!isAvailable) return;
    try {
      await client!.auth.signOut();
    } catch (e) {
      debugPrint('Supabase signOut error: $e');
    }
  }

  // --- AI Soruları ve Rahatlama Mesajı (Edge Functions) ---

  Future<List<String>> generateQuestionsForWorry(String worryText) async {
    if (!isAvailable) {
      return FallbackPrompts.defaultQuestions;
    }

    try {
      final res = await client!.functions.invoke(
        'generate-questions',
        body: {'worryText': worryText},
      );

      if (res.status == 200 && res.data != null) {
        final List<dynamic> list = res.data['questions'] as List<dynamic>? ?? [];
        if (list.isNotEmpty) {
          return list.map((e) => e.toString()).toList();
        }
      }
      return FallbackPrompts.defaultQuestions;
    } catch (e) {
      debugPrint('AI generateQuestions error, falling back: $e');
      return FallbackPrompts.defaultQuestions;
    }
  }

  Future<String> generateReliefMessage({
    required String worryText,
    required String smallAction,
    required Map<String, String> answers,
  }) async {
    if (!isAvailable) {
      return FallbackPrompts.defaultReliefMessage;
    }

    try {
      final res = await client!.functions.invoke(
        'generate-relief-message',
        body: {
          'worryText': worryText,
          'smallAction': smallAction,
          'answers': answers,
        },
      );

      if (res.status == 200 && res.data != null) {
        final msg = res.data['reliefMessage'] as String?;
        if (msg != null && msg.isNotEmpty) {
          return msg;
        }
      }
      return FallbackPrompts.defaultReliefMessage;
    } catch (e) {
      debugPrint('AI generateReliefMessage error, falling back: $e');
      return FallbackPrompts.defaultReliefMessage;
    }
  }

  // --- Seans Senkronizasyonu ---

  Future<bool> syncSession(SessionModel session) async {
    if (!isAvailable) return false;
    try {
      final data = session.toMap()..remove('is_synced');
      data['user_id'] = currentUserId;

      await client!.from('sessions').upsert(data);
      return true;
    } catch (e) {
      debugPrint('Supabase syncSession error: $e');
      return false;
    }
  }

  Future<bool> deleteSessionRemote(String sessionId) async {
    if (!isAvailable) return false;
    try {
      await client!.from('sessions').delete().eq('id', sessionId);
      return true;
    } catch (e) {
      debugPrint('Supabase deleteSessionRemote error: $e');
      return false;
    }
  }

  // --- Hesap ve Veri Silme (Google Play Zorunluluğu) ---

  Future<bool> deleteAccountAndAllData() async {
    if (!isAvailable) return true;
    try {
      // 1. Kullanıcının tüm oturum kayıtlarını sil
      await client!.from('sessions').delete().eq('user_id', currentUserId);
      // 2. Kullanıcı hesabını silme (Edge function veya Auth Admin API)
      await client!.functions.invoke('delete-user-account');
      await signOut();
      return true;
    } catch (e) {
      debugPrint('Supabase deleteAccountAndAllData error: $e');
      return false;
    }
  }
}
