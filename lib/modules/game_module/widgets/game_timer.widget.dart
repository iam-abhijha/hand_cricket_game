import 'package:flutter/material.dart';

class GameTimer extends StatelessWidget {
  final int timeLeft;

  const GameTimer({super.key, required this.timeLeft});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(width: 120, height: 2, color: const Color.fromARGB(255, 1, 58, 104)),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 1, 58, 104),
            shape: BoxShape.circle,
            border: Border.all(color: const Color.fromARGB(255, 1, 58, 104), width: 2),
          ),
          child: Center(
            child: Text(
              '$timeLeft',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
