import 'package:flutter/material.dart';

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double dashWidth = 4; // Width of each dash
    final double dashSpace = .1; // Space between dashes
    final double startY = 0;
    final double endY = size.height;

    double currentY = startY;
    bool draw = true;

    while (currentY < endY) {
      if (draw) {
        canvas.drawLine(
          Offset(size.width / 2, currentY),
          Offset(size.width / 2, currentY + dashWidth),
          Paint()
            ..color = Color(0xFF919191) // Color of the dots
            ..strokeWidth = 2, // Width of the dots
        );
      }
      currentY += dashWidth + dashSpace;
      draw = !draw;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
