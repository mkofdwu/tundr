import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/pages/interests/widgets/interests_wrap.dart';

class PersonalInfoProfilePage extends StatefulWidget {
  @override
  _PersonalInfoProfilePageState createState() =>
      _PersonalInfoProfilePageState();
}

class _PersonalInfoProfilePageState extends State<PersonalInfoProfilePage> {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 1);
  bool _scrolledToTopOnce = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset == 0) {
        if (_scrolledToTopOnce) {
          Navigator.pop(context);
        } else {
          _scrolledToTopOnce = true;
          Timer(Duration(milliseconds: 1), () => _scrollController.jumpTo(1));
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _scrolledToTopOnce = false;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ModalRoute.of(context).settings.arguments as UserProfile;
    return Material(
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height + 1,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                TileIconButton(
                  icon: Icons.close,
                  iconSize: 30,
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      (route) => route.settings.name == '/profile',
                    );
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 20),
                Column(
                  children:
                      List<Widget>.from(profile.personalInfo.keys.map((name) {
                    final dynamic value = profile.personalInfo[name];
                    if (value == null ||
                        ((value is String || value is List) && value.isEmpty)) {
                      return SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 100),
                            child: Text(
                              value is List
                                  ? value.join(', ')
                                  : value.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
                ),
                SizedBox(height: 30),
                profile.interests.isEmpty
                    ? Text(
                        'No interests',
                        style: TextStyle(
                          color: MyPalette.grey,
                          fontSize: 16,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Interests',
                              style: TextStyle(
                                color: MyPalette.gold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          InterestsWrap(interests: profile.interests),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
