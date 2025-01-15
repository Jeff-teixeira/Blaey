import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'dart:math';
import 'dart:ui';

import 'cell_component.dart';
import 'line_component.dart';

class GamePageJogoDaVelha extends StatelessWidget {
  final int betAmount;

  GamePageJogoDaVelha({required this.betAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jogo da Velha',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
          ),
        ),
        child: GameWidget(game: TicTacToeGame()),
      ),
    );
  }
}

class TicTacToeGame extends FlameGame with TapDetector {
  final List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
  bool isPlayerX = true;
  bool gameOver = false;
  int playerWins = 0;
  int aiWins = 0;
  List<Offset>? winningLine;
  late TextComponent playerScoreText;
  late TextComponent aiScoreText;
  late TextComponent turnText;

  @override
  Future<void> onLoad() async {
    // Configuração do placar
    playerScoreText = TextComponent(
      text: 'Jogador: 0',
      position: Vector2(50, 20),
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
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
    );

    aiScoreText = TextComponent(
      text: 'IA: 0',
      position: Vector2(size.x - 100, 20),
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
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
    );

    turnText = TextComponent(
      text: 'Vez do: X',
      position: Vector2(size.x / 2 - 50, 20),
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
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
    );

    add(playerScoreText);
    add(aiScoreText);
    add(turnText);

    // Desenha o tabuleiro
    for (var x = 0; x < 3; x++) {
      for (var y = 0; y < 3; y++) {
        final cell = CellComponent(
          row: x,
          col: y,
          position: Vector2(x * 100 + 50, y * 100 + 100),
          size: Vector2(100, 100),
          onTap: (row, col) => _onCellTapped(row, col),
        );
        add(cell);
      }
    }
  }

  void _onCellTapped(int x, int y) {
    if (board[x][y] == '' && !gameOver) {
      board[x][y] = isPlayerX ? 'X' : 'O';
      _checkWinner();
      if (!gameOver && !isPlayerX) {
        _aiMove();
      }
    }
  }

  void _aiMove() {
    final emptyCells = <Offset>[];
    for (var x = 0; x < 3; x++) {
      for (var y = 0; y < 3; y++) {
        if (board[x][y] == '') {
          emptyCells.add(Offset(x.toDouble(), y.toDouble()));
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      final randomCell = emptyCells[(emptyCells.length * Random().nextDouble()).floor()];
      final x = randomCell.dx.toInt();
      final y = randomCell.dy.toInt();
      board[x][y] = 'O';
      _checkWinner();
    }
  }

  void _checkWinner() {
    const winningCombinations = [
      // Linhas
      [[0, 0], [0, 1], [0, 2]],
      [[1, 0], [1, 1], [1, 2]],
      [[2, 0], [2, 1], [2, 2]],
      // Colunas
      [[0, 0], [1, 0], [2, 0]],
      [[0, 1], [1, 1], [2, 1]],
      [[0, 2], [1, 2], [2, 2]],
      // Diagonais
      [[0, 0], [1, 1], [2, 2]],
      [[0, 2], [1, 1], [2, 0]],
    ];

    for (var combination in winningCombinations) {
      final x1 = combination[0][0];
      final y1 = combination[0][1];
      final x2 = combination[1][0];
      final y2 = combination[1][1];
      final x3 = combination[2][0];
      final y3 = combination[2][1];

      if (board[x1][y1] != '' &&
          board[x1][y1] == board[x2][y2] &&
          board[x2][y2] == board[x3][y3]) {
        winningLine = [
          Offset(x1.toDouble(), y1.toDouble()),
          Offset(x3.toDouble(), y3.toDouble()),
        ];
        gameOver = true;
        if (board[x1][y1] == 'X') {
          playerWins++;
          playerScoreText.text = 'Jogador: $playerWins';
        } else {
          aiWins++;
          aiScoreText.text = 'IA: $aiWins';
        }
        _showWinnerAnimation();
        return;
      }
    }

    if (board.every((row) => row.every((cell) => cell != ''))) {
      gameOver = true;
      _showWinnerAnimation();
    } else {
      isPlayerX = !isPlayerX;
      turnText.text = 'Vez do: ${isPlayerX ? 'X' : 'O'}';
    }
  }

  void _showWinnerAnimation() {
    if (winningLine != null) {
      final line = LineComponent(
        start: Vector2(winningLine![0].dx * 100 + 100, winningLine![0].dy * 100 + 150),
        end: Vector2(winningLine![1].dx * 100 + 100, winningLine![1].dy * 100 + 150),
      );
      add(line);
    }

    Future.delayed(Duration(seconds: 2), () {
      if (playerWins == 3 || aiWins == 3) {
        _showFinalResult();
      } else {
        _resetGame();
      }
    });
  }

  void _showFinalResult() {
    final winner = playerWins == 3 ? 'Jogador' : 'IA';
    final backgroundColor = playerWins == 3 ? Colors.blue : Colors.red;

    overlays.add('GameOver');
  }

  void _resetGame() {
    board.forEach((row) => row.fillRange(0, 3, ''));
    isPlayerX = true;
    gameOver = false;
    winningLine = null;
    turnText.text = 'Vez do: X';
  }
}