import 'package:flutter/material.dart';

class Starfield extends StatelessWidget {
  const Starfield({super.key});

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: CustomPaint(
      painter: _StarfieldPainter(),
      child: const SizedBox.expand(),
    ),
  );
}

class _StarfieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const points = <Offset>[
      Offset(0.09, 0.17),
      Offset(0.91, 0.26),
      Offset(0.07, 0.53),
      Offset(0.89, 0.61),
      Offset(0.17, 0.83),
      Offset(0.78, 0.91),
    ];
    final dot = Paint()..color = const Color(0x337CE3B6);
    final line = Paint()
      ..color = const Color(0x447CE3B6)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    for (var index = 0; index < points.length; index++) {
      final point = Offset(
        points[index].dx * size.width,
        points[index].dy * size.height,
      );
      if (index.isEven) {
        canvas.drawCircle(point, 2.5, dot);
      } else {
        canvas.drawLine(point.translate(-4, 0), point.translate(4, 0), line);
        canvas.drawLine(point.translate(0, -4), point.translate(0, 4), line);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
