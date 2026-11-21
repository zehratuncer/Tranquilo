import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import '../../../core/theme/app_colors.dart';

class InteractiveRockWidget extends StatefulWidget {
  final String worryText;
  final VoidCallback onRockBroken;

  const InteractiveRockWidget({
    super.key,
    required this.worryText,
    required this.onRockBroken,
  });

  @override
  State<InteractiveRockWidget> createState() => _InteractiveRockWidgetState();
}

class _InteractiveRockWidgetState extends State<InteractiveRockWidget>
    with SingleTickerProviderStateMixin {
  /// Aşama 1: Sağlam Kaya (rock_stage_1)
  /// Aşama 2: İlk Çatlak (rock_stage_2)
  /// Aşama 3: Derin Kırılma (rock_stage_3)
  /// Aşama 4: Parçalanma (rock_stage_4)
  int _currentStage = 1;
  bool _isFinalStageReached = false;
  double _scale = 1.0;
  bool _showImpactFlash = false;

  final List<String> _rockImages = [
    'assets/images/rock_stage_1.png',
    'assets/images/rock_stage_2.png',
    'assets/images/rock_stage_3.png',
    'assets/images/rock_stage_4.png',
  ];

  Future<void> _triggerVibration(int stage) async {
    // 1. Standart Sistem Haptic Geri Bildirimi
    if (stage == 4) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.mediumImpact();
    }

    // 2. Android Donanımsal Titreşim Motoru (Vibrator Service)
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        if (stage == 1 || stage == 2) {
          Vibration.vibrate(duration: 45, amplitude: 140);
        } else if (stage == 3) {
          Vibration.vibrate(duration: 80, amplitude: 200);
        } else if (stage == 4) {
          // Son parçalanmada çift darbeli güçlü titreşim
          Vibration.vibrate(pattern: [0, 90, 50, 150], intensities: [0, 220, 0, 255]);
        }
      }
    } catch (_) {
      // Donanım desteklemezse sessizce haptic ile devam eder
    }
  }

  void _onTapRock() {
    if (_isFinalStageReached) return;

    final nextStage = _currentStage + 1;
    _triggerVibration(nextStage);

    setState(() {
      _scale = 0.92;
      _showImpactFlash = true;
      _currentStage = nextStage;
    });

    // Basılma ve parlama animasyonu sıfırlama
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) {
        setState(() {
          _scale = 1.0;
          _showImpactFlash = false;
        });
      }
    });

    // Son aşamaya (Fotoğraf 4) ulaşıldığında kısa süre göster ve soru akışına geç
    if (_currentStage >= 4) {
      setState(() => _isFinalStageReached = true);
      Future.delayed(const Duration(milliseconds: 650), () {
        if (mounted) {
          widget.onRockBroken();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageIndex = (_currentStage - 1).clamp(0, 3);
    final remainingHits = 4 - _currentStage;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Kullanıcıya dokunma yönlendirmesi
        AnimatedOpacity(
          opacity: _isFinalStageReached ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 250),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              _currentStage == 1
                  ? 'Kayaya dokunarak kaygını parçala'
                  : 'Dokunmaya devam et ($remainingHits)',
              style: TextStyle(
                color: AppColors.pink.withValues(alpha: 0.85),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),

        // Kaya ve Çatlama Efekti Alanı
        GestureDetector(
          onTap: _onTapRock,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeOutCubic,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Arka plandaki derin pembe/bordo parlama (Glow)
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _showImpactFlash
                            ? AppColors.pink.withValues(alpha: 0.55)
                            : AppColors.burgundy.withValues(alpha: 0.3),
                        blurRadius: _showImpactFlash ? 50 : 36,
                        spreadRadius: _showImpactFlash ? 14 : 4,
                      ),
                    ],
                  ),
                ),

                // Gerçek Kaya Görselleri Geçişi (Sprite Transition)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.94, end: 1.0).animate(
                        CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                      ),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Image.asset(
                    _rockImages[imageIndex],
                    key: ValueKey('rock_image_$imageIndex'),
                    width: 290,
                    height: 290,
                    fit: BoxFit.contain,
                  ),
                ),

                // Vuruş Anındaki Işık / Darbe Efekti
                if (_showImpactFlash)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.45),
                            AppColors.pink.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                // Kaygının sembolik metni (Kayanın merkezinde)
                if (_currentStage < 4)
                  Positioned(
                    bottom: 30,
                    child: Container(
                      width: 230,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.pink.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Text(
                        widget.worryText,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.darkTextPrimary.withValues(alpha: 0.85),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        )
            .animate(target: _isFinalStageReached ? 1 : 0)
            .shake(duration: 400.ms, hz: 7)
            .scaleXY(end: 1.08, duration: 300.ms)
            .fadeOut(duration: 350.ms),
      ],
    );
  }
}
