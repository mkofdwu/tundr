import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/pages/swiping/card_animations_controller.dart';
import 'dart:math';

import 'package:tundr/widgets/profile_tile.dart';

class SuggestionCard extends StatefulWidget {
  final double width;
  final double height;
  final UserProfile profile;
  final CardAnimationsController animationsController;
  final Function onLike;
  final Function onNope;

  const SuggestionCard({
    Key key,
    this.width,
    this.height,
    @required this.profile,
    @required this.animationsController,
    @required this.onLike,
    @required this.onNope,
  }) : super(key: key);

  @override
  SuggestionCardState createState() => SuggestionCardState();
}

class SuggestionCardState extends State<SuggestionCard>
    with TickerProviderStateMixin {
  static const double dampingFactor = 0.2;
  static const int climax = 15; // angle at which nope / like is decided

  Offset _initialOffset;
  double _angle = 0;

  bool _goingToLike = false;
  bool _goingToNope = false;

  // animation
  AnimationController _fadeInController;
  Animation _fadeInAnimation;

  AnimationController _likeController;
  Animation _likeTranslateAnimation;
  Animation _likeRotateAnimation;

  AnimationController _nopeController;
  Animation _nopeTranslateAnimation;
  Animation _nopeRotateAnimation;

  AnimationController _resetController;
  Tween _resetRotateTween;
  Animation _resetRotateAnimation;

  void _fadeInNew() {
    _fadeInController.reset();
    _likeController.reset();
    _nopeController.reset();
    setState(() {
      _angle = 0;
      _goingToLike = false;
      _goingToNope = false;
    });
    _fadeInController.forward();
  }

  void _reset() {
    _resetRotateTween.begin = _angle;
    _resetController.reset();
    _resetController.forward();
    setState(() {
      _goingToLike = false;
      _goingToNope = false;
    });
  }

  void _onLike() {
    _likeController.forward();
  }

  void _onNope() {
    _nopeController.forward();
  }

  @override
  void initState() {
    super.initState();

    // fade in animation
    _fadeInController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _fadeInController.addListener(() => setState(() {}));
    _fadeInAnimation =
        Tween<double>(begin: 0, end: 1).animate(_fadeInController);

    // like animation
    _likeController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _likeController.addListener(() => setState(() {}));
    _likeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onLike(); // !
    });
    _likeTranslateAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(300, 100)).animate(
            CurvedAnimation(parent: _likeController, curve: Curves.easeOut));
    _likeRotateAnimation =
        Tween<double>(begin: 0, end: 45).animate(_likeController);

    // nope animation
    _nopeController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _nopeController.addListener(() => setState(() {}));
    _nopeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onNope(); // !
    });
    _nopeTranslateAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-300, 100)).animate(
            CurvedAnimation(parent: _nopeController, curve: Curves.easeOut));
    _nopeRotateAnimation =
        Tween<double>(begin: 0, end: -45).animate(_nopeController);

    // reset animation
    _resetController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _resetController.addListener(() => setState(() {
          _angle = _resetRotateAnimation.value;
        }));
    _resetRotateTween = Tween<double>(begin: _angle, end: 0);
    _resetRotateAnimation = _resetRotateTween.animate(_resetController);

    // fade in animation when new profile is loaded
    widget.animationsController
        .setAnimationHandler(CardAnimation.fadeInNew, _fadeInNew);
    widget.animationsController
        .setAnimationHandler(CardAnimation.like, _onLike);
    widget.animationsController
        .setAnimationHandler(CardAnimation.nope, _onNope);
    widget.animationsController.setAnimationHandler(
        CardAnimation.undo, () {}); // no undo animation for now

    if (widget.profile != null) {
      // first card
      _fadeInNew();
    }
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    _likeController.dispose();
    _nopeController.dispose();
    _resetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _fadeInAnimation?.value,
      child: GestureDetector(
        child: Transform.translate(
          offset: Offset.zero +
              _likeTranslateAnimation?.value +
              _nopeTranslateAnimation?.value,
          child: Transform.rotate(
            angle: (_angle +
                    _likeRotateAnimation?.value +
                    _nopeRotateAnimation?.value) *
                pi /
                180,
            origin: Offset(0, 300),
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: Stack(
                children: <Widget>[
                  if (widget.profile != null)
                    ProfileTile(profile: widget.profile),
                  _goingToLike
                      ? Positioned(
                          left: 50,
                          top: 50,
                          child: Transform.rotate(
                            angle: -pi / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: MyPalette.green),
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                'LIKE',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: MyPalette.green,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  _goingToNope
                      ? Positioned(
                          top: 50,
                          right: 50,
                          child: Transform.rotate(
                            angle: pi / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: MyPalette.red),
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                'NOPE',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: MyPalette.red,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
        onHorizontalDragStart: (DragStartDetails details) {
          _initialOffset = details.globalPosition;
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          setState(() {
            _angle =
                (details.globalPosition.dx - _initialOffset.dx) * dampingFactor;
            _goingToLike = _angle > climax;
            _goingToNope = _angle < -climax;
          });
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          if (_goingToLike) {
            _onLike();
          } else if (_goingToNope) {
            _onNope();
          } else {
            _reset();
          }
        },
        onHorizontalDragCancel: _reset,
        onTap: () => Navigator.pushNamed(
          context,
          '/profile',
          arguments: widget.profile,
        ),
      ),
    );
  }
}
