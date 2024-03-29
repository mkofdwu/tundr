import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/pages/swiping/controllers/card_animations_controller.dart';
import 'package:tundr/pages/swiping/utils.dart';
import 'package:tundr/pages/swiping/widgets/options_dark.dart';
import 'package:tundr/pages/swiping/widgets/options_light.dart';
import 'package:tundr/store/user.dart';
import 'package:tundr/pages/its_a_match.dart';

import 'package:tundr/constants/my_palette.dart';

import 'package:flutter/material.dart';
import 'package:tundr/services/suggestions_service.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/widgets/my_feature.dart';
import 'package:tundr/widgets/my_loader.dart';

import 'widgets/suggestion_card.dart';

class SuggestionWithProfile {
  final UserProfile profile;
  final bool wasLiked;

  const SuggestionWithProfile({this.profile, this.wasLiked});
}

class SwipingPage extends StatefulWidget {
  @override
  _SwipingPageState createState() => _SwipingPageState();
}

class _SwipingPageState extends State<SwipingPage> {
  final CardAnimationsController _cardAnimationsController =
      CardAnimationsController();
  bool _loading = true;
  final List<SuggestionWithProfile> _suggestionWithProfiles = [];
  int _i = 0;
  bool _canUndo = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_loadSuggestionProfiles);
  }

  Future<void> _loadSuggestionProfiles(_) async {
    if (!mounted) {
      // when moving across the navigation tabs this page may be loaded
      return;
    }
    setState(() => _loading = true);
    final privateInfo = Provider.of<User>(context, listen: false).privateInfo;
    final suggestions = privateInfo.dailyGeneratedSuggestions
        .asMap()
        .map((__i, uid) => MapEntry<String, bool>(uid, null));
    suggestions.addAll(privateInfo.respondedSuggestions); // create a copy
    for (final uid in suggestions.keys) {
      final profile =
          await UsersService.getUserProfile(uid, returnDeletedUser: false);
      if (profile != null) {
        _suggestionWithProfiles.add(SuggestionWithProfile(
          profile: profile,
          wasLiked: suggestions[uid],
        ));
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  void _onNope() async {
    if (_i >= _suggestionWithProfiles.length) return;
    final suggestionWithProfile = _suggestionWithProfiles[_i];
    final otherUid = suggestionWithProfile.profile.uid;

    setState(() {
      _i++;
      _canUndo = true;
    });
    _cardAnimationsController.triggerAnimation(CardAnimation.fadeInNew);

    if (suggestionWithProfile.wasLiked == null) {
      await SuggestionsService.respondToSuggestion(
          toUid: otherUid, liked: false);
    }
    await updateNumRightSwipedRemoveFromListAndGoneThrough(
      context,
      otherUid,
      likedUser: false,
      isRespondedSuggestion: suggestionWithProfile.wasLiked != null,
    );
  }

  void _undo() async {
    setState(() {
      _i--;
      _canUndo = false;
    });
    if (_suggestionWithProfiles[_i].wasLiked == null) {
      await SuggestionsService.undoSuggestionResponse(
        Provider.of<User>(context, listen: false).profile.uid,
        _suggestionWithProfiles[_i].profile.uid,
      );
    }
    _cardAnimationsController.triggerAnimation(CardAnimation.undo);
  }

  void _onLike() async {
    if (_i >= _suggestionWithProfiles.length) return;

    final suggestionWithProfile = _suggestionWithProfiles[_i];
    final otherUid = suggestionWithProfile.profile.uid;
    var undo = false;

    setState(() {
      _i++;
      _canUndo = suggestionWithProfile.wasLiked != true;
    });
    _cardAnimationsController.triggerAnimation(CardAnimation.fadeInNew);

    if (suggestionWithProfile.wasLiked == null) {
      await SuggestionsService.respondToSuggestion(
        toUid: otherUid,
        liked: true,
      );
    } else if (suggestionWithProfile.wasLiked) {
      undo = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ItsAMatchPage(profile: suggestionWithProfile.profile),
        ),
      );
      if (undo) return;
    }
    await updateNumRightSwipedRemoveFromListAndGoneThrough(
      context,
      otherUid,
      likedUser: true,
      isRespondedSuggestion: suggestionWithProfile.wasLiked != null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        if (_loading)
          SizedBox(
            width: width - 80,
            height: height - 200,
            child: Center(child: MyLoader()),
          )
        else if (_i >= _suggestionWithProfiles.length ||
            Provider.of<User>(context, listen: false)
                    .privateInfo
                    .numRightSwiped >=
                10)
          SizedBox(
            width: 260,
            height: height - 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "That's everyone for today",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Try editing your filters to see more people next time',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MyPalette.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: MyFeature(
              key: ValueKey('suggestionCardFeature'),
              featureId: 'suggestion_card',
              tapTarget: SizedBox.shrink(),
              title: 'View a profile',
              description:
                  'Click on the card to learn more about this person. Swipe right to like or left to dislike.',
              child: SuggestionCard(
                width: width - 80,
                height: height - 250,
                profile: _suggestionWithProfiles[_i].profile,
                animationsController: _cardAnimationsController,
                onLike: _onLike,
                onNope: _onNope,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: fromTheme(
            context,
            dark: SwipingOptionsDark(
              canUndo: _canUndo,
              onLike: () {
                // when the animation is complete _onLike handler is called
                _cardAnimationsController.triggerAnimation(CardAnimation.like);
              },
              onNope: () {
                _cardAnimationsController.triggerAnimation(CardAnimation.nope);
              },
              onUndo: _undo,
            ),
            light: SwipingOptionsLight(
              canUndo: _canUndo,
              onLike: () {
                _cardAnimationsController.triggerAnimation(CardAnimation.like);
              },
              onNope: () {
                // when the animation is complete _onNope handler is called
                _cardAnimationsController.triggerAnimation(CardAnimation.nope);
              },
              onUndo: _undo,
            ),
          ),
        ),
      ],
    );
  }
}
