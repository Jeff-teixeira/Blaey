import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class CellComponent extends PositionComponent with TapCallbacks {
  final int row;
  final int col;
  final Function(int, int) onTap;
  String symbol = '';

  CellComponent({
    required this.row,
    required this.col,
    required this.onTap,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  void onTapDown(TapDownEvent event) {
    onTap(row, col);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Desenha o fundo da célula
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawRect(size.toRect(), backgroundPaint);

    // Desenha a borda da célula
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(size.toRect(), borderPaint);

    // Desenha o símbolo (X ou O)
    if (symbol.isNotEmpty) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: symbol,
          style: TextStyle(
            color: symbol == 'X' ? Colors.blue : Colors.red,
            fontSize: size.x * 0.6,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(2, 2),
                blurRadius: 3,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          (size.x - textPainter.width) / 2,
          (size.y - textPainter.height) / 2,
        ),
      );
    }
  }
}