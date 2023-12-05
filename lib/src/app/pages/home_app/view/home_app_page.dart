import 'package:basketball_game/src/app/pages/game_field_page/controller/game_page_controller.dart';
import 'package:basketball_game/src/app/pages/game_field_page/model/game.dart';
import 'package:basketball_game/src/app/pages/game_field_page/view/widgets/main_game_dialog.dart';
import 'package:basketball_game/src/app/pages/game_field_page/view/widgets/restart_game_dialog.dart';
import 'package:basketball_game/src/app/pages/game_field_page/view/widgets/result_dialog.dart';
import 'package:basketball_game/src/app/pages/home_app/controller/home_app_page_controller.dart';

import '../../../../universal_widgets/my_button.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/my_parameters.dart';

import '../../../../utils/library.dart';
import '../../../../utils/my_colors.dart';

class HomeAppPage extends ConsumerStatefulWidget {
  const HomeAppPage({
    Key? key,
  }) : super(key: key);

  final String route = 'home app page';

  @override
  ConsumerState createState() => _HomeAppPageState();
}

class _HomeAppPageState extends ConsumerState<HomeAppPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.longestSide;
    final width = MediaQuery.of(context).size.shortestSide;
    final orientationPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final game = ref.watch(gameProvider);
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
              body: SingleChildScrollView(
            physics: orientationPortrait
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Constants.startPageImg),
                        fit: BoxFit.fitHeight)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(game.showStartDialog&&!game.showRestartGameDialog)buildStartPage(height, width, context, game),

                    if(game.showResultDialog&&!game.showRestartGameDialog)const ResultDialog(),
                    if(game.showRestartGameDialog) const RestartGameDialog()
                  ],
                ),
              ),
            ),
          )),
        ),
        onWillPop: () async {
          return false;
        });
  }

  SizedBox buildStartPage(double height, double width, BuildContext context, GameState game) {
    return SizedBox(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: height * 0.18,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Constants.startPageTopImg))),
          ),
          MainGameDialog(),
          Padding(
            padding: EdgeInsets.only(bottom: height * 0.11),
            child: Opacity(
              opacity: game.isBetted?1:0.5,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      HomeAppPageController.onPlayTap(context, ref);
                    },
                    child: Container(
                      height: height * 0.18,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(Constants.playButton))),
                    ),
                  ),
                  Text(
                    'PLAY',
                    style: MyParameters(context).middleTextStyle,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
