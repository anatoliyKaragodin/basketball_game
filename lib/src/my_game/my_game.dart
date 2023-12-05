import 'dart:async';

import 'package:basketball_game/src/app/pages/game_field_page/controller/game_page_controller.dart';
import 'package:basketball_game/src/my_game/level.dart';
import 'package:basketball_game/src/utils/library.dart';
import 'package:basketball_game/src/utils/my_parameters.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyGame extends FlameGame with HasCollisionDetection, HasGameRef<MyGame> {
  final WidgetRef ref;
  final BuildContext context;
  late bool gameFinished;
  late bool stopGame;
  late bool isScoreSend;

  MyGame(
      {required this.ref,
      required this.gameFinished,
      required this.stopGame,
      required this.context});
  // bool gameFinished = false;
  List<int> scoreList = [];
  late final CameraComponent cam;
  final world = Level();
  final mainMenu = 'Main menu';

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    isScoreSend = false;

    cam = CameraComponent.withFixedResolution(
        width: 720, height: 1280, world: world);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);
    // overlays.add(mainMenu);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    sendMatchEndAndScores();
    startMatch();
    super.update(dt);
  }

  void sendMatchEndAndScores() {
    if (gameFinished && !isScoreSend) {
      isScoreSend = true;
      stopGame = true;
      GameControl.onMatchEnd(ref, scoreList, context);
    }
  }

  void startMatch() {
    if (!stopGame && !gameFinished && !isScoreSend) {
      debugPrint('START MATCH');
      gameRef.world.matchIsEnded = false;
      // GameControl.changeStopGame(ref, false, false);
    }
  }
}
