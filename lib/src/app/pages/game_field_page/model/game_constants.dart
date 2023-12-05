import 'package:basketball_game/src/app/pages/game_field_page/model/game.dart';
import 'package:basketball_game/src/app/pages/game_field_page/model/player.dart';
import 'package:basketball_game/src/utils/constants.dart';

class GameConstants {
  static const initState = GameState(
      showStartDialog: true,
      showRoundResultDialog: false,
      showResultDialog: false,
      showMainDialog: false,
      bet: 0,
      userMoney: Constants.userStartCoins,
      userScore: 0,
      isBetted: false,
      isWinGame: false,
      playerWins: 0,
      lifes: 3,
      showRestartGameDialog: false,
      teamsScore: [],
      matchIsEnded: false,
      stopGame: true);
}
