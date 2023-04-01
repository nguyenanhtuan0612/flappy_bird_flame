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
  var increase = false;

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
    if (gameRef.state == 'ready') {
      gameRef.remove(this);
      gameRef.birdComponent.pipeComponent = null;
    }

    if (gameRef.state == 'playing') {
      pipeX -= gameRef.speed;
      pipeUp.x = pipeX;
      pipeDown.x = pipeX;

      if (gameRef.birdComponent.x + gameRef.birdComponent.width > pipeX &&
          gameRef.birdComponent.x < pipeX + widthPipe) {
        gameRef.birdComponent.pipeComponent = this;
      }
      if (gameRef.birdComponent.x >= pipeX + widthPipe) {
        gameRef.birdComponent.pipeComponent = null;
      }

      if (gameRef.birdComponent.x > pipeX + widthPipe && !addPoint) {
        gameRef.score += 1;
        if (gameRef.highScore < gameRef.score) {
          gameRef.highScore = gameRef.score;
        }
        addPoint = true;
        if (gameRef.score % 5 == 0 &&
            gameRef.score != 0 &&
            gameRef.increaseSpeed == false) {
          gameRef.increaseSpeed = true;
        }
      }
      if (pipeX < -widthPipe) {
        gameRef.remove(this);
      }
    }

    return super.update(dt);
  }
}
