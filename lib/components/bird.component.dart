import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flappy_bird_flame/components/pipe.component.dart';
import 'package:flappy_bird_flame/main.dart';

class BirdComponent extends RiveComponent with HasGameRef<MyGame> {
  final Artboard birdArtBoard;
  PipeComponent? pipeComponent;
  late OneShotAnimation birdController;

  BirdComponent({
    required this.birdArtBoard,
  }) : super(
          artboard: birdArtBoard,
          size: Vector2(38, 27),
          anchor: Anchor.bottomLeft,
        );

  late double bgHeight;
  late double a = 0;
  late double v = 0;
  late double tempY = y;
  late double vx = 0;

  @override
  Future<void> onLoad() async {
    birdController = OneShotAnimation(
      'Timeline 1',
      autoplay: false,
    );
    birdArtBoard.addController(birdController);

    super.onLoad();
    bgHeight = gameRef.size[1] - (gameRef.size[0] * 162 / 500);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.state == 'ready') {
      a = 0;
      x = 80;
      vx = 0;
      y = bgHeight / 2;
      tempY = y;
      v = -bgHeight / 100;
    }

    if (gameRef.state == 'playing') {
      v = v + (a * dt);
      double oldY = y;
      tempY = y;
      tempY += v;

      y += v;
      if (tempY > bgHeight) {
        y = bgHeight;
      }
      x += vx;

      if (x >= 80) {
        vx = 0;
      }

      if (x <= 0) {
        vx = -vx;
      }

      if (pipeComponent != null) {
        if (x <= 0 &&
            pipeComponent!.pipeX <= width &&
            (tempY > pipeComponent!.pipeY + 70 ||
                tempY - height < pipeComponent!.pipeY - 70)) {
          gameRef.state = 'gameOver';
        }
        // Dưới
        if (x + width > pipeComponent!.pipeX &&
            tempY > pipeComponent!.pipeY + 70 &&
            x < pipeComponent!.pipeX + pipeComponent!.widthPipe) {
          if (oldY <= pipeComponent!.pipeY + 70 &&
              tempY >= pipeComponent!.pipeY + 70) {
            y = pipeComponent!.pipeY + 70;
            v = -v * 8 / 10;
          } else {
            vx = -5;
          }
        }
        // Trên
        if (x + width > pipeComponent!.pipeX &&
            tempY - height < pipeComponent!.pipeY - 70 &&
            x < pipeComponent!.pipeX + pipeComponent!.widthPipe) {
          if (oldY >= pipeComponent!.pipeY - 70 + height &&
              tempY <= pipeComponent!.pipeY - 70 + height) {
            y = pipeComponent!.pipeY - 70 + height;
            v = -v * 8 / 10;
          } else {
            vx = -5;
          }
        }

        return;
      }

      if (y < 27) {
        y = 27;
      }
    }
  }
}
