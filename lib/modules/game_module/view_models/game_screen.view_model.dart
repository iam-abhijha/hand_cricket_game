import 'dart:math';
import 'dart:ui';
import 'package:hand_cricket_game/modules/game_module/enums/game.enums.dart';
import 'package:hand_cricket_game/shared/constants.dart';
import 'package:scoped_model/scoped_model.dart';

/// GameViewModel manages the state and logic for a Hand Cricket game.
class GameViewModel extends Model {
  /// Current score of the player
  int playerScore = 0;

  /// Current score of the bot (computer)
  int botScore = 0;

  /// Number of balls played in the current innings
  int ballsPlayed = 0;

  /// Maximum number of balls allowed per innings
  final int maxBalls = GameConstants.maxBallsAllowed;

  /// Current phase of the game (idle, batting, bowling, finished)
  GamePhase currentPhase = GamePhase.idle;

  /// Current event in the game (none, six, out, win, lose, draw)
  GameEvent currentEvent = GameEvent.none;

  /// Flag indicating if the player is out
  bool isPlayerOut = false;

  /// Flag indicating if the bot is out
  bool isBotOut = false;

  /// Random number generator for bot's decisions
  final Random _random = Random();

  /// Initializes a new instance of GameViewModel
  GameViewModel();

  /// Resets and starts a new game with initial values
  void startGame() {
    playerScore = 0;
    botScore = 0;
    ballsPlayed = 0;
    currentPhase = GamePhase.batting;
    isPlayerOut = false;
    isBotOut = false;
    currentEvent = GameEvent.none;
    notifyListeners();
  }

  /// Handles player input (1-6) during batting or bowling
  ///
  /// @param userInput The number chosen by the player (1-6)
  void handleUserInput(int userInput) {
    int botChoice = _random.nextInt(6) + 1;
    if (currentPhase == GamePhase.batting) {
      _playerBat(userInput, botChoice);
    } else if (currentPhase == GamePhase.bowling) {
      _botBat(botChoice, userInput);
    }
    notifyListeners();
  }

  /// Handles timeout event when player takes too long to respond
  void handleTimeout() {
    currentPhase = GamePhase.finished;
    _setEventWithDelay(GameEvent.lose);
    notifyListeners();
  }

  /// Processes player's batting turn
  ///
  /// @param userRun Player's chosen number
  /// @param botBowl Bot's bowling number
  void _playerBat(int userRun, int botBowl) {
    if (userRun == botBowl) {
      isPlayerOut = true;
      currentPhase = GamePhase.bowling;
      ballsPlayed = 0; // Reset for bot
      _setEventWithDelay(GameEvent.out);
    } else {
      playerScore += userRun;
      ballsPlayed++;
      if (userRun == 6) {
        _setEventWithDelay(GameEvent.six);
      } else {
        currentEvent = GameEvent.none;
      }
      if (ballsPlayed >= maxBalls) {
        currentPhase = GamePhase.bowling;
        ballsPlayed = 0; // Reset for bot
      }
    }
  }

  /// Processes bot's batting turn
  ///
  /// @param botRun Bot's batting number
  /// @param userBowl Player's bowling number
  void _botBat(int botRun, int userBowl) async {
    if (botRun == userBowl) {
      isBotOut = true;
      _setEventWithDelay(GameEvent.out, onComplete: _endGame);
      return;
    }

    botScore += botRun;
    ballsPlayed++;

    if (botRun == 6) {
      _setEventWithDelay(GameEvent.six);
    }

    await Future.delayed(const Duration(seconds: 1));

    if (botScore > playerScore || ballsPlayed >= maxBalls) {
      _endGame();
    } else {
      currentEvent = GameEvent.none;
    }
  }

  /// Ends the game and determines the winner
  void _endGame() {
    currentPhase = GamePhase.finished;
    if (botScore < playerScore) {
      currentEvent = GameEvent.win;
    } else if (botScore > playerScore) {
      currentEvent = GameEvent.lose;
    } else {
      currentEvent = GameEvent.draw;
    }
    notifyListeners();
  }

  /// Sets a game event with optional delay and completion callback
  ///
  /// @param event The GameEvent to set
  /// @param onComplete Optional callback to execute after delay
  void _setEventWithDelay(GameEvent event, {VoidCallback? onComplete}) {
    currentEvent = event;
    notifyListeners();
    if (event == GameEvent.six || event == GameEvent.out) {
      Future.delayed(const Duration(seconds: 1), () {
        if (currentEvent == event) {
          currentEvent = GameEvent.none;
          notifyListeners();
          if (onComplete != null) onComplete();
        }
      });
    } else {
      if (onComplete != null) onComplete();
    }
  }

  /// Gets the appropriate center image asset path based on current game state
  ///
  /// @return String Path to the image asset
  String get centerImage {
    switch (currentEvent) {
      case GameEvent.six:
        return 'assets/images/sixer.png';
      case GameEvent.out:
        return 'assets/images/out.png';
      case GameEvent.win:
        return 'assets/images/won.png';
      case GameEvent.lose:
        return 'assets/images/lost.png';
      case GameEvent.draw:
        return 'assets/images/draw.png';
      default:
        return currentPhase == GamePhase.batting ? 'assets/images/batting.png' : 'assets/images/game_defend.png';
    }
  }
}
