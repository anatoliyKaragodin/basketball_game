import 'dart:async';

import 'package:basketball_game/src/app/pages/game_field_page/model/player.dart';
import 'package:basketball_game/src/my_game/level.dart';
import 'package:basketball_game/src/my_game/my_game.dart';
import 'package:basketball_game/src/my_game/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';

import 'ball.dart';

class BasketballPlayer extends MyPlayer {
  // final bool withBall;
  final int number;
  int playerWithBall;
  BasketballPlayer(
      {
      // required this.withBall,
      required this.number,
      required this.playerWithBall,})
      : super(
            idleAnimationImgList: myIdleAnimationImgList,
            withAnimationImgList: myWithAnimationImgList);

  static const myIdleAnimationImgList = [
    'Team1 chel IDLE.png',
    'Team1 chel IDLE 2.png',
    'Team1 chel IDLE 3.png',
    'Team1 chel IDLE 4.png'
  ];
  static const myWithAnimationImgList = [
    'Team1 chel IDLE with ball.png',
    'Team1 chel IDLE with ball 2.png'
  ];



  @override
  void setCurrentAnimation() {
    if (playerWithBall == number) {
      current = PlayerState.withBall1;
    } else {
      current = PlayerState.idle;
    }
  }

  @override
  void update(double dt) {
    setCurrentAnimation();
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    var newBallPosition = position.clone();
    newBallPosition.add(Vector2(24, 40));
    if(gameRef.world.ball.ballState!=BallState.movingToPlayer) {
      gameRef.world.ball.ballTargetPosition = newBallPosition;
    }
    gameRef.world.playerWithBallIndex = number;

    current = PlayerState.withBall1;
  }


}
