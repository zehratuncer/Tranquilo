import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      themeMode: ThemeMode.dark, // Sakin ve yoğun atmosferle başlar
      home: const Scaffold(
        body: Center(
          child: Text(
            'Tranquilo\n"Düşünce yok olmadı; ama artık daha taşınabilir."',
            textAlign: TextAlign.center,
            style: TextStyle(height: 1.6),
          ),
        ),
      ),
    );
  }
}
