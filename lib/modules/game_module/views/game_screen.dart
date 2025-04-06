import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hand_cricket_game/modules/game_module/enums/game.enums.dart';
import 'package:hand_cricket_game/modules/game_module/view_models/game_screen.view_model.dart';
import 'package:hand_cricket_game/modules/game_module/widgets/game_timer.widget.dart';
import 'package:hand_cricket_game/modules/game_module/widgets/number_pad.widget.dart';
import 'package:scoped_model/scoped_model.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameViewModel viewModel;
  Timer? _timer;
  Timer? _debounceTimer;
  int _timeLeft = 10;
  bool _isBackgroundLoaded = false;
  bool _isGameInitialized = false;

  @override
  void initState() {
    super.initState();
    viewModel = GameViewModel();
    viewModel.startGame();
    _startTimer();
  }

  void _onBackgroundLoaded() {
    if (!_isGameInitialized) {
      setState(() {
        _isBackgroundLoaded = true;
        _isGameInitialized = true;
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _timeLeft = 10);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        timer.cancel();
        viewModel.handleTimeout();
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _onUserInput(int number) {
    if (_debounceTimer?.isActive ?? false) return;
    _timer?.cancel();
    viewModel.handleUserInput(number);
    _debounceTimer = Timer(const Duration(seconds: 1), () {});
    if (viewModel.currentPhase != GamePhase.finished) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<GameViewModel>(
      model: viewModel,
      child: ScopedModelDescendant<GameViewModel>(
        builder: (context, child, viewModel) {
          return Scaffold(
            body: Stack(
              children: [
                Image.asset(
                  'assets/images/background.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) {
                      _isBackgroundLoaded = true;
                      return child;
                    }
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child:
                          frame != null
                              ? (() {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  _onBackgroundLoaded();
                                });

                                return child;
                              }())
                              : const SizedBox.shrink(),
                    );
                  },
                ),
                if (!_isBackgroundLoaded)
                  Container(
                    color: const Color.fromARGB(255, 3, 53, 94),
                    child: const Center(child: CircularProgressIndicator(color: Colors.yellow)),
                  ),
                if (_isBackgroundLoaded)
                  Column(
                    children: [
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _scoreBox(label: 'You', score: viewModel.playerScore),
                            _scoreBox(label: 'Bot', score: viewModel.botScore),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Image.asset(viewModel.centerImage),
                      ),
                      if (viewModel.currentPhase == GamePhase.finished) ...[
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                          onPressed: () {
                            viewModel.startGame();
                            _startTimer();
                          },
                          child: const Text('Restart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        const Spacer(),
                      ] else ...[
                        const SizedBox(height: 20),
                        GameTimer(timeLeft: _timeLeft),
                        const SizedBox(height: 10),
                        const Text(
                          'Press a number before timer runs out',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        const SizedBox(height: 10),

                        NumberPad(onNumberSelected: _onUserInput),
                      ],
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _scoreBox({required String label, required int score}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.yellow)),
        Text('$score', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}
