import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_storage_service.dart';
import '../services/supabase_service.dart';
import '../services/session_repository.dart';

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  final local = ref.watch(localStorageServiceProvider);
  final supabase = ref.watch(supabaseServiceProvider);
  return SessionRepository(local: local, supabase: supabase);
});
