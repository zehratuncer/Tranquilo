import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/service_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late bool _haptic;
  late bool _sound;
  late bool _reduceAnimations;
  late bool _doNotSaveHistory;

  @override
  void initState() {
    super.initState();
    final local = ref.read(localStorageServiceProvider);
    _haptic = local.hapticEnabled;
    _sound = local.soundEnabled;
    _reduceAnimations = local.reduceAnimations;
    _doNotSaveHistory = local.doNotSaveHistory;
  }

  Future<void> _confirmDeleteAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: const Text(
          'Tüm Verileri ve Hesabı Sil?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Bu işlem geri alınamaz. Cihazındaki ve sunucudaki tüm seans kayıtların kalıcı olarak silinecektir.',
          style: TextStyle(color: AppColors.darkTextSecondary),
        ),
        actions: [
          TextButton(
            child: const Text('Vazgeç', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.safetyWarning,
              foregroundColor: Colors.white,
            ),
            child: const Text('Evet, Hepsini Sil'),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final repository = ref.read(sessionRepositoryProvider);
      await repository.clearAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tüm verilerin ve hesabın başarıyla silindi.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = ref.read(localStorageServiceProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Ayarlar',
          style: TextStyle(color: AppColors.pink, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.pink),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader('DENEYİM VE DUYUSAL GERİ BİLDİRİM'),
          SwitchListTile(
            title: const Text('Dokunsal Titreşim (Haptic)'),
            subtitle: const Text('Kayaya dokunurken ve taşları iterken hafif titreşim.'),
            value: _haptic,
            activeThumbColor: AppColors.pink,
            onChanged: (val) {
              setState(() => _haptic = val);
              local.setHapticEnabled(val);
            },
          ),
          SwitchListTile(
            title: const Text('Sakinleştirici Sesler'),
            subtitle: const Text('Kaya ve nefes benzeri hafif arka plan sesleri.'),
            value: _sound,
            activeThumbColor: AppColors.pink,
            onChanged: (val) {
              setState(() => _sound = val);
              local.setSoundEnabled(val);
            },
          ),
          SwitchListTile(
            title: const Text('Animasyonları Azalt'),
            subtitle: const Text('Daha sakin ve hareketsiz geçişler sağlar.'),
            value: _reduceAnimations,
            activeThumbColor: AppColors.pink,
            onChanged: (val) {
              setState(() => _reduceAnimations = val);
              local.setReduceAnimations(val);
            },
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('GİZLİLİK VE VERİ'),
          SwitchListTile(
            title: const Text('Geçmişi Hiç Kaydetme'),
            subtitle: const Text('Seansların tamamlandıktan sonra hiçbir yerde saklanmaz.'),
            value: _doNotSaveHistory,
            activeThumbColor: AppColors.pink,
            onChanged: (val) {
              setState(() => _doNotSaveHistory = val);
              local.setDoNotSaveHistory(val);
            },
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('HESAP VE MAĞAZA GÜVENLİĞİ'),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: AppColors.safetyWarning),
            title: const Text(
              'Tüm Verilerimi ve Hesabımı Sil',
              style: TextStyle(color: AppColors.safetyWarning, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Google Play uyumlu kalıcı veri imhası.'),
            onTap: _confirmDeleteAllData,
          ),

          const SizedBox(height: 32),
          Center(
            child: Text(
              'Tranquilo v1.0.0 (Düşünce Süzgeci)\ncom.zehratuncer.tranquilo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.darkTextSecondary.withValues(alpha: 0.5),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
          color: AppColors.pink,
        ),
      ),
    );
  }
}
