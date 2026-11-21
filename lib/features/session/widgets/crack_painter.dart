import 'package:flutter/material.dart';

class CrackPainter extends CustomPainter {
  final int hitCount;
  final Color crackColor;

  CrackPainter({
    required this.hitCount,
    required this.crackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (hitCount <= 0) return;

    final paint = Paint()
      ..color = crackColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.5;

    final center = Offset(size.width / 2, size.height / 2);

    // 1. Vuruş: Merkezden yukarı-sağa ve aşağı-sola ilk çatlaklar
    if (hitCount >= 1) {
      final path1 = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(center.dx + 25, center.dy - 35)
        ..lineTo(center.dx + 45, center.dy - 70)
        ..lineTo(center.dx + 80, center.dy - 95);

      final path2 = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(center.dx - 20, center.dy + 30)
        ..lineTo(center.dx - 55, center.dy + 65)
        ..lineTo(center.dx - 85, center.dy + 100);

      canvas.drawPath(path1, paint);
      canvas.drawPath(path2, paint);
    }

    // 2. Vuruş: Çapraz ve yan çatlaklar
    if (hitCount >= 2) {
      final path3 = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(center.dx - 35, center.dy - 25)
        ..lineTo(center.dx - 70, center.dy - 40)
        ..lineTo(center.dx - 105, center.dy - 55);

      final path4 = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(center.dx + 30, center.dy + 25)
        ..lineTo(center.dx + 65, center.dy + 55)
        ..lineTo(center.dx + 95, center.dy + 85);

      canvas.drawPath(path3, paint);
      canvas.drawPath(path4, paint);
    }

    // 3. Vuruş: Derinleşen ve kayayı parçalamaya hazırlayan kılcal kırılmalar
    if (hitCount >= 3) {
      paint.strokeWidth = 3.5;
      final path5 = Path()
        ..moveTo(center.dx + 25, center.dy - 35)
        ..lineTo(center.dx - 15, center.dy - 65)
        ..lineTo(center.dx - 20, center.dy - 105);

      final path6 = Path()
        ..moveTo(center.dx - 20, center.dy + 30)
        ..lineTo(center.dx + 20, center.dy + 60)
        ..lineTo(center.dx + 35, center.dy + 105);

      canvas.drawPath(path5, paint);
      canvas.drawPath(path6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CrackPainter oldDelegate) {
    return oldDelegate.hitCount != hitCount || oldDelegate.crackColor != crackColor;
  }
}
