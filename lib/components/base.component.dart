import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';

class BaseComponent extends RiveComponent with HasGameRef {
  final Artboard artBoard;
  final double screenWidth;
  final double screenHeight;
  late OneShotAnimation baseController;

  BaseComponent(
      {required this.artBoard,
      required this.screenWidth,
      required this.screenHeight})
      : super(
          artboard: artBoard,
          size: Vector2(screenWidth, screenWidth * 162 / 500),
          anchor: Anchor.bottomLeft,
        );

  @override
  Future<void> onLoad() async {
    baseController = OneShotAnimation('Timeline 1', autoplay: false);
    artBoard.addController(baseController);
    super.onLoad();
    y = screenHeight;
  }
}
