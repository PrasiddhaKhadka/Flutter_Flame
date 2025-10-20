import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_flame/Galaxy_defender/bullet.dart';
import 'package:flutter_flame/Galaxy_defender/galaxy_defender.dart'; // Import your game class

class Enemy extends SpriteComponent with HasGameRef<GalaxyDefender>, CollisionCallbacks {
  final double speed = 150;
  static final Random _random = Random();

  Enemy() : super(size: Vector2.all(50));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('enemy.png');
    position = Vector2(
      _random.nextDouble() * (gameRef.size.x - size.x),
      -size.y, // start above screen
    );

    // Add a hitbox
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;

    if (position.y > gameRef.size.y) {
      removeFromParent(); // Remove when off screen
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Bullet) {
      removeFromParent(); // remove enemy
      other.removeFromParent(); // remove bullet
      gameRef.incrementScore(); // update score - now it knows about GalaxyDefender
    }
  }
}