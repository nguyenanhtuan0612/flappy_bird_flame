import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';

class BackgroundComponent extends RiveComponent with HasGameRef {
  final Artboard artBoard;
  late OneShotAnimation backgroundController;

  BackgroundComponent({required this.artBoard, required height, required width})
      : super(
            artboard: artBoard,
            size: Vector2(width, height),
            fit: BoxFit.cover);

  @override
  Future<void> onLoad() async {
    backgroundController = OneShotAnimation('Timeline 1', autoplay: false);
    artBoard.addController(backgroundController);
    super.onLoad();
  }
}
