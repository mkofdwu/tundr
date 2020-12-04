import 'dart:async';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/pages/settings/filters.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/pages/its_a_match.dart';

import 'package:tundr/constants/my_palette.dart';

import 'package:flutter/material.dart';
import 'package:tundr/services/suggestions_service.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/widgets/theme_builder.dart'; // for icons, remove when alternative image has been found

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

  Future<void> _loadSuggestionProfiles(_) async {
    final privateInfo = Provider.of<User>(context, listen: false).privateInfo;
    final suggestions = privateInfo.respondedSuggestions;
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
    setState(() {});
  }

  void _addProfileToStream() =>
      _profileStreamController.add(_suggestionWithProfiles[_i].profile);

  Future<void> _cleanUp(
    String otherUid, {
    bool likedUser,
    bool isRespondedSuggestion,
  }) async {
    setState(() {
      _i++;
      _canUndo = true;
    });

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

    _addProfileToStream();
  }

  void _nope() async {
    final otherUid = _suggestionWithProfiles[_i].profile.uid;
    if (_suggestionWithProfiles[_i].wasLiked == null) {
      await SuggestionsService.respondToSuggestion(
        fromUid: Provider.of<User>(context, listen: false).profile.uid,
        toUid: otherUid,
        liked: false,
      );
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
    _addProfileToStream();
  }

  void _like() async {
    final user = Provider.of<User>(context, listen: false).profile;
    final suggestionWithProfile = _suggestionWithProfiles[_i];
    final otherUid = suggestionWithProfile.profile.uid;

    if (suggestionWithProfile.wasLiked == null) {
      await SuggestionsService.respondToSuggestion(
        fromUid: user.uid,
        toUid: otherUid,
        liked: true,
      );
    } else if (suggestionWithProfile.wasLiked == true) {
      final undo = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ItsAMatchPage(user: suggestionWithProfile.profile),
        ),
      );
      if (undo) return;
      await SuggestionsService.matchWith(otherUid);
    }

    await _cleanUp(
      otherUid,
      likedUser: true,
      isRespondedSuggestion: suggestionWithProfile.wasLiked != null,
    );
  }

  void _goToFilterSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FiltersSettingsPage()),
    );
  }

  Widget _buildDarkOptions() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
              GestureDetector(
                child: Icon(Icons.close, size: 30),
                onTap: _nope,
              ),
            ] +
            (_canUndo
                ? [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 10, right: 20),
                      child: Container(
                        width: 2,
                        height: 60,
                        color: MyPalette.gold,
                      ),
                    ),
                    GestureDetector(
                      child: Icon(Icons.undo, size: 30),
                      onTap: _undo,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10),
                      child: Container(
                        width: 2,
                        height: 60,
                        color: MyPalette.gold,
                      ),
                    ),
                  ]
                : [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10),
                      child: Container(
                        width: 2,
                        height: 60,
                        color: MyPalette.gold,
                      ),
                    ),
                  ]) +
            [
              GestureDetector(
                child: Icon(Icons.done, size: 30),
                onTap: _like,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Container(
                    width: 2,
                    height: 60,
                    color: MyPalette.gold,
                  )),
              GestureDetector(
                onTap: _goToFilterSettings,
                child: Icon(Icons.filter_alt),
              ),
            ],
      );

  Widget _buildLightOptions() => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: 40),
          GestureDetector(
            child: Container(
              width: 70,
              height: 70,
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: MyPalette.gold,
                shadows: [MyPalette.primaryShadow],
              ),
              child: Icon(
                Icons.close,
                color: MyPalette.white,
                size: 30,
              ),
            ),
            onTap: _nope,
          ),
          _canUndo
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: MyPalette.white,
                        shadows: [MyPalette.primaryShadow],
                      ),
                      child: Icon(Icons.undo, color: MyPalette.black, size: 24),
                    ),
                    onTap: _undo,
                  ),
                )
              : SizedBox(width: 50),
          GestureDetector(
            child: Container(
              width: 70,
              height: 70,
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: MyPalette.gold,
                shadows: [MyPalette.primaryShadow],
              ),
              child: Icon(
                Icons.done,
                color: MyPalette.white,
                size: 30,
              ),
            ),
            onTap: _like,
          ),
          SizedBox(width: 10),
          SizedBox(
            height: 70,
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: MyPalette.grey,
                    shadows: [MyPalette.primaryShadow],
                  ),
                  child: Icon(
                    Icons.filter_alt,
                    color: MyPalette.white,
                    size: 16,
                  ),
                ),
                onTap: _goToFilterSettings,
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        if (_i == _suggestionWithProfiles.length ||
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
              description:
                  Text('Click on the card to learn more about this person'),
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
          child: ThemeBuilder(
            buildDark: _buildDarkOptions,
            buildLight: _buildLightOptions,
          ),
        ),
      ],
    );
  }
}
