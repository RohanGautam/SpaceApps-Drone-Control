import 'dart:math';
import 'dart:ui';

import 'package:flame/sprite.dart';

import 'board-game.dart';
import 'clientWebsocket.dart';

class Rock {
  final BoardGame game;

  double aspectRatio = 1.4;
  double size;
  double speed = 200.0;
  Rect rect;
  Sprite sprite;

  bool move = true;
  double lastMoveRadAngle = 0.0;

  double dist=0;
  int count =1;
  var socket = ClientWebSocket();
  var scaleDistance = 10;
  var countThreshold = 50;

  Rock(this.game) {
    size = game.tileSize * aspectRatio;
    rect = Rect.fromLTWH(game.screenSize.width / 2 - (size / 2),
        game.screenSize.height / 2 - (size / 2), size, size);

    sprite = Sprite('rock.png');
  }

  void render(Canvas canvas) {
    if (count>countThreshold){
      var distStr = socket.getDataFromServer();
      print(distStr);
      if (distStr != "0.0" && distStr!=null) {
        dist = double.parse(distStr);
        dist = dist*scaleDistance;
        print('distance in render $dist');
      }
      count=0;
    }
    count+=1;
    // print('distance in render $dist');
    // Offset diffBase =
    //     Offset(rect.center.dx + dist, rect.center.dy) -
    //         rect.center;
    // rect = rect.shift(diffBase);
    // canvas.save();
    Rect rect  = Rect.fromLTWH(dist+game.screenSize.width / 2 - (size / 2),
        game.screenSize.height / 2 - (size / 2), size, size);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xffffff);
    // canvas.drawRect(rect, bgPaint);
    sprite.renderRect(canvas, rect);
    canvas.restore();
  }

  void update(double t) {
    if (move) {
      double nextX = (speed * t) * cos(lastMoveRadAngle);
      double nextY = (speed * t) * sin(lastMoveRadAngle);
      Offset nextPoint = Offset(nextX, nextY);

      Offset diffBase =
          Offset(rect.center.dx + nextPoint.dx, rect.center.dy + nextPoint.dy) -
              rect.center;
      rect = rect.shift(diffBase);
    }
  }
}
