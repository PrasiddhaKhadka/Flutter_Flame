import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with TapDetector {
  static final fpsTextPaint = TextPaint(
    style: const TextStyle(
      color: Colors.white,
      fontSize: 24.0,
    ),
  );

  double _dt = 0.0; // store last delta time

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    print('Game Loaded');
  }

  @override
  void update(double dt) {
    super.update(dt);
    _dt = dt; // keep latest dt
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawPaint(Paint()..color = Colors.blue);

    // calculate FPS safely
    double fpsValue = _dt > 0 ? (1 / _dt) : 0.0;
    var stringFormattedFPS = NumberFormat("##0.00", "en_US");
    String fps = stringFormattedFPS.format(fpsValue);

    // render FPS text
    fpsTextPaint.render(canvas, 'FPS: $fps', Vector2(10, 10));
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    print('Screen Tapped at: ${info.eventPosition.widget.x}, ${info.eventPosition.widget.y}');
  }
}
