import 'dart:developer';

import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame_rive/flame_rive.dart';

import 'components/background.component.dart';
import 'components/base.component.dart';
import 'components/bird.component.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(GameWidget(game: MyGame()));
}

T? _ambiguate<T>(T? value) => value;

class MyGame extends FlameGame with HasTappables {
  late double bgHeight;
  late BirdComponent birdComponent;
  late BackgroundComponent bgComponent;
  late BaseComponent baseComponent;
  var state = 'ready';

  Future<void> onLoad() async {
    await super.onLoad();
    final screenWidth = size[0];
    final screenHeight = size[1];
    bgHeight = screenHeight - (screenWidth * 162 / 500);

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

    baseComponent = BaseComponent(
        artBoard: baseArtBoard,
        screenHeight: screenHeight,
        screenWidth: screenWidth);
    add(baseComponent);

    birdComponent = BirdComponent(birdArtBoard: birdArtBoard);
    add(birdComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
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

          break;
        }
      case 'playing':
        {
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
          birdComponent.a = 0;
          birdComponent.v = 0;
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
}
