import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class LineComponent extends PositionComponent {
  final Vector2 start;
  final Vector2 end;

  LineComponent({required this.start, required this.end});

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [Colors.yellow, Colors.orange],
      ).createShader(Rect.fromPoints(start.toOffset(), end.toOffset()));

    canvas.drawLine(start.toOffset(), end.toOffset(), paint);
  }
}