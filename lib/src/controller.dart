import 'dart:math';

import 'cards.dart';
import 'swipe_info.dart';

/// Card controller
class TCardController {
  TCardState? state;

  void bindState(TCardState state) {
    this.state = state;
  }

  int get index => state?.frontCardIndex ?? 0;

  forward({SwipeDirection? direction}) {
    if (direction == null) {
      direction =
          Random().nextBool() ? SwipeDirection.TopLeft : SwipeDirection.TopRight;
    }

    state!.swipeInfoList.add(SwipeInfo(state!.frontCardIndex, direction));
    state!.runChangeOrderAnimation();
  }

  back() {
    state!.runReverseOrderAnimation();
  }

  get reset => state!.reset;

  void dispose() {
    state = null;
  }
}
