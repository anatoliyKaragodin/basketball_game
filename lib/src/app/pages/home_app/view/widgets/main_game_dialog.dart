import 'package:basketball_game/src/universal_widgets/my_text_button.dart';
import 'package:basketball_game/src/utils/library.dart';
import 'package:basketball_game/src/utils/my_colors.dart';
import 'package:basketball_game/src/utils/my_parameters.dart';

import '../../../game_field_page/controller/game_page_controller.dart';


class MainGameDialog extends ConsumerStatefulWidget {
  const MainGameDialog({super.key});

  @override
  ConsumerState createState() => _MainGameDialogState();
}

class _MainGameDialogState extends ConsumerState<MainGameDialog> {
  TextEditingController betController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.longestSide;
    final width = MediaQuery.of(context).size.shortestSide;
    final orientationPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final game = ref.watch(gameProvider);
    return Container(
      height: height*0.4,
      width: width*0.6,
      decoration: BoxDecoration(
          borderRadius: MyParameters(context).roundedBorders,
          color: MyColors.whiteColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Your money: ${game.userMoney}'),
          SizedBox(
            height: height*0.12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [SizedBox(
                  height: height * 0.05,
                  width: width * 0.35,
                  child: TextField(
                    controller: betController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 12.0, left: 10),
                      hintText: 'input bet',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  )),
                MyTextButton(
                    text: 'Bet',
                    function: () =>
                        GameControl.onTapConfirmButton(ref, betController.text),
                    height: height)],
            ),
          ),
          MyTextButton(
              text: 'Play match!',
              function: () {
                // GameControl.onNewGameTap(ref);
              },
              height: height)
        ],
      ),
    );
  }
}
