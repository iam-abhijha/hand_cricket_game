import 'package:flutter/material.dart';

class InstructionContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color subtitleColor;
  final String imagePath;

  const InstructionContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.subtitleColor,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
              Text(subtitle, style: TextStyle(color: subtitleColor, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(padding: const EdgeInsets.only(right: 16), child: Image.asset(imagePath, width: 48, height: 48)),
      ],
    );
  }
}
