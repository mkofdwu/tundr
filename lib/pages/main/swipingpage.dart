import "package:flutter/widgets.dart";
import 'package:provider/provider.dart';
import 'package:tundr/models/providerdata.dart';
import 'package:tundr/models/suggestion.dart';
import 'package:tundr/models/suggestiongonethrough.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/pages/main/itsamatchpage.dart';
import 'package:tundr/services/databaseservice.dart';
import 'package:tundr/utils/constants/colors.dart';

import "package:flutter/material.dart";
import 'package:tundr/utils/constants/values.dart';
import 'package:tundr/utils/constants/shadows.dart';
import 'package:tundr/widgets/loaders/loader.dart';
import 'package:tundr/widgets/swipingpage/suggestioncard.dart';
import 'package:tundr/widgets/themebuilder.dart'; // for icons, remove when alternative image has been found

class SwipingPage extends StatefulWidget {
  @override
  _SwipingPageState createState() => _SwipingPageState();
}

class _SwipingPageState extends State<SwipingPage> {
  List<Suggestion> _suggestions = [];
  List<SuggestionGoneThrough> _goneThrough = [];
  int _i = 0;
  bool _canUndo = false;
  bool _sendPreviousSuggestion =
      false; // a bit ugly, temporary solution (FUTURE)
  int _handledUpToSuggestion = -1;
  bool _previousSuggestionLiked; //
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _loadState());
  }

  @override
  void deactivate() {
    // TODO: send previousSuggestion to server when the user leaves the page
    DatabaseService.addUserSuggestionsGoneThrough(
        Provider.of<ProviderData>(context).user.uid, _goneThrough);
    super.deactivate();
  }

  _loadState() async {
    // TODO: make this faster (profile / time, then optimize)
    // TODO: FUTURE: move load suggestions to when the app starts
    if (mounted) setState(() => _loading = true);

    final User user = Provider.of<ProviderData>(context).user;

    final List<Suggestion> storedSuggestions =
        await DatabaseService.getUserSuggestions(user.uid);
    print("stored suggestions retrieved: ");
    storedSuggestions.forEach((s) {
      print("${s.user.name}: ${s.similarityScore}");
    });

    final int millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;

    print(
        "last generated suggestions on: ${DateTime.fromMillisecondsSinceEpoch(user.lastGeneratedSuggestionsTimestamp)}");
    user.lastGeneratedSuggestionsTimestamp = 0;

    if (user.lastGeneratedSuggestionsTimestamp + millisecondsInTwoHours <=
        millisecondsSinceEpoch) {
      user.lastGeneratedSuggestionsTimestamp = millisecondsSinceEpoch;
      user.numRightSwiped = 0;
      DatabaseService.setUserFields(user.uid, {
        "lastGeneratedSuggestionsTimestamp":
            user.lastGeneratedSuggestionsTimestamp,
        "numRightSwiped": user.numRightSwiped,
      });

      if (numSuggestionsEveryTwoHours > storedSuggestions.length) {
        final List<Suggestion> newSuggestions =
            await DatabaseService.generateSuggestions(
          currentUser: user,
          n: numSuggestionsEveryTwoHours - storedSuggestions.length,
          storedSuggestionUids: storedSuggestions
              .map((suggestion) => suggestion.user.uid)
              .toList(),
          suggestionsGoneThrough:
              await DatabaseService.getUserSuggestionsGoneThrough(user.uid),
        );
        print("new suggestions: $newSuggestions");
        _suggestions.addAll(newSuggestions);
        DatabaseService.saveNewSuggestions(
          user.uid,
          newSuggestions,
        );
      }
    }

    _suggestions.addAll(storedSuggestions.take(numSuggestionsEveryTwoHours));

    if (mounted) setState(() => _loading = false);
  }

  Future<void> _handlePreviousSuggestion() async {
    final User user = Provider.of<ProviderData>(context).user;
    final User otherUser = _suggestions[_i - 1].user;

    if (_handledUpToSuggestion < _i - 1) {
      print("registering swipe on user: ${otherUser.name}");
      if (_sendPreviousSuggestion) {
        await DatabaseService.sendSuggestion(
          fromUid: user.uid,
          toUid: otherUser.uid,
          liked: _previousSuggestionLiked,
        );
      }

      if (_i > 0) {
        DatabaseService.deleteSuggestion(
            uid: user.uid, otherUid: otherUser.uid);
        _goneThrough.add(SuggestionGoneThrough(
          uid: user.uid,
          liked: _previousSuggestionLiked,
          similarityScore: _suggestions[_i - 1].similarityScore,
        ));
      }
      setState(() => _handledUpToSuggestion = _i - 1);
    }
  }

  void _nope() async {
    // animate card slide to left (ease out?)

    print("current index: " + _i.toString());
    if (_i > 0) await _handlePreviousSuggestion();

    if (_suggestions[_i].liked == null)
      setState(() {
        _sendPreviousSuggestion = true;
        _previousSuggestionLiked = false;
        _i++;
        _canUndo = true;
      });
    else
      setState(() {
        _sendPreviousSuggestion = false;
        _i++;
        _canUndo = true;
      });

    if (_i == _suggestions.length) {
      _handlePreviousSuggestion();
    }
  }

  void _undo() => setState(() {
        _sendPreviousSuggestion = false;
        _i--;
        _canUndo = false;
      });

  void _like() async {
    // animate card slide to right (ease out)

    final User user = Provider.of<ProviderData>(context).user;

    print("current index: " + _i.toString());

    if (_i > 0) await _handlePreviousSuggestion();

    print(_suggestions[_i].user.name +
        " liked you: " +
        _suggestions[_i].liked.toString());

    setState(() => user.numRightSwiped += 1);
    DatabaseService.setUserField(
        user.uid, "numRightSwiped", user.numRightSwiped);

    if (_suggestions[_i].liked == true) {
      final bool undo = await Navigator.push(
        context,
        PageRouteBuilder(
          // page transition
          pageBuilder: (context, animation1, animation2) =>
              ItsAMatchPage(user: _suggestions[_i].user),
        ),
      );
      if (!undo) {
        DatabaseService.match(Provider.of<ProviderData>(context).user.uid,
            _suggestions[_i].user.uid);
        setState(() {
          _sendPreviousSuggestion = false;
          _i++;
          _canUndo = false;
        });
      }
    } else {
      if (_suggestions[_i].liked == null)
        setState(() {
          _sendPreviousSuggestion = true;
          _previousSuggestionLiked = true;
          _i++;
          _canUndo = true;
        });
      else
        setState(() {
          _sendPreviousSuggestion = false;
          _i++;
          _canUndo = true;
        });
    }

    if (_i == _suggestions.length) {
      _handlePreviousSuggestion();
    }
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
    final User user = _i < _suggestions.length ? _suggestions[_i].user : null;
    // _suggestions.forEach((s) {
    //   print(s.user.name + ": " + s.similarityScore.toString());
    // });
    return Column(
      children: <Widget>[
        if (_loading)
          SizedBox(
            width: width - 80.0,
            height: height - 200.0,
            child: Center(
              child: Loader(),
            ),
          )
        else if (_i == _suggestions.length ||
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
              similarityScore: _suggestions[_i].similarityScore == null
                  ? null
                  : _suggestions[_i].similarityScore * 25,
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
