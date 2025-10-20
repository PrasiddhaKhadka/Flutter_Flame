import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Bullet extends SpriteComponent with HasGameReference , CollisionCallbacks {
  final double speed = 500; // pixels per second

  Bullet({required Vector2 position})
      : super(
          size: Vector2(10, 30),
          position: position,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    print('Bullet onLoad called'); // Debug
    try {
      sprite = await game.loadSprite('bullet.png');
      print('Bullet sprite loaded successfully');

       add(RectangleHitbox());
    } catch (e) {
      print('Failed to load bullet sprite: $e');
      // Fallback to colored rectangle
      paint = Paint()..color = Colors.yellow;
    }
  }

  @override
  void render(Canvas canvas) {
    if (sprite != null) {
      super.render(canvas);
    } else {
      // Draw fallback rectangle
      canvas.drawRect(size.toRect(), paint);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= speed * dt;

    // Remove bullet if it goes off screen
    if (position.y + size.y < 0) {
      print('Bullet removed from screen');
      removeFromParent();
    }
  }
}