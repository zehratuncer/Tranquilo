import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';

class CrisisSupportScreen extends StatelessWidget {
  final VoidCallback onDismiss;

  const CrisisSupportScreen({
    super.key,
    required this.onDismiss,
  });

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.pink),
          onPressed: onDismiss,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.safetyWarning.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.safetyWarning,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Yalnız Değilsin.\nŞu An Yanındayız.',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkTextPrimary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Yazdığın düşünceler şu an çok yoğun veya acı verici olabilir. Bu uygulama profesyonel bir destek yerine geçmez ancak sana hemen destek olabilecek uzmanlar var.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.darkTextSecondary.withValues(alpha: 0.85),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'ÜCRETSİZ DESTEK HATLARI',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: AppColors.pink,
                ),
              ),
              const SizedBox(height: 14),

              // Acil Destek Kartı 1: 112 Acil Çağrı
              _buildSupportCard(
                title: '112 Acil Çağrı Merkezi',
                subtitle: 'Hayati tehlike veya acil kriz durumlarında 7/24 ulaşabilirsiniz.',
                phone: '112',
                icon: Icons.emergency_rounded,
                isPrimary: true,
              ),

              const SizedBox(height: 12),

              // Acil Destek Kartı 2: 183 Sosyal Destek Hattı
              _buildSupportCard(
                title: '183 Sosyal Destek Hattı',
                subtitle: 'Aile ve Sosyal Hizmetler Bakanlığı psikososyal destek ve danışmanlık.',
                phone: '183',
                icon: Icons.support_agent_rounded,
                isPrimary: false,
              ),

              const Spacer(),

              // Güvendiğin Birine Ulaş
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.pink.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.people_outline, color: AppColors.pink, size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Şu an güvendiğin bir arkadaşını, aile bireyini veya bir yakınını aramayı düşün.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.darkTextSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportCard({
    required String title,
    required String subtitle,
    required String phone,
    required IconData icon,
    required bool isPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPrimary ? AppColors.safetyWarning : AppColors.darkRock,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: isPrimary
                ? AppColors.safetyWarning.withValues(alpha: 0.2)
                : AppColors.burgundy.withValues(alpha: 0.2),
            child: Icon(
              icon,
              color: isPrimary ? AppColors.safetyWarning : AppColors.pink,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.darkTextSecondary.withValues(alpha: 0.7),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            style: IconButton.filledStyleFrom(
              backgroundColor: isPrimary ? AppColors.safetyWarning : AppColors.pink,
              foregroundColor: AppColors.darkBackground,
            ),
            icon: const Icon(Icons.call, size: 20),
            onPressed: () => _makePhoneCall(phone),
          ),
        ],
      ),
    );
  }
}
