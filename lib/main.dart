import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/services/local_storage_service.dart';
import 'core/constants/supabase_config.dart';
import 'features/session/screens/session_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Hive Yerel Depolamayı Başlat
  await LocalStorageService.init();

  // 2. Supabase Yapılandırılmışsa Başlat
  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      publishableKey: SupabaseConfig.supabasePublishableKey,
    );
  }

  runApp(const ProviderScope(child: TranquiloApp()));
}

class TranquiloApp extends StatelessWidget {
  const TranquiloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tranquilo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const SessionScreen(),
    );
  }
}
