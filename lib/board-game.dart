import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

import 'package:flutter/gestures.dart';

import 'controller.dart';
import 'player-ship.dart';
import 'rock.dart';

class BoardGame extends Game {

  Size screenSize;
  double tileSize;

  Controller controller;
  PlayerShip playerShip;
  Rock rock;

  Sprite gameBackgroundSprite;

  BoardGame() {
    initialize();
    gameBackgroundSprite = Sprite('darkNebulaPath.png');
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());

    controller = Controller(this);
    playerShip = PlayerShip(this);
    rock = Rock(this);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.height / 9; // 9:16 ratio
  }

  @override
  void render(Canvas canvas) {
    gameBackgroundSprite.render(canvas);
    controller.render(canvas);
    playerShip.render(canvas);
    rock.render(canvas);
  }

  @override
  void update(double t) {
    controller.update(t);
    playerShip.update(t);
    // rock.update(t);
  }

  void onPanStart(DragStartDetails details) {
    controller.onPanStart(details);
  }

  void onPanUpdate(DragUpdateDetails details) {
    controller.onPanUpdate(details);
  }

  void onPanEnd(DragEndDetails details) {
    controller.onPanEnd(details);
  }

}