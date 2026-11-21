import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import 'crack_painter.dart';

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

class _InteractiveRockWidgetState extends State<InteractiveRockWidget> {
  int _hitCount = 0;
  static const int _maxHits = 4;
  bool _isBroken = false;
  double _scale = 1.0;

  void _onTapRock() {
    if (_isBroken) return;

    // Dokunsal geri bildirim (Haptic Feedback)
    HapticFeedback.mediumImpact();

    setState(() {
      _hitCount++;
      _scale = 0.94; // Vuruş esnasında hafif basılma efekti
    });

    Future.delayed(const Duration(milliseconds: 90), () {
      if (mounted) {
        setState(() => _scale = 1.0);
      }
    });

    if (_hitCount >= _maxHits) {
      setState(() => _isBroken = true);
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 350), () {
        widget.onRockBroken();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Kullanıcıya dokunma yönlendirmesi
        AnimatedOpacity(
          opacity: _isBroken ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 250),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              _hitCount == 0
                  ? 'Kayaya dokunarak kaygını parçala'
                  : 'Dokunmaya devam et (${_maxHits - _hitCount})',
              style: TextStyle(
                color: AppColors.pink.withValues(alpha: 0.8),
                fontSize: 16,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),

        // Kaya ve Çatlak Animasyon Alanı
        GestureDetector(
          onTap: _onTapRock,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOutCubic,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Kaya Gövdesi
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: AppColors.darkRock,
                    borderRadius: BorderRadius.circular(125),
                    gradient: RadialGradient(
                      center: const Alignment(-0.25, -0.25),
                      radius: 0.9,
                      colors: [
                        AppColors.darkSurface,
                        AppColors.darkRock,
                        Colors.black.withValues(alpha: 0.95),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.burgundy.withValues(alpha: 0.25),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.pink.withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Text(
                        widget.worryText,
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.darkTextSecondary.withValues(alpha: 0.65),
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),

                // Çatlaklar Katmanı
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CustomPaint(
                    painter: CrackPainter(
                      hitCount: _hitCount,
                      crackColor: AppColors.pink.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
            .animate(target: _isBroken ? 1 : 0)
            .shake(duration: 350.ms, hz: 6)
            .scaleXY(end: 1.15, duration: 250.ms)
            .fadeOut(duration: 250.ms),
      ],
    );
  }
}
