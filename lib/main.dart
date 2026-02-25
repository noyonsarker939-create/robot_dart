import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(GameWidget(game: RobotDartGame()));
}

class RobotDartGame extends FlameGame with TapDetector {
  int level = 1;
  int score = 0;
  int miss = 0;
  late Robot robot;
  late DartBoard board;

  @override
  Future<void> onLoad() async {
    board = DartBoard();
    robot = Robot();
    add(board);
    add(robot);
  }

  @override
  void onTap() {
    final random = Random();
    double hitChance = random.nextDouble();

    if (hitChance > (0.3 + level * 0.01)) {
      score += 10;
      robot.updateMood(level);
    } else {
      miss++;
    }

    if (score >= level * 100 && level < 50) {
      level++;
    }

    if (miss >= 3) {
      pauseEngine();
    }
  }
}

class DartBoard extends PositionComponent {
  DartBoard() {
    size = Vector2(250, 250);
    position = Vector2(100, 200);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.red;
    canvas.drawCircle(size.toOffset() / 2, 120, paint);
  }
}

class Robot extends PositionComponent {
  int mood = 0;

  Robot() {
    size = Vector2(100, 150);
    position = Vector2(175, 225);
  }

  void updateMood(int level) {
    mood = level ~/ 10;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = mood < 2
          ? Colors.green
          : mood < 4
              ? Colors.orange
              : Colors.grey;

    canvas.drawRect(size.toRect(), paint);
  }
}
