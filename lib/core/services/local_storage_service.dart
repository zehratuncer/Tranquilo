import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/session/models/session_model.dart';

class LocalStorageService {
  static const String _sessionsBoxName = 'sessions_box';
  static const String _settingsBoxName = 'settings_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(_sessionsBoxName);
    await Hive.openBox<dynamic>(_settingsBoxName);
  }

  Box<Map> get _sessionsBox => Hive.box<Map>(_sessionsBoxName);
  Box<dynamic> get _settingsBox => Hive.box<dynamic>(_settingsBoxName);

  // --- Seans Kayıtları ---

  Future<void> saveSession(SessionModel session) async {
    await _sessionsBox.put(session.id, session.toMap());
  }

  List<SessionModel> getAllSessions() {
    try {
      final rawList = _sessionsBox.values.toList();
      final sessions = rawList.map((map) {
        return SessionModel.fromMap(Map<String, dynamic>.from(map));
      }).toList();

      // En yeni seans en üstte
      sessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return sessions;
    } catch (e) {
      debugPrint('Error getting sessions from Hive: $e');
      return [];
    }
  }

  SessionModel? getSession(String id) {
    final raw = _sessionsBox.get(id);
    if (raw == null) return null;
    return SessionModel.fromMap(Map<String, dynamic>.from(raw));
  }

  Future<void> deleteSession(String id) async {
    await _sessionsBox.delete(id);
  }

  List<SessionModel> getUnsyncedSessions() {
    return getAllSessions().where((s) => !s.isSynced).toList();
  }

  Future<void> markAsSynced(String id) async {
    final session = getSession(id);
    if (session != null) {
      await saveSession(session.copyWith(isSynced: true));
    }
  }

  Future<void> clearAllData() async {
    await _sessionsBox.clear();
    await _settingsBox.clear();
  }

  // --- Ayarlar / Tercihler ---

  bool get hapticEnabled => _settingsBox.get('haptic_enabled', defaultValue: true) as bool;
  Future<void> setHapticEnabled(bool value) => _settingsBox.put('haptic_enabled', value);

  bool get soundEnabled => _settingsBox.get('sound_enabled', defaultValue: false) as bool;
  Future<void> setSoundEnabled(bool value) => _settingsBox.put('sound_enabled', value);

  bool get reduceAnimations => _settingsBox.get('reduce_animations', defaultValue: false) as bool;
  Future<void> setReduceAnimations(bool value) => _settingsBox.put('reduce_animations', value);

  bool get doNotSaveHistory => _settingsBox.get('do_not_save_history', defaultValue: false) as bool;
  Future<void> setDoNotSaveHistory(bool value) => _settingsBox.put('do_not_save_history', value);
}
