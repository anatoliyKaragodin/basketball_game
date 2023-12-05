import 'package:basketball_game/src/utils/library.dart';

import '../../../../../universal_widgets/my_text_button.dart';
import '../../../game_field_page/controller/game_page_controller.dart';

class ResultDialog extends ConsumerStatefulWidget {
  const ResultDialog({super.key});

  @override
  ConsumerState createState() => _ResultDialogState();
}

class _ResultDialogState extends ConsumerState<ResultDialog> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.longestSide;
    final width = MediaQuery.of(context).size.shortestSide;
    final orientationPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final game = ref.watch(gameProvider);
    return Container(
        height: 100,
        width: 200,
        // color: Colors.blue,
        child: Column(
          children: [
            Text('${game.teamsScore[0]}-${game.teamsScore[1]}'),
            MyTextButton(
                text: 'Play match',
                function: () {
                  // GameControl.onNewGameTap(ref);
                },
                height: height),
          ],
        ));
  }
}
