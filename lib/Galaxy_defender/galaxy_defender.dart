import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame/Galaxy_defender/player.dart';
import 'package:flutter_flame/Game_loop_Core_Concept/enemy.dart';

class GalaxyDefender extends FlameGame 
    with HasKeyboardHandlerComponents, HasCollisionDetection {

  late Player player;

  // enemy
  double _enemySpawnTimer = 0;
  final double _enemySpawnInterval = 1.5; // seconds
  final _random = Random();

  int score = 0;

  @override
  Color backgroundColor() => const Color(0xFF000020);

  @override
  Future<void> onLoad() async {
    player = Player();
    await add(player);
    // This runs before the game starts
    print('Game loaded!');
  }

  @override
  void update(double dt) {
    // This runs every frame
    super.update(dt);

    _enemySpawnTimer += dt;

    if (_enemySpawnTimer >= _enemySpawnInterval) {
      _enemySpawnTimer = 0;
      add(Enemy());
    }
  }

  void incrementScore() {
    score += 10;
    // If you have a score overlay, you can update it like this:
    // overlays.remove('score');
    // overlays.add('score');
    print('Score: $score'); // Debug print
  }

  @override
  void render(Canvas canvas) {
    // This runs every frame to render the game
    super.render(canvas);
  }
}