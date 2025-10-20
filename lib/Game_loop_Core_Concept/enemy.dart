import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Enemy extends SpriteComponent {
  double speed = 100;

  Enemy() : super(size: Vector2(40, 40));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player.png');
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Move enemy slowly down/right
    position += Vector2(1, 1) * speed * dt;
  }
}
