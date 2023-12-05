import 'dart:async';

import 'package:basketball_game/src/app/pages/game_field_page/model/player.dart';
import 'package:basketball_game/src/my_game/ball.dart';
import 'package:basketball_game/src/my_game/my_game.dart';
import 'package:basketball_game/src/my_game/player.dart';
import 'package:basketball_game/src/utils/library.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import 'basketball_player.dart';

class BasketballPlayer2 extends MyPlayer with CollisionCallbacks {
  int direction = 1;
  BasketballPlayer2()
      : super(
            idleAnimationImgList: myIdleAnimationImgList,
            withAnimationImgList: myWithAnimationImgList);

  static const myIdleAnimationImgList = [
    'Team2 chel IDLE.png',
    'Team2 chel IDLE 2.png',
    'Team3 chel IDLE 3.png',
    'Team4 chel IDLE 4.png'
  ];
  static const myWithAnimationImgList = [
    'Team2 chel IDLE with ball.png',
    'Team2 chel IDLE with ball 2.png'
  ];

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // if(other is Ball) {    debugPrint('COLLISION WITH ENEMY');
    // }
    super.onCollision(intersectionPoints, other);
  }
}
