import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Player extends SpriteComponent with HasGameRef<FlameGame> {
  Vector2 velocity = Vector2.zero();
  final double speed = 200; // pixels per second
  int health = 100; // add health

  Player() : super(size: Vector2(64, 64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player.png');
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move based on velocity
    position += velocity * dt;

    // Keep player inside screen bounds
    position.clamp(Vector2.zero(), gameRef.size - size);
  }

  // Add this method to allow damage
  void takeDamage([int amount = 10]) {
    health -= amount;
    if (health < 0) health = 0;
    print('Player took $amount damage. Health: $health');
  }
}
