import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  final List<List<String>> board;
  final Function(int, int) onCellTapped;

  const BoardWidget({
    Key? key,
    required this.board,
    required this.onCellTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            final x = index ~/ 3;
            final y = index % 3;
            return GestureDetector(
              onTap: () => onCellTapped(x, y),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    board[x][y],
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}