import 'package:basketball_game/src/app/pages/game_field_page/controller/game_page_controller.dart';
import 'package:basketball_game/src/app/pages/game_field_page/view/game_page.dart';
import 'package:basketball_game/src/utils/library.dart';

class HomeAppPageController {
  static void onPlayTap(BuildContext context, WidgetRef ref) {
    final isBetted = ref.read(gameProvider).isBetted;
    if(isBetted) {
      ref.read(gameProvider.notifier).resetScores();
      ref.read(gameProvider.notifier).changeStopGame(false);
      ref.read(gameProvider.notifier).changeMatchEnd(false);

      Navigator.pushNamed(context, const GamePage().route);
    }
  }
}
