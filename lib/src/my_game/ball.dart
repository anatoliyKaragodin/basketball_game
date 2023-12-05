import 'dart:async';

import 'package:basketball_game/src/my_game/basketball_player2.dart';
import 'package:basketball_game/src/my_game/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';

enum BallState { stopped, movingToPlayer, startMove, collision }

class Ball extends SpriteComponent with HasGameRef<MyGame>, CollisionCallbacks {
  late SpriteComponent ball;
  late Vector2 ballTargetPosition;
  late BallState ballState;
  Ball({required this.ballTargetPosition, required this.ballState});
  @override
  FutureOr<void> onLoad() async {
    var ballImg = await Flame.images.load('Ball.png');
    sprite = Sprite(ballImg); // Set the sprite here.

    ball = SpriteComponent(sprite: sprite, size: Vector2(50, 50));
    ballState = BallState.stopped;
    add(RectangleHitbox());

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is BasketballPlayer2 && ballState != BallState.collision) {
      // debugPrint('COLLISION BALL WITH ENEMY');
      ballState = BallState.collision;
    }
    // debugPrint('COLLISION OF BALL');
    super.onCollision(intersectionPoints, other);
  }
}
