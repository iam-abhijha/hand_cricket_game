import 'package:flutter/material.dart';

class InstructionItem extends StatelessWidget {
  final String number;
  final Widget child;
  final BoxDecoration decoration;

  const InstructionItem({super.key, required this.number, required this.child, required this.decoration});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(12),
      decoration: decoration,
      child: Row(
        children: [
          SizedBox(
            width: 18,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              child: Text(number, style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: child),
        ],
      ),
    );
  }
}
