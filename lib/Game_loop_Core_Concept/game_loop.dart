import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame/Game_loop_Core_Concept/player.dart';
import 'enemy.dart'; // You'll create this next (simple Enemy component)

class MyGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  late final World world;
  late final Rect worldBounds;
  late final CameraComponent cameraComponent;
  late final Player player;

  // ------------------------------
  // Game State Variables
  // ------------------------------
  final List<Enemy> enemies = [];
  late Timer spawnTimer;
  bool gameOverTriggered = false;
  int score = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1️⃣ Setup World + Camera
    world = World();
    add(world);

    cameraComponent = CameraComponent(world: world)
      ..viewfinder.anchor = Anchor.center;
    add(cameraComponent);

    // Set visible game area
    Future.microtask(() {
      cameraComponent.viewfinder.visibleGameSize = Vector2(800, 600);
    });

    // 2️⃣ Background
    final background = await loadSprite('background.jpg');
    world.add(SpriteComponent(sprite: background, size: size));

    // 3️⃣ Player
    player = Player()..position = Vector2(100, 200);
    world.add(player);

    // 4️⃣ Camera follow
    cameraComponent.follow(player);

    // 5️⃣ Spawn timer setup
    spawnTimer = Timer(3, onTick: spawnEnemy, repeat: true);
    spawnTimer.start();

    // 6️⃣ Initialize world bounds (for debugging)
    worldBounds = Rect.fromLTWH(0, 0, 2000, 2000);

    // 7️⃣ HUD
    add(
      HudMarginComponent(
        margin: const EdgeInsets.all(10),
        children: [
          TextComponent(
            text: 'Score: 0',
            textRenderer: TextPaint(
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );

    print('✅ Game initialized successfully.');
  }

  // ------------------------------
  // 🔁 Main Game Loop
  // ------------------------------
  @override
  void update(double dt) {
    super.update(dt);

    if (gameOverTriggered) return;

    // 1️⃣ Move player (frame-rate independent)
    player.position += player.velocity * dt;

    // Keep player within world bounds
    player.position.x = player.position.x.clamp(0, worldBounds.width - player.size.x);
    player.position.y = player.position.y.clamp(0, worldBounds.height - player.size.y);

    // 2️⃣ Update timers (enemy spawns, etc.)
    spawnTimer.update(dt);

    // 3️⃣ Collision detection (manual)
    for (final enemy in enemies) {
      if (player.toRect().overlaps(enemy.toRect())) {
        player.takeDamage(10);
        enemy.removeFromParent(); // destroy enemy on collision
      }
    }

    // 4️⃣ Update score or game logic
    score += (dt * 10).toInt(); // Example: increase over time

    // 5️⃣ Check for Game Over
    if (player.health <= 0 && !gameOverTriggered) {
      gameOver();
    }

    // 6️⃣ Update enemies
    for (final enemy in enemies) {
      enemy.update(dt);
    }
  }

  // ------------------------------
  // 🧩 Enemy Spawning
  // ------------------------------
  void spawnEnemy() {
    final rand = Random();
    final enemy = Enemy()
      ..position = Vector2(rand.nextDouble() * 1800, rand.nextDouble() * 1800);
    enemies.add(enemy);
    world.add(enemy);
  }

  // ------------------------------
  // 💀 Game Over Logic
  // ------------------------------
  void gameOver() {
    gameOverTriggered = true;
    pauseEngine();
    overlays.add('GameOver');
    print('💀 Game Over! Final score: $score');
  }

  // ------------------------------
  // 🧭 Debug Rendering
  // ------------------------------
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (debugMode) {
      final paint = Paint()
        ..color = Colors.red.withOpacity(0.3)
        ..style = PaintingStyle.stroke;
      canvas.drawRect(worldBounds, paint);

      // Draw player direction vector
      if (player.velocity.length > 0) {
        canvas.drawLine(
          player.position.toOffset(),
          (player.position + player.velocity.normalized() * 50).toOffset(),
          Paint()..color = Colors.yellow,
        );
      }
    }
  }
}
