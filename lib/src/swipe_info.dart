enum SwipeDirection {
  TopLeft,
  TopRight,
  BotLeft,
  BotRight,
  None,
}

class SwipeInfo {
  final int cardIndex;
  final SwipeDirection direction;

  SwipeInfo(
    this.cardIndex,
    this.direction,
  );
}
