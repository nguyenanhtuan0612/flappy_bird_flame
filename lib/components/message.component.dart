import 'package:flame/components.dart';
import 'package:flappy_bird_flame/main.dart';
import 'package:flutter/material.dart';

class MessageComponent extends Component with HasGameRef<MyGame> {
  late Sprite spriteReady;
  late double screenWidth;
  late double screenHeight;
  late SpriteComponent readyMsg;
  late SpriteComponent gameOverMsg;
  late SpriteComponent scoreBoard;
  late TextComponent hScore;
  late TextComponent score;
  late bool display = false;
  late bool displayGameOver = false;
  MessageComponent({
    required this.spriteReady,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    readyMsg = SpriteComponent(
      sprite: spriteReady,
      anchor: Anchor.center,
      position: Vector2(
        screenWidth / 2,
        screenHeight / 2,
      ),
    );
    readyMsg.width = screenWidth * 6 / 10;
    readyMsg.height = readyMsg.width * 267 / 184;

    gameOverMsg = SpriteComponent(
      sprite: await gameRef.loadSprite('gameover.png'),
      anchor: Anchor.center,
      position: Vector2(
        screenWidth / 2,
        screenHeight * 2 / 10,
      ),
    );

    scoreBoard = SpriteComponent(
        sprite: await gameRef.loadSprite('scoreboard@2x.png'),
        anchor: Anchor.center,
        position: Vector2(
          screenWidth / 2,
          screenHeight * 4 / 10,
        ));
    scoreBoard.width = screenWidth * 8 / 10;
    scoreBoard.height = scoreBoard.width / 2;

    final yourScoreText = TextComponent(
        text: 'Your score:',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontFamily: 'FlappyBird',
            fontSize: 24,
            color: Color.fromRGBO(224, 128, 50, 1),
          ),
        ),
        position:
            Vector2(scoreBoard.width * 2 / 10, scoreBoard.height * 2 / 10));
    scoreBoard.add(yourScoreText);

    final highScoreText = TextComponent(
        text: 'High score:',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontFamily: 'FlappyBird',
            fontSize: 24,
            color: Color.fromRGBO(224, 128, 50, 1),
          ),
        ),
        anchor: Anchor.bottomLeft,
        position:
            Vector2(scoreBoard.width * 2 / 10, scoreBoard.height * 8 / 10));
    scoreBoard.add(highScoreText);
  }

  @override
  void update(double dt) {
    switch (gameRef.state) {
      case 'ready':
        {
          if (!display) {
            gameRef.add(readyMsg);
            display = true;
          }
          if (displayGameOver) {
            scoreBoard.removeAll([score, hScore]);
            gameRef.remove(gameOverMsg);
            gameRef.remove(scoreBoard);
            displayGameOver = false;
          }
          break;
        }
      case 'playing':
        {
          if (display) {
            gameRef.remove(readyMsg);
            display = false;
          }
          break;
        }
      case 'gameOver':
        {
          print('3, ${gameRef.highScore}');
          if (!displayGameOver) {
            addScoreBoard(gameRef.highScore, gameRef.score);
            gameRef.add(gameOverMsg);
            gameRef.add(scoreBoard);

            displayGameOver = true;
          }
          break;
        }
    }

    return super.update(dt);
  }

  void addScoreBoard(int highScoreigh, int gameScore) {
    hScore = TextComponent(
        text: '$highScoreigh',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontFamily: 'FlappyBird',
            fontSize: 24,
            color: Color.fromRGBO(243, 240, 238, 1),
          ),
        ),
        anchor: Anchor.bottomRight,
        position:
            Vector2(scoreBoard.width * 7 / 10, scoreBoard.height * 8 / 10));
    scoreBoard.add(hScore);

    score = TextComponent(
        text: '$gameScore',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontFamily: 'FlappyBird',
            fontSize: 24,
            color: Color.fromRGBO(243, 240, 238, 1),
          ),
        ),
        anchor: Anchor.topRight,
        position:
            Vector2(scoreBoard.width * 7 / 10, scoreBoard.height * 2 / 10));
    scoreBoard.add(score);
  }
}
