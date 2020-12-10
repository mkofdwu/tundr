import 'dart:async';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/pages/chat/chat.dart';
import 'package:tundr/pages/swiping/widgets/options_dark.dart';
import 'package:tundr/pages/swiping/widgets/options_light.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/pages/its_a_match.dart';

import 'package:tundr/constants/my_palette.dart';

import 'package:flutter/material.dart';
import 'package:tundr/services/suggestions_service.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/from_theme.dart';

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
  final StreamController<UserProfile> _profileStreamController =
      StreamController();
  final List<SuggestionWithProfile> _suggestionWithProfiles = [];
  int _i = 0;
  bool _canUndo = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_loadSuggestionProfiles);
  }

  @override
  void dispose() {
    _profileStreamController.close();
    super.dispose();
  }

  Future<void> _loadSuggestionProfiles(_) async {
    if (!mounted) {
      // when moving across the navigation tabs this page may be loaded
      return;
    }
    final privateInfo = Provider.of<User>(context, listen: false).privateInfo;
    final suggestions = Map<String, bool>.from(
        privateInfo.respondedSuggestions); // create a copy
    suggestions.addAll(privateInfo.dailyGeneratedSuggestions
        .asMap()
        .map((__i, uid) => MapEntry<String, bool>(uid, null)));
    for (final uid in suggestions.keys) {
      _suggestionWithProfiles.add(SuggestionWithProfile(
        profile: await UsersService.getUserProfile(uid),
        wasLiked: suggestions[uid],
      ));
    }
    _addProfileToStream();
    if (mounted) setState(() {});
  }

  void _addProfileToStream() {
    if (_i < _suggestionWithProfiles.length) {
      _profileStreamController.add(_suggestionWithProfiles[_i].profile);
    }
  }

  Future<void> _cleanUp(
    String otherUid, {
    bool likedUser,
    bool isRespondedSuggestion,
  }) async {
    setState(() {
      _i++;
      _canUndo = true;
    });

    _addProfileToStream(); // to show the next card as soon as possible

    final privateInfo = Provider.of<User>(context, listen: false).privateInfo;
    if (likedUser) privateInfo.numRightSwiped++;
    if (isRespondedSuggestion) {
      privateInfo.respondedSuggestions.remove(otherUid);
    } else {
      privateInfo.dailyGeneratedSuggestions.remove(otherUid);
    }
    privateInfo.suggestionsGoneThrough[otherUid] = likedUser;

    await Provider.of<User>(context, listen: false).writeFields(
      [
        'numRightSwiped',
        isRespondedSuggestion
            ? 'respondedSuggestions'
            : 'dailyGeneratedSuggestions',
        'suggestionsGoneThrough'
      ],
      UserPrivateInfo,
    );
  }

  void _nope() async {
    if (_i >= _suggestionWithProfiles.length) return;
    final otherUid = _suggestionWithProfiles[_i].profile.uid;
    if (_suggestionWithProfiles[_i].wasLiked == null) {
      await SuggestionsService.respondToSuggestion(
          toUid: otherUid, liked: false);
    }
    await _cleanUp(
      otherUid,
      likedUser: false,
      isRespondedSuggestion: _suggestionWithProfiles[_i].wasLiked != null,
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
    _profileStreamController.addError(_suggestionWithProfiles[_i].profile);
  }

  void _like() async {
    if (_i >= _suggestionWithProfiles.length) return;

    final suggestionWithProfile = _suggestionWithProfiles[_i];
    final otherUid = suggestionWithProfile.profile.uid;
    var saySomethingToMatch = false;

    if (suggestionWithProfile.wasLiked == null) {
      await SuggestionsService.respondToSuggestion(
        toUid: otherUid,
        liked: true,
      );
    } else if (suggestionWithProfile.wasLiked == true) {
      final matchAction = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ItsAMatchPage(profile: suggestionWithProfile.profile),
        ),
      );
      if (matchAction == MatchAction.undo) return;
      if (matchAction == MatchAction.saySomething) saySomethingToMatch = true;
      await SuggestionsService.matchWith(otherUid);
    }

    await _cleanUp(
      otherUid,
      likedUser: true,
      isRespondedSuggestion: suggestionWithProfile.wasLiked != null,
    );
    if (saySomethingToMatch) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            chat: Chat(
              id: null,
              otherProfile: suggestionWithProfile.profile,
              wallpaperUrl: '',
              lastRead: null,
              type: ChatType.newMatch,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        if (_i >= _suggestionWithProfiles.length ||
            Provider.of<User>(context, listen: false)
                    .privateInfo
                    .numRightSwiped >=
                10)
          SizedBox(
            width: width - 80,
            height: height - 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "You've gone through everyone",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Try editing your filters to see more people',
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
            child: DescribedFeatureOverlay(
              featureId: 'suggestion_card',
              tapTarget: SizedBox.shrink(),
              title: Text('View a profile'),
              description: Text(
                  'Click on the card to learn more about this person. Swipe right to like or left to dislike.'),
              targetColor: MyPalette.white.withOpacity(0.8),
              backgroundColor: Theme.of(context).accentColor,
              child: SuggestionCard(
                width: width - 80,
                height: height - 250,
                profileStream: _profileStreamController.stream,
                onLike: _like,
                onNope: _nope,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: fromTheme(
            context,
            dark: SwipingOptionsDark(
              canUndo: _canUndo,
              onLike: _like,
              onNope: _nope,
              onUndo: _undo,
            ),
            light: SwipingOptionsLight(
              canUndo: _canUndo,
              onLike: _like,
              onNope: _nope,
              onUndo: _undo,
            ),
          ),
        ),
      ],
    );
  }
}
