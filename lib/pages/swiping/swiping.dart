import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/pages/its_a_match.dart';

import 'package:tundr/constants/my_palette.dart';

import 'package:flutter/material.dart';
import 'package:tundr/pages/swiping/widgets/suggestion_card.dart';
import 'package:tundr/services/suggestions_service.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/widgets/theme_builder.dart'; // for icons, remove when alternative image has been found

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
  final List<SuggestionWithProfile> _suggestionWithProfiles = [];
  final Map<String, dynamic> _goneThrough = {};
  int _i = 0;
  bool _canUndo = false;

  @override
  void initState() {
    super.initState();
    _loadSuggestionProfiles();
  }

  Future<void> _loadSuggestionProfiles() async {
    final privateInfo = Provider.of<User>(context).privateInfo;
    final suggestions = privateInfo.respondedSuggestions;
    suggestions.addAll(privateInfo.dailyGeneratedSuggestions
        .map((uid) => MapEntry(uid, null)) as Map<String, bool>);
    for (final uid in suggestions.keys) {
      _suggestionWithProfiles.add(SuggestionWithProfile(
        profile: await UsersService.getUserProfile(uid),
        wasLiked: suggestions[uid],
      ));
    }
  }

  @override
  void deactivate() {
    final privateInfo = Provider.of<User>(context).privateInfo;

    privateInfo.suggestionsGoneThrough.addAll(_goneThrough);
    final goneThroughUids = _goneThrough.keys;
    privateInfo.dailyGeneratedSuggestions
        .removeWhere((checkUid) => goneThroughUids.contains(checkUid));
    privateInfo.respondedSuggestions.removeWhere(
        (checkUid, _wasLiked) => goneThroughUids.contains(checkUid));

    Provider.of<User>(context)
        .writeField('suggestionsGoneThrough', UserPrivateInfo);
    Provider.of<User>(context)
        .writeField('suggestionsGoneThrough', UserPrivateInfo);
    Provider.of<User>(context)
        .writeField('suggestionsGoneThrough', UserPrivateInfo);

    super.deactivate();
  }

  void _nope() async {
    final user = Provider.of<User>(context).profile;
    final otherUser = _suggestionWithProfiles[_i].profile;

    if (_suggestionWithProfiles[_i].wasLiked == null) {
      setState(() {
        _i++;
      });
      await SuggestionsService.respondToSuggestion(
        fromUid: user.uid,
        toUid: otherUser.uid,
        liked: false,
      );
    } else {
      setState(() {
        _i++;
      });
    }

    setState(() => _canUndo = true);
    _goneThrough[user.uid] = false;
  }

  void _undo() {
    SuggestionsService.undoSuggestionResponse(
      Provider.of<User>(context).profile.uid,
      _suggestionWithProfiles[_i - 1].profile.uid,
    );
    setState(() {
      _i--;
      _canUndo = false;
    });
  }

  void _like() async {
    final user = Provider.of<User>(context).profile;
    final otherProfile = _suggestionWithProfiles[_i].profile;
    await Provider.of<User>(context)
        .updatePrivateInfo({'numRightSwiped': FieldValue.increment(1)});

    if (_suggestionWithProfiles[_i].wasLiked == true) {
      final undo = await Navigator.push(
        context,
        PageRouteBuilder(
          // page transition
          pageBuilder: (context, animation1, animation2) =>
              ItsAMatchPage(user: otherProfile),
        ),
      );
      if (!undo) {
        await SuggestionsService.match(otherProfile.uid);
        setState(() {
          _i++;
          _canUndo = false;
        });
      }
    } else if (_suggestionWithProfiles[_i].wasLiked == null) {
      setState(() {
        _i++;
        _canUndo = true;
      });
      await SuggestionsService.respondToSuggestion(
        fromUid: user.uid,
        toUid: otherProfile.uid,
        liked: true,
      );
    } else {
      setState(() {
        _i++;
        _canUndo = true;
      });
    }

    _goneThrough[user.uid] = true;
  }

  Widget _buildDarkOptions() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
              GestureDetector(
                child: Icon(Icons.close,
                    color: Theme.of(context).accentColor, size: 30.0),
                onTap: _nope,
              ),
            ] +
            (_canUndo
                ? [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 20.0,
                        right: 20.0,
                      ),
                      child: Container(
                        width: 3.0,
                        height: 60.0,
                        color: MyPalette.gold,
                      ),
                    ),
                    GestureDetector(
                      child: Icon(Icons.undo,
                          color: Theme.of(context).accentColor, size: 30.0),
                      onTap: _undo,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        bottom: 20.0,
                      ),
                      child: Container(
                        width: 3.0,
                        height: 60.0,
                        color: MyPalette.gold,
                      ),
                    ),
                  ]
                : [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Container(
                        width: 3.0,
                        height: 60.0,
                        color: MyPalette.gold,
                      ),
                    ),
                  ]) +
            [
              GestureDetector(
                child: Icon(Icons.done,
                    color: Theme.of(context).accentColor, size: 30.0),
                onTap: _like,
              ),
            ],
      );

  Widget _buildLightOptions() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child: Container(
              width: 70.0,
              height: 70.0,
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: MyPalette.gold,
                shadows: [MyPalette.primaryShadow],
              ),
              child: Icon(
                Icons.close,
                color: MyPalette.white,
                size: 30.0,
              ),
            ),
            onTap: _nope,
          ),
          _canUndo
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: MyPalette.white,
                        shadows: [MyPalette.primaryShadow],
                      ),
                      child:
                          Icon(Icons.undo, color: MyPalette.black, size: 20.0),
                    ),
                    onTap: _undo,
                  ),
                )
              : SizedBox(width: 50.0),
          GestureDetector(
            child: Container(
              width: 70.0,
              height: 70.0,
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: MyPalette.gold,
                shadows: [MyPalette.primaryShadow],
              ),
              child: Icon(
                Icons.done,
                color: MyPalette.white,
                size: 30.0,
              ),
            ),
            onTap: _like,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final otherProfile = _i < _suggestionWithProfiles.length
        ? _suggestionWithProfiles[_i].profile
        : null;

    return Column(
      children: <Widget>[
        if (_i == _suggestionWithProfiles.length ||
            Provider.of<User>(context).privateInfo.numRightSwiped >=
                10) // should be just == 10
          SizedBox(
            width: width - 80.0,
            height: height - 200.0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "You've gone through everyone",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Try editing your filters to see more people',
                    style: TextStyle(
                      color: MyPalette.grey,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: SuggestionCard(
              width: width - 80.0,
              height: height - 250.0,
              user: otherProfile,
              onLike: _like,
              onNope: _nope,
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0), // FTUURE: 20
          child: ThemeBuilder(
            buildDark: _buildDarkOptions,
            buildLight: _buildLightOptions,
          ),
        ),
      ],
    );
  }
}
