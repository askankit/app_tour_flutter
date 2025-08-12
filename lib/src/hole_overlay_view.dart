import 'package:flutter/material.dart';

class HoleOverlay extends StatelessWidget {
  final Rect holeRect;
  final double borderRadius;

  const HoleOverlay({
    super.key,
    required this.holeRect,
    this.borderRadius = 8.0,
  });


  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HolePainter(holeRect: holeRect, borderRadius: borderRadius),
      child: Container(), // needed to fill area
    );
  }
}

class _HolePainter extends CustomPainter {
  final Rect holeRect;
  final double borderRadius;

  _HolePainter({required this.holeRect, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.7)
      ..blendMode = BlendMode.srcOver;

    final overlayPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final holePath = Path()
      ..addRRect(RRect.fromRectAndRadius(holeRect, Radius.circular(borderRadius)))
      ..close();

    final finalPath = Path.combine(PathOperation.difference, overlayPath, holePath);
    canvas.drawPath(finalPath, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
