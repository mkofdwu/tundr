// TODO: change everything according to the new suggestions system
// (suggestions stored in CurrentUser.user.generatedDailySuggestions and .respondedSuggestions)

import "package:flutter/widgets.dart";
import 'package:provider/provider.dart';
import 'package:tundr/repositories/current-user.dart';
import 'package:tundr/models/suggestion.dart';
import 'package:tundr/models/suggestion-gone-through.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/pages/its-a-match.dart';
import 'package:tundr/services/database-service.dart';
import 'package:tundr/constants/colors.dart';

import "package:flutter/material.dart";
import 'package:tundr/constants/shadows.dart';
import 'package:tundr/widgets/loaders/loader.dart';
import 'package:tundr/pages/swiping/widgets/suggestion-card.dart';
import 'package:tundr/widgets/theme-builder.dart'; // for icons, remove when alternative image has been found

class SwipingPage extends StatefulWidget {
  @override
  _SwipingPageState createState() => _SwipingPageState();
}

class _SwipingPageState extends State<SwipingPage> {
  List<SuggestionGoneThrough> _goneThrough = [];
  int _i = 0;
  bool _canUndo = false;

  @override
  void deactivate() {
    DatabaseService.addUserSuggestionsGoneThrough(
        Provider.of<CurrentUser>(context).user.uid, _goneThrough);
    super.deactivate();
  }

  void _nope() async {
    final List<Suggestion> suggestions =
        Provider.of<CurrentUser>(context).user.responseSuggestions +
            Provider.of<CurrentUser>(context).user.generatedDailySuggestions;
    final User user = Provider.of<CurrentUser>(context).user;
    final User otherUser = suggestions[_i].user;

    if (suggestions[_i].liked == null) {
      setState(() {
        _i++;
      });
      DatabaseService.sendSuggestion(
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
    DatabaseService.deleteSuggestion(uid: user.uid, otherUid: otherUser.uid);
    _goneThrough.add(SuggestionGoneThrough(
      uid: user.uid,
      liked: false,
      similarityScore: suggestions[_i - 1].similarityScore,
    ));
  }

  void _undo() {
    String suggestionUserUid =
        Provider.of<UserSuggestions>(context).suggestions[_i - 1].user.uid;
    DatabaseService.undoSentSuggestion(
      Provider.of<CurrentUser>(context).user.uid,
      suggestionUserUid,
    );
    setState(() {
      _i--;
      _canUndo = false;
    });
  }

  void _like() async {
    final List<Suggestion> suggestions =
        Provider.of<UserSuggestions>(context).suggestions;
    final User user = Provider.of<CurrentUser>(context).user;
    final User otherUser = suggestions[_i].user;

    setState(() => user.numRightSwiped += 1);
    DatabaseService.setUserField(
        user.uid, "numRightSwiped", user.numRightSwiped);

    if (suggestions[_i].liked == true) {
      final bool undo = await Navigator.push(
        context,
        PageRouteBuilder(
          // page transition
          pageBuilder: (context, animation1, animation2) =>
              ItsAMatchPage(user: otherUser),
        ),
      );
      if (!undo) {
        DatabaseService.match(
            Provider.of<CurrentUser>(context).user.uid, otherUser.uid);
        setState(() {
          _i++;
          _canUndo = false;
        });
      }
    } else if (suggestions[_i].liked == null) {
      setState(() {
        _i++;
        _canUndo = true;
      });
      DatabaseService.sendSuggestion(
        fromUid: user.uid,
        toUid: otherUser.uid,
        liked: true,
      );
    } else {
      setState(() {
        _i++;
        _canUndo = true;
      });
    }

    DatabaseService.deleteSuggestion(uid: user.uid, otherUid: otherUser.uid);
    _goneThrough.add(SuggestionGoneThrough(
      uid: user.uid,
      liked: true,
      similarityScore: suggestions[_i - 1].similarityScore,
    ));
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
                        color: AppColors.gold,
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
                        color: AppColors.gold,
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
                        color: AppColors.gold,
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
                color: AppColors.gold,
                shadows: [Shadows.primaryShadow],
              ),
              child: Icon(
                Icons.close,
                color: AppColors.white,
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
                        color: AppColors.white,
                        shadows: [Shadows.primaryShadow],
                      ),
                      child:
                          Icon(Icons.undo, color: AppColors.black, size: 20.0),
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
                color: AppColors.gold,
                shadows: [Shadows.primaryShadow],
              ),
              child: Icon(
                Icons.done,
                color: AppColors.white,
                size: 30.0,
              ),
            ),
            onTap: _like,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final List<Suggestion> suggestions =
        Provider.of<UserSuggestions>(context).suggestions;
    final User user = _i < suggestions.length ? suggestions[_i].user : null;

    return Column(
      children: <Widget>[
        if (Provider.of<UserSuggestions>(context).loading)
          SizedBox(
            width: width - 80.0,
            height: height - 200.0,
            child: Center(
              child: Loader(),
            ),
          )
        else if (_i == suggestions.length ||
            user.numRightSwiped >= 10) // should be just == 10
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
                    "Try editing your filters to see more people",
                    style: TextStyle(
                      color: AppColors.grey,
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
              user: user,
              similarityScore: suggestions[_i].similarityScore == null
                  ? null
                  : suggestions[_i].similarityScore * 25,
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
