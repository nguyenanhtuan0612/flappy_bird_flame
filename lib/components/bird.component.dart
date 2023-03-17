import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';

class BirdComponent extends RiveComponent with HasGameRef {
  final Artboard birdArtBoard;
  late OneShotAnimation birdController;

  BirdComponent({
    required this.birdArtBoard,
  }) : super(
          artboard: birdArtBoard,
          size: Vector2(38, 27),
          anchor: Anchor.bottomLeft,
        );

  late double bgHeight;
  late double a = bgHeight / 33;
  late double v = -bgHeight / 100;
  late double tempY = y;

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
    if (!birdController.isActive) {
      birdController.reset();
    }
    v = v + (a * dt);
    tempY = y;
    tempY += v;
    if (tempY < bgHeight) {
      y += v;
    } else {
      y = bgHeight;
    }

    if (y < 27) {
      y = 27;
    }
  }
}
