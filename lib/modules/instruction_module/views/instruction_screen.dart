import 'package:flutter/material.dart';
import 'package:hand_cricket_game/modules/instruction_module/widgets/input_button.widget.dart';
import 'package:hand_cricket_game/modules/instruction_module/widgets/instruction_content.widget.dart';
import 'package:hand_cricket_game/modules/instruction_module/widgets/instruction_item.widget.dart';
import 'package:hand_cricket_game/modules/instruction_module/widgets/start_game.widget.dart';

class InstructionScreen extends StatelessWidget {
  const InstructionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 1, 32, 58), Colors.red],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            const Text(
              'How to Play',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 224, 212, 103)),
            ),
            const SizedBox(height: 80),

            // First instruction
            InstructionItem(
              number: '1',
              decoration: _containerDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.36,
                    child: const Text(
                      'Tap the buttons to score Runs',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: const [
                        ButtonWidget(imagePath: 'assets/images/one.png', size: 40),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: ButtonWidget(imagePath: 'assets/images/three.png', size: 40),
                        ),
                        ButtonWidget(imagePath: 'assets/images/six.png', size: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Second instruction
            InstructionItem(
              number: '2',
              decoration: _containerDecoration(),
              child: InstructionContent(
                title: 'Same Number: ',
                subtitle: 'You\'re out!',
                subtitleColor: Colors.red,
                imagePath: 'assets/images/same.png',
              ),
            ),

            // Third instruction
            InstructionItem(
              number: '3',
              decoration: _containerDecoration(),
              child: InstructionContent(
                title: 'Different Number: ',
                subtitle: 'You score runs',
                subtitleColor: Colors.green,
                imagePath: 'assets/images/different.png',
              ),
            ),

            const Spacer(),
            StartGameButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Reusable container decoration
  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white24),
    );
  }
}
