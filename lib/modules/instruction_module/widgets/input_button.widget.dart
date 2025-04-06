import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String imagePath;
  final double size;
  const ButtonWidget({super.key, required this.imagePath, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size, child: Image.asset(imagePath));
  }
}
