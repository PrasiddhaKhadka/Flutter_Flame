import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flame/Galaxy_defender/bullet.dart';

class Player extends SpriteComponent
    with HasGameRef, KeyboardHandler, DragCallbacks {
  final double moveSpeed = 300; // pixels per second
  Vector2 velocity = Vector2.zero();

  double bulletCooldown = 0.3; // seconds between shots
  double _timeSinceLastShot = 0;
  
  // Auto-fire for mobile
  bool autoFire = true; // Set to true for continuous firing

  Player() : super(size: Vector2.all(64));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player.png');
    position = gameRef.size / 2 - size / 2;
    print('Player loaded at position: $position'); // Debug
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update cooldown timer
    _timeSinceLastShot += dt;

    // Auto-fire continuously for mobile
    if (autoFire && _timeSinceLastShot >= bulletCooldown) {
      fireBullet();
      _timeSinceLastShot = 0;
    }

    // Move
    position += velocity * dt;

    // Keep player inside bounds
    position.clamp(
      Vector2.zero(),
      gameRef.size - size,
    );
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Update velocity based on currently pressed keys
    velocity = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      velocity.x = -moveSpeed;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      velocity.x = moveSpeed;
    }

    // Manual fire with spacebar for desktop (optional)
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.space &&
        !autoFire && // Only if auto-fire is disabled
        _timeSinceLastShot >= bulletCooldown) {
      print('Firing bullet!'); // Debug print
      fireBullet();
      _timeSinceLastShot = 0;
    }

    return true;
  }

  void fireBullet() async {
    final bulletStart = position + Vector2(size.x / 2 - 5, -20);
    final bullet = Bullet(position: bulletStart);
    
    try {
      await gameRef.add(bullet);
    } catch (e) {
      print('Error adding bullet: $e');
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position.add(event.localDelta);
  }
}