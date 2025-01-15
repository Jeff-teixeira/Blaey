import 'package:flutter/material.dart';

class GamePageJogoDaVelha extends StatefulWidget {
  final double betAmount;

  GamePageJogoDaVelha({required this.betAmount});

  @override
  _GamePageJogoDaVelhaState createState() => _GamePageJogoDaVelhaState();
}

class _GamePageJogoDaVelhaState extends State<GamePageJogoDaVelha> {
  late List<List<String>> board;
  late String currentPlayer;
  late bool gameOver;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    board = List.generate(3, (_) => List.filled(3, ''));
    currentPlayer = 'X';
    gameOver = false;
  }

  void _handleCellTap(int row, int col) {
    if (board[row][col].isEmpty && !gameOver) {
      setState(() {
        board[row][col] = currentPlayer;
        if (_checkWinner(row, col)) {
          gameOver = true;
          _showGameOverDialog('$currentPlayer venceu!');
        } else if (_isBoardFull()) {
          gameOver = true;
          _showGameOverDialog('Empate!');
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool _checkWinner(int row, int col) {
    // Verifique a linha
    if (board[row].every((cell) => cell == currentPlayer)) return true;
    
    // Verifique a coluna
    if (board.every((row) => row[col] == currentPlayer)) return true;
    
    // Verifique as diagonais
    if (row == col && board.every((row) => board[row][row] == currentPlayer)) return true;
    if (row + col == 2 && board.every((row) => board[row][2 - row] == currentPlayer)) return true;
    
    return false;
  }

  bool _isBoardFull() {
    return board.every((row) => row.every((cell) => cell.isNotEmpty));
  }

  void _showGameOverDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fim de Jogo'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Jogar Novamente'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _initializeGame();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Velha'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Aposta: ${widget.betAmount}', style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  return GestureDetector(
                    onTap: () => _handleCellTap(row, col),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          board[row][col],
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}