import 'package:flutter/material.dart';

class CustomSpeechBubble extends StatelessWidget {
  final String title;
  final String description;
  final double width;
  final double trianglePositionPercentage;
  final bool isAbove;

  const CustomSpeechBubble({
    super.key,
    required this.title,
    required this.description,
    this.width = 320,
    this.trianglePositionPercentage = 0.5,
    this.isAbove = true,
  });

  @override
  Widget build(BuildContext context) {
    const triangleHeight = 20.0;
    return CustomPaint(
      painter: _SpeechBubblePainter(
        trianglePositionPercentage,
        isAbove: isAbove,
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: isAbove ? triangleHeight : 16,
          bottom: isAbove ? 35 : triangleHeight,
          left: 16,
          right: 16,
        ),
        width: width,
        child: Padding(
          padding:  EdgeInsets.only(top:isAbove?0.0:20),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                TextSpan(
                  text: " \n$description",
                  style:  Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.start,

          ),
        ),
      )

    );
  }
}

class _SpeechBubblePainter extends CustomPainter {
  final double trianglePositionPercentage;
  final bool isAbove;

  _SpeechBubblePainter(this.trianglePositionPercentage, {required this.isAbove});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    const r = 12.0;
    const pointerWidth = 16.0;
    const pointerHeight = 20.0;

    final pointerX = size.width * trianglePositionPercentage;

    final path = Path();

    if (isAbove) {
      // Triangle at bottom
      path
        ..moveTo(r, 0)
        ..lineTo(size.width - r, 0)
        ..quadraticBezierTo(size.width, 0, size.width, r)
        ..lineTo(size.width, size.height - pointerHeight - r)
        ..quadraticBezierTo(size.width, size.height - pointerHeight, size.width - r, size.height - pointerHeight)
        ..lineTo(pointerX + pointerWidth / 2, size.height - pointerHeight)
        ..lineTo(pointerX, size.height)
        ..lineTo(pointerX - pointerWidth / 2, size.height - pointerHeight)
        ..lineTo(r, size.height - pointerHeight)
        ..quadraticBezierTo(0, size.height - pointerHeight, 0, size.height - pointerHeight - r)
        ..lineTo(0, r)
        ..quadraticBezierTo(0, 0, r, 0);
    } else {
      // Triangle at top
      path
        ..moveTo(r, pointerHeight)
        ..lineTo(pointerX - pointerWidth / 2, pointerHeight)
        ..lineTo(pointerX, 0)
        ..lineTo(pointerX + pointerWidth / 2, pointerHeight)
        ..lineTo(size.width - r, pointerHeight)
        ..quadraticBezierTo(size.width, pointerHeight, size.width, pointerHeight )
        ..lineTo(size.width, size.height - r)
        ..quadraticBezierTo(size.width, size.height, size.width - r, size.height)
        ..lineTo(r, size.height)
        ..quadraticBezierTo(0, size.height, 0, size.height - r)
        ..lineTo(0, pointerHeight + r)
        ..quadraticBezierTo(0, pointerHeight, r, pointerHeight);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


