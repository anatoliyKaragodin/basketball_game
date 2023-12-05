import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';

import 'my_game.dart';

enum PlayerState { idle, withBall1 }

class MyPlayer extends SpriteAnimationGroupComponent
    with HasGameRef<MyGame>, TapCallbacks {
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation withBallAnimation;

  final double stepTime = 0.1;
  final double stepTimeWithBall = 0.15;

  late final List<String> idleAnimationImgList;
  late final List<String> withAnimationImgList;

  MyPlayer({
    required this.idleAnimationImgList,
    required this.withAnimationImgList,
  });
  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations(idleAnimationImgList, withAnimationImgList);
    setCurrentAnimation();
    add(RectangleHitbox());

    return super.onLoad();
  }

  Future<void> _loadAllAnimations(
      List<String> idleImagesList, List<String> withBallImagesList) async {
    final idleImages1 = await Future.wait(
      idleImagesList.map((imagePath) => Flame.images.load(imagePath)),
    );
    final withBallImages = await Future.wait(
      withBallImagesList.map((imagePath) => Flame.images.load(imagePath)),
    );
    final size = Vector2(200, 200);

    final spriteFrames = idleImages1
        .map((image) =>
            SpriteAnimationFrame(Sprite(image, srcSize: size), stepTime))
        .toList();

    final spriteFramesWithBall = withBallImages
        .map((image) => SpriteAnimationFrame(
            Sprite(image, srcSize: size), stepTimeWithBall))
        .toList();

    idleAnimation = SpriteAnimation(spriteFrames, loop: true);
    withBallAnimation = SpriteAnimation(spriteFramesWithBall, loop: true);

    /// Animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.withBall1: withBallAnimation
    };

    // /// Set current animation
    // current = PlayerState.idle;
  }

  void setCurrentAnimation() {
    current = PlayerState.idle;
  }
}
