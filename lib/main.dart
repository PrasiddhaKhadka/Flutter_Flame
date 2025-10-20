import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame/Galaxy_defender/galaxy_defender.dart';
import 'package:flutter_flame/Game_loop_Core_Concept/game_loop.dart';
import 'package:intl/intl.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  final game = GalaxyDefender();
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Focus(
          autofocus: true,
          child: GameWidget(
            game: GalaxyDefender(),
            overlayBuilderMap: {
              'score': (BuildContext context, GalaxyDefender game) {
                return Positioned(
                  top: 20,
                  left: 20,
                  child: Text(
                    'Score: ${game.score}',
                    style: const TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.red
                      ,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            },
          ),
        ),
      ),
    ),
  );

}




//
// Simple component shape example of a square component
class Square extends PositionComponent {
  //
  // default values
  //

  // velocity is 0 here
  var velocity = Vector2(0, 0).normalized() * 25;
  // large square
  var squareSize = 128.0;
  // colored white with no-fill and an outline strike
  var color = BasicPalette.white.paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;

  @override
  //
  // initialize the component
  Future<void> onLoad() async {
    super.onLoad();
    size.setValues(squareSize, squareSize);
    anchor = Anchor.topRight;
  }

  @override
  //
  // update the inner state of the shape
  // in our case the position based on velocity
  void update(double dt) {
    super.update(dt);
    // speed is refresh frequency independent
    position += velocity * dt;
  }

  @override
  //
  // render the shape
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), color);
  }
}

//
//
// The game class
class ComponentExample001 extends FlameGame
    with DoubleTapDetector, TapDetector {
  bool running = true;

  @override
  //
  //
  // Process user's single tap (tap up)
  void onTapUp(TapUpInfo info) {
    // location of user's tap
    final touchPoint = info.eventPosition.global;


    //
    // handle the tap action
    //
    // check if the tap location is within any of the shapes on the screen
    // and if so remove the shape from the screen
    final handled = children.any((component) {
      if (component is Square && component.containsPoint(touchPoint)) {
        // remove(component);
        component.velocity.negate();
        return true;
      }
      return false;
    });

    //
    // this is a clean location with no shapes
    // create and add a new shape to the component tree under the FlameGame
    if (!handled) {
      add(Square()
        ..position = touchPoint
        ..squareSize = 45.0
        ..velocity = Vector2(0, 1).normalized() * 50
        ..color = (BasicPalette.red.paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2));
    }
  }

  @override
  void onDoubleTap() {
    if (running) {
      pauseEngine();
    } else {
      resumeEngine();
    }

    running = !running;
  }
}


// class MyGame extends FlameGame with TapDetector {
//   static final fpsTextPaint = TextPaint(
//     style: const TextStyle(
//       color: Colors.white,
//       fontSize: 24.0,
//     ),
//   );

//   double _dt = 0.0; // store last delta time

//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();
//     print('Game Loaded');
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     _dt = dt; // keep latest dt
//   }

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);
//     canvas.drawPaint(Paint()..color = Colors.blue);

//     // calculate FPS safely
//     double fpsValue = _dt > 0 ? (1 / _dt) : 0.0;
//     var stringFormattedFPS = NumberFormat("##0.00", "en_US");
//     String fps = stringFormattedFPS.format(fpsValue);

//     // render FPS text
//     fpsTextPaint.render(canvas, 'FPS: $fps', Vector2(10, 10));
//   }

//   @override
//   void onTapDown(TapDownInfo info) {
//     super.onTapDown(info);
//     print('Screen Tapped at: ${info.eventPosition.widget.x}, ${info.eventPosition.widget.y}');
//   }
// }
