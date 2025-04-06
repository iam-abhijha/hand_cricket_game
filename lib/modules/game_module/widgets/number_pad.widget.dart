import 'package:flutter/material.dart';

class NumberPad extends StatelessWidget {
  final Function(int) onNumberSelected;

  const NumberPad({super.key, required this.onNumberSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0, top: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [1, 2, 3].map((n) => _buildButton(n)).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [4, 5, 6].map((n) => _buildButton(n)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(int number) {
    return GestureDetector(
      onTap: () => onNumberSelected(number),
      child: Image.asset('assets/images/${_numberToWord(number)}.png', width: 56, height: 56),
    );
  }

  String _numberToWord(int number) {
    switch (number) {
      case 1:
        return 'one';
      case 2:
        return 'two';
      case 3:
        return 'three';
      case 4:
        return 'four';
      case 5:
        return 'five';
      case 6:
        return 'six';
      default:
        return '';
    }
  }
}
