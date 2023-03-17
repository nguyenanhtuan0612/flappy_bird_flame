import 'package:flutter/foundation.dart';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame_rive/flame_rive.dart';

import 'components/background.component.dart';
import 'components/base.component.dart';
import 'components/bird.component.dart';
import 'components/pipe.component.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with HasTappables {
  late double bgHeight;
  late BirdComponent birdComponent;
  late BackgroundComponent bgComponent;
  late BaseComponent baseComponent;
  double time = 2.4;
  late double timeToAdd = 0;
  late double screenWidth;
  late TextComponent scoreTextComponent;
  var state = 'ready';
  var score = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    screenWidth = size[0];
    final screenHeight = size[1];

    bgHeight = screenHeight - (screenWidth * 162 / 500);

    scoreTextComponent = TextComponent(
      text: '$score',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(screenWidth / 2, 50),
    );
    scoreTextComponent.priority = 4;
    add(scoreTextComponent);

    Artboard birdArtBoard =
        await loadArtboard(RiveFile.asset('assets/bird.riv'));

    Artboard bgArtBoard =
        await loadArtboard(RiveFile.asset('assets/background.riv'));

    Artboard baseArtBoard =
        await loadArtboard(RiveFile.asset('assets/base.riv'));

    bgComponent = BackgroundComponent(
        artBoard: bgArtBoard, width: screenWidth, height: bgHeight + 1);
    var bgController = OneShotAnimation('Timeline 1', autoplay: false);
    bgArtBoard.addController(bgController);
    add(bgComponent);

    birdComponent = BirdComponent(birdArtBoard: birdArtBoard);
    birdComponent.priority = 3;

    baseComponent = BaseComponent(
        artBoard: baseArtBoard,
        screenHeight: screenHeight,
        screenWidth: screenWidth);
    baseComponent.priority = 2;
    add(baseComponent);

    add(birdComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    scoreTextComponent.text = '$score';
    switch (state) {
      case 'ready':
        {
          birdComponent.birdController.isActive = true;
          baseComponent.baseController.isActive = true;
          bgComponent.backgroundController.isActive = true;
          birdComponent.a = 0;
          birdComponent.v = 0;
          birdComponent.x = 50;
          birdComponent.y = bgHeight / 2;
          birdComponent.v = -bgHeight / 100;
          timeToAdd = 0;
          score = 0;
          break;
        }
      case 'playing':
        {
          timeToAdd += dt;
          if (time < timeToAdd) {
            createPipe(screenWidth, bgHeight);
            timeToAdd = 0;
          }

          birdComponent.a = bgHeight / 33;
          birdComponent.birdController.isActive = true;
          baseComponent.baseController.isActive = true;
          bgComponent.backgroundController.isActive = true;
          if (birdComponent.y >= bgHeight) {
            state = 'gameOver';
          }
          break;
        }
      case 'gameOver':
        {
          birdComponent.birdController.isActive = false;
          baseComponent.baseController.isActive = false;
          bgComponent.backgroundController.isActive = false;
          birdComponent.a = bgHeight / 33;
          break;
        }
    }
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    switch (state) {
      case 'ready':
        {
          state = 'playing';
          createPipe(screenWidth, bgHeight);
          break;
        }
      case 'playing':
        {
          birdComponent.v = -bgHeight / 100;
          break;
        }
      case 'gameOver':
        {
          state = 'ready';
          break;
        }
    }
  }

  void createPipe(double screenWidth, double bgHieght) async {
    Random rnd;
    double min = 250;
    double max = bgHieght - 250;
    rnd = new Random();
    double r = min + rnd.nextDouble() * (max - min);

    PipeComponent pipeComponent = PipeComponent(
      pipeSprite: await loadSprite('NicePng_pipes-png_388476.png'),
      screenWidth: screenWidth,
      pipeY: r,
      bird: birdComponent,
    );
    add(pipeComponent);
  }
}
