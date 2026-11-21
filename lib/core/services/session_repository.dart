import '../../features/session/models/session_model.dart';
import 'local_storage_service.dart';
import 'supabase_service.dart';

class SessionRepository {
  final LocalStorageService local;
  final SupabaseService supabase;

  SessionRepository({
    required this.local,
    required this.supabase,
  });

  /// Yeni bir seansı önce cihaza kaydeder, ardından arka planda Supabase ile eşitler
  Future<SessionModel> saveSession(SessionModel session) async {
    // Kullanıcı ayarlarında "Geçmişi Kaydetme" seçilmişse kaydetmeden dön
    if (local.doNotSaveHistory) {
      return session;
    }

    // 1. Local-First: Cihaza anında yaz
    await local.saveSession(session);

    // 2. Buluta senkronize etmeyi dene
    if (supabase.isAvailable) {
      final success = await supabase.syncSession(session);
      if (success) {
        await local.markAsSynced(session.id);
        return session.copyWith(isSynced: true);
      }
    }

    return session;
  }

  List<SessionModel> getSessions() {
    return local.getAllSessions();
  }

  Future<void> deleteSession(String id) async {
    await local.deleteSession(id);
    if (supabase.isAvailable) {
      await supabase.deleteSessionRemote(id);
    }
  }

  /// Bekleyen senkronize olmamış seansları arka planda buluta aktarır
  Future<void> syncPendingSessions() async {
    if (!supabase.isAvailable) return;

    final pending = local.getUnsyncedSessions();
    for (final session in pending) {
      final success = await supabase.syncSession(session);
      if (success) {
        await local.markAsSynced(session.id);
      }
    }
  }

  /// Tüm geçmişi ve hesabı temizleme
  Future<void> clearAll() async {
    await local.clearAllData();
    if (supabase.isAvailable) {
      await supabase.deleteAccountAndAllData();
    }
  }
}
