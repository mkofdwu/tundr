import 'package:flutter/material.dart';
import 'package:tundr/models/user_profile.dart';
import 'dart:math';

import 'package:tundr/widgets/profile_tile.dart';

class SuggestionCard extends StatefulWidget {
  final double width;
  final double height;
  final UserProfile user;
  final Function onLike;
  final Function onNope;

  const SuggestionCard({
    Key key,
    this.width,
    this.height,
    @required this.user,
    @required this.onLike,
    @required this.onNope,
  }) : super(key: key);

  @override
  _SuggestionCardState createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard>
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

  void _reset() {
    setState(() {
      _angle = 0;
      _goingToLike = false;
      _goingToNope = false;
    });
  }

  void _onLike() {
    _likeController.forward();
    widget.onLike();
  }

  void _onNope() {
    _nopeController.forward();
    widget.onNope();
  }

  @override
  void initState() {
    super.initState();

    // fade in animation
    _fadeInController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _fadeInAnimation = Tween(begin: 0, end: 1).animate(_fadeInController);

    // like animation
    _likeController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _likeController.addListener(() {
      setState(() {});
    });
    _likeTranslateAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(300, 200)).animate(
            CurvedAnimation(parent: _likeController, curve: Curves.easeOut));
    _likeRotateAnimation =
        Tween<double>(begin: 0, end: 45).animate(_likeController);

    // nope animation
    _nopeController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _nopeController.addListener(() {
      setState(() {});
    });
    _nopeTranslateAnimation = Tween<Offset>(
            begin: Offset(0, 0), end: Offset(-300, 200))
        .animate(CurvedAnimation(parent: _nopeController, curve: Curves.ease));
    _nopeRotateAnimation =
        Tween<double>(begin: 0, end: -45).animate(_nopeController);
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    _likeController.dispose();
    _nopeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _fadeInController.forward();

    return GestureDetector(
      child: FadeTransition(
        opacity: _fadeInAnimation,
        child: Transform.translate(
          offset: _likeTranslateAnimation?.value ??
              _nopeTranslateAnimation?.value ??
              Offset.zero,
          child: Transform.rotate(
            angle: (_angle +
                    (_likeRotateAnimation?.value ??
                        _nopeRotateAnimation ??
                        0)) *
                pi /
                180,
            origin: Offset(0, 300),
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: Stack(
                children: <Widget>[
                  ProfileTile(profile: widget.user),
                  _goingToLike
                      ? Positioned(
                          left: 50,
                          top: 50,
                          child: Transform.rotate(
                            angle: -pi / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.greenAccent),
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                'LIKE',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.greenAccent,
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
                                border: Border.all(color: Colors.redAccent),
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                'NOPE',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.redAccent,
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
        }
        _reset();
      },
      onHorizontalDragCancel: _reset,
      onTap: () => Navigator.pushNamed(
        context,
        '/profile',
        arguments: widget.user,
      ),
    );
  }
}
