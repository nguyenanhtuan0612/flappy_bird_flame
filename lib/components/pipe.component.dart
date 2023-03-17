import 'package:flame/components.dart';
import 'package:flappy_bird_flame/components/bird.component.dart';
import 'package:flappy_bird_flame/main.dart';

class PipeComponent extends Component with HasGameRef<MyGame> {
  late Sprite pipeSprite;
  late SpriteComponent pipeUp;
  late SpriteComponent pipeDown;
  late double pipeY;
  late double pipeX;
  late double screenWidth;
  late BirdComponent bird;
  late double widthPipe;
  bool addPoint = false;
  PipeComponent({
    required this.pipeSprite,
    required this.screenWidth,
    required this.pipeY,
    required this.bird,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    widthPipe = screenWidth / 5;
    var heightPipe = widthPipe * 147 / 22;
    pipeX = screenWidth;

    pipeUp = SpriteComponent(sprite: pipeSprite);
    pipeUp.x = pipeX;
    pipeUp.size = Vector2(widthPipe, heightPipe);
    pipeUp.y = pipeY + 70;
    add(pipeUp);

    pipeDown = SpriteComponent(sprite: pipeSprite);
    pipeDown.x = pipeX;
    pipeDown.y = pipeY - 70;
    pipeDown.size = Vector2(widthPipe, heightPipe);
    pipeDown.flipVertically();
    add(pipeDown);
  }

  @override
  void update(double dt) {
    // TODO: implement update
    if (gameRef.state == 'ready') {
      gameRef.remove(this);
    }

    if (gameRef.state == 'playing') {
      pipeX -= 2;
      pipeUp.x = pipeX;
      pipeDown.x = pipeX;

      if ((gameRef.birdComponent.x + gameRef.birdComponent.width > pipeX &&
              gameRef.birdComponent.y - gameRef.birdComponent.height <
                  pipeY - 70 &&
              gameRef.birdComponent.x < pipeX + widthPipe) ||
          (gameRef.birdComponent.x + gameRef.birdComponent.width > pipeX &&
              gameRef.birdComponent.y > pipeY + 70 &&
              gameRef.birdComponent.x < pipeX + widthPipe)) {
        gameRef.state = 'gameOver';
      }
      if (gameRef.birdComponent.x > pipeX + widthPipe && !addPoint) {
        print(gameRef.score);
        gameRef.score += 1;
        addPoint = true;
      }
      if (pipeX < -widthPipe) {
        gameRef.remove(this);
      }
    }

    return super.update(dt);
  }
}
