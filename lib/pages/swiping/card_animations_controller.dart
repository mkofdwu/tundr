enum CardAnimation {
  fadeInNew,
  like,
  nope,
  undo,
}

class CardAnimationsController {
  final Map<CardAnimation, Function> _animationHandlers = {};

  void setAnimationHandler(CardAnimation animation, Function handler) {
    _animationHandlers[animation] = handler;
  }

  void triggerAnimation(CardAnimation animation) {
    final handler = _animationHandlers[animation];
    if (handler != null) handler();
  }
}
