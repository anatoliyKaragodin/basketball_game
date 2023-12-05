import 'dart:async';
import 'dart:math';
import 'package:basketball_game/src/app/pages/game_field_page/controller/game_page_controller.dart';
import 'package:basketball_game/src/my_game/basketball_player.dart';
import 'package:basketball_game/src/my_game/basketball_player2.dart';
import 'package:basketball_game/src/my_game/my_game.dart';
import 'package:basketball_game/src/my_game/player.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ball.dart';

class Level extends World with HasCollisionDetection, HasGameRef<MyGame> {
  late bool continueMatchReady;
  late int playerWithBallIndex;
  late SpriteComponent background;
  late Ball ball;
  late SpriteComponent scoreBoard;
  late List<MyPlayer> team1List;
  late List<MyPlayer> team2List;
  double time = 0;
  late TextComponent matchTime;
  late int team1ScoreNumber;
  late int team2ScoreNumber;
  late TextComponent team1Score;
  late TextComponent team2Score;
  late TextComponent playerTimer;
  late double playerTime;
  late bool matchIsEnded;
  var enemySpeed = 3.0;

  @override
  Future<void> onLoad() async {
    await addBackground();
    await randomPlayerWithBallIndex(5);
    await addScoreboardImg();
    await addTeams(6, playerWithBallIndex);
    await addBall();
    addScores();
    setBallPosition();
    addMatchTime();
    addPlayerTimer();
    matchIsEnded = true;
    continueMatchReady = false;

    /// Add all
    addAll([
      background,
      ...team1List,
      ...team2List,
      ball,
      scoreBoard,
      matchTime,
      team1Score,
      team2Score,
      playerTimer
    ]);

    ///
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!matchIsEnded) {
      moveBall(dt);
      moveBallToBasket(dt);
      // setStartScore();
      enemyScored();
      userScored();
      setPlayerWithBallIndex(playerWithBallIndex);
      setPlayerTimerPosition();
      moveComputerPlayers(dt);
      reduceMatchTime(dt);
      startTimer(dt);
    }
    super.update(dt);
  }

  List<MyPlayer> randomPlayers(int team, int count, int playerWithBallIndex) {
    var teamList = team == 1 ? <BasketballPlayer>[] : <BasketballPlayer2>[];
    late MyPlayer player;
    var size = Vector2(68, 68);
    double cellWidth = 64;
    double cellHeight = 64;
    var widthPadding = 8;

    var fieldWidth = 720 - widthPadding * 2;
    var fieldHeight = 1280;
    var numberOfCells = 11;
    var numberOfHeightCells = 20;
    var occupiedPositions = <Vector2>{};
    var previousPosition = Vector2(0, 0);

    for (int i = 0; i < count; i++) {
      var random = Random();
      Vector2 position;
      do {
        var positionX = random.nextInt(numberOfCells) * cellWidth + 8;
        var positionY = random.nextInt(numberOfHeightCells - 6) * cellHeight +
            cellHeight * 5 -
            10;
        position = Vector2(positionX.toDouble(), positionY.toDouble());
      } while (occupiedPositions.contains(position));

      occupiedPositions.add(position);

      if (team == 1) {
        // debugPrint('$playerWithBallIndex $i');
        player =
            BasketballPlayer(playerWithBall: playerWithBallIndex, number: i);
        player.size = size;
        if (i == 0) {
          player.position = Vector2(325, 310);
        } else {
          player.position =
              previousPosition.clone(); // Clone the previous position
          player.position.x = position.x;
          player.position += Vector2(
              0,
              i == count - 1 || i == count - 2
                  ? 4 * cellHeight
                  : 2 * cellHeight); // Update the position
        }
        previousPosition = player.position.clone();
      } else {
        player = BasketballPlayer2();
        player.size = size;
        player.position = team1List[i].position +
            Vector2(
                0, i == count - 1 || i == count - 2 ? -cellHeight : cellHeight);
      }
      teamList.add(player);
    }
    return teamList;
  }

  moveBall(double dt) {
    if (ball.ballTargetPosition != Vector2(0, 0) &&
        ball.ballState != BallState.collision) {
      // debugPrint(ball.ballState.toString());
      const ballSpeed = 500.0;
      final distance = ball.ballTargetPosition - ball.position;
      final distanceLength = distance.length;
      final velocity = distance.normalized() * ballSpeed * dt;

      if (distanceLength > velocity.length) {
        ball.ballState = BallState.movingToPlayer;
        ball.position += velocity;
      } else {
        ball.ballState = BallState.stopped;
        // debugPrint(ball.ballState.toString());
        ball.position = ball.ballTargetPosition.clone();
        ball.ballTargetPosition = Vector2(0, 0);
      }
    }
  }

  setPlayerWithBallIndex(int playerWithBallIndex) {
    for (var player in team1List) {
      if (player is BasketballPlayer) {
        if (player.playerWithBall != playerWithBallIndex) {
          player.playerWithBall = playerWithBallIndex;
          ball.ballState = BallState.startMove;
          // debugPrint(playerWithBallIndex.toString());
        }
      }
    }
  }

  updateScoreboardText() {
    matchTime.text =
        '${(time ~/ 60).toStringAsFixed(0)}:${(time % 60).toStringAsFixed(0).padLeft(2, '0')}';
  }

  addBackground() async {
    var backgroundImg = await Images().load('GameFon.png');
    background = SpriteComponent(sprite: Sprite(backgroundImg));
  }

  reduceMatchTime(double dt) {
    // time = 10;
    time -= dt;
    if (time < 0) {
      time = 0;
      gameEnded();
    }
    if (time % 15 <= dt) {
      enemySpeed += 0.5;
      debugPrint('ENEMY SPEED: $enemySpeed');
    }
    updateScoreboardText();
  }

  addBall() async {
    // var ballImg = await Images().load('Ball.png');
    // ball = SpriteComponent(sprite: Sprite(ballImg), size: Vector2(50, 50));
    ball = Ball(
        ballTargetPosition: team1List.last.position,
        ballState: BallState.stopped);
    // ball.ballTargetPosition = team1List.last.position;
    // ball.ballState = BallState.stopped;
  }

  randomPlayerWithBallIndex(int i) async {
    // var random = Random();
    playerWithBallIndex = i;

    // playerWithBallIndex = random.nextInt(i - 1) + 1;
  }

  addScoreboardImg() async {
    var scoreboardImg = await Images().load('Tablo.png');
    scoreBoard = SpriteComponent(sprite: Sprite(scoreboardImg));
    scoreBoard.position = Vector2(135, 20);
  }

  addTeams(int i, int playerWithBallIndex) {
    team1List = randomPlayers(1, 6, playerWithBallIndex);
    team2List = randomPlayers(2, 6, playerWithBallIndex);
    team1List[playerWithBallIndex].current = PlayerState.withBall1;
  }

  setBallPosition() {
    ball.size = Vector2(20, 20);
    ball.position = team1List[playerWithBallIndex].position;
    ball.position.add(Vector2(25, 40));
    ball.ballTargetPosition = ball.position;
  }

  addMatchTime() {
    time = 180;
    matchTime = TextComponent(
        text: '',
        size: Vector2(50, 50),
        textRenderer: TextPaint(style: const TextStyle(fontSize: 40)),
        position: Vector2(320, 90));
  }

  moveBallToBasket(double dt) {
    if (ball.ballState == BallState.stopped && playerWithBallIndex == 0) {
      const ballSpeed = 50.0;
      final distance = Vector2(350, 270) - ball.position;
      final distanceLength = distance.length;
      final velocity = distance.normalized() * ballSpeed * dt;

      if (distanceLength > velocity.length) {
        // ballState = BallState.movingToPlayer;
        ball.position += velocity;
      } else {
        ball.position = Vector2(350, 270);
      }
    }
  }

  bool isPositionOccupied(Vector2 position) {
    for (var player in team1List) {
      if (player is BasketballPlayer &&
          player.playerWithBall != playerWithBallIndex &&
          player.position == position) {
        return true;
      }
    }
    for (var player in team2List) {
      if (player is BasketballPlayer2 && player.position == position) {
        return true;
      }
    }
    return false;
  }

  void moveComputerPlayers(double dt) {
    if (ball.ballState != BallState.collision) {
      for (var player in team2List) {
        if (player is BasketballPlayer2) {
          // Define the maximum step size
          // enemySpeed = 3.0;

          // Calculate the desired horizontal position for the computer player
          var desiredX = player.position.x + enemySpeed * player.direction;

          // Limit the desired position within the field boundaries
          desiredX = desiredX.clamp(8, 720 - 68);

          // Check if the desired position is not occupied by any player
          var desiredPosition = Vector2(desiredX, player.position.y);
          if (!isPositionOccupied(desiredPosition)) {
            // Move the computer player horizontally
            player.position = desiredPosition;

            // Change direction when reaching the boundaries
            if (desiredX == 8 || desiredX == 720 - 68) {
              player.direction *= -1;
            }
          }
        }
      }
    }
  }

  void enemyScored() {
    if (ball.ballState == BallState.collision || playerTime < 0) {
      team2ScoreNumber++;
      updateScore();
      continueMatch();
    }
  }

  void continueMatch() {
    if (!continueMatchReady) {
      newPlayerPositions(6);

      // Set playerWithBallIndex to the index of the last player in team1List
      playerWithBallIndex = team1List.length - 1;
      team1List[playerWithBallIndex].current = PlayerState.withBall1;

      // Set the ball's position and target position
      setBallPosition();
      continueMatchReady = false;
      ball.ballState = BallState.stopped;
      // debugPrint('Continue match');
    }
  }

  void newPlayerPositions(int count) {
    late MyPlayer player;
    late MyPlayer player2;
    var size = Vector2(68, 68);
    double cellWidth = 64;
    double cellHeight = 64;
    var widthPadding = 8;

    var fieldWidth = 720 - widthPadding * 2;
    var fieldHeight = 1280;
    var numberOfCells = 11;
    var numberOfHeightCells = 20;
    var occupiedPositions = <Vector2>{};
    var previousPosition = Vector2(325, 310);

    for (int i = 0; i < count; i++) {
      var random = Random();
      Vector2 position;
      do {
        var positionX = random.nextInt(numberOfCells) * cellWidth + 8;
        var positionY = random.nextInt(numberOfHeightCells - 6) * cellHeight +
            cellHeight * 5 -
            10;
        position = Vector2(positionX.toDouble(), positionY.toDouble());
      } while (occupiedPositions.contains(position));

      occupiedPositions.add(position);

      player = BasketballPlayer(playerWithBall: playerWithBallIndex, number: i);
      player.size = size;
      if (i == 0) {
        player.position = Vector2(325, 310);
      } else {
        player.position =
            previousPosition.clone(); // Clone the previous position
        player.position.x = position.x;
        player.position += Vector2(
            0,
            i == count - 1 || i == count - 2
                ? 4 * cellHeight
                : 2 * cellHeight); // Update the position

        previousPosition = player.position.clone();
        team1List[i].position = player.position;
        player2 = BasketballPlayer2();
        player2.size = size;
        player2.position = team1List[i].position +
            Vector2(
                0, i == count - 1 || i == count - 2 ? -cellHeight : cellHeight);
        team2List[i].position = player2.position;
      }
    }
  }

  void userScored() {
    if (ball.position == Vector2(350, 270)) {
      team1ScoreNumber++;
      updateScore();
      continueMatch();
    }
  }

  void addScores() {
    team1ScoreNumber = 0;
    team2ScoreNumber = 0;
    team1Score = TextComponent(
      text: team1ScoreNumber.toString(),
      position: Vector2(195, 92),
      textRenderer: TextPaint(style: const TextStyle(fontSize: 40)),
    );
    team2Score = TextComponent(
      text: team2ScoreNumber.toString(),
      position: Vector2(500, 92),
      textRenderer: TextPaint(style: const TextStyle(fontSize: 40)),
    );
  }

  void updateScore() {
    team1Score.text = team1ScoreNumber.toString();
    team2Score.text = team2ScoreNumber.toString();
  }

  void addPlayerTimer() {
    playerTime = 10.0;
    var position = team1List[playerWithBallIndex].position.clone();
    position = position + Vector2(-10, -25);
    playerTimer = TextComponent(
        textRenderer: TextPaint(
            style: const TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold)),
        text: playerTime.toStringAsFixed(1),
        position: position);
  }

  void startTimer(dt) {
    playerTime -= dt;
    if (playerTime < 0) {
      enemyScored();
      playerTime = 10.0;
      newPlayerPositions(6);
      setBallPosition();
      setPlayerTimerPosition();
    }
    updatePlayerTimer();
  }

  void updatePlayerTimer() {
    playerTimer.text = playerTime.toStringAsFixed(1);
  }

  void setPlayerTimerPosition() {
    if (playerTimer.position !=
        team1List[playerWithBallIndex].position + Vector2(18, -25)) {
      playerTime = 10.0;
    }
    playerTimer.position =
        team1List[playerWithBallIndex].position + Vector2(18, -25);
  }

  void gameEnded() {
    matchIsEnded = true;
    gameRef.gameFinished = true;
    gameRef.scoreList = [team1ScoreNumber, team2ScoreNumber];
  }
}
