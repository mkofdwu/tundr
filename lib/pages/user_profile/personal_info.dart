import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/pages/interests/widgets/interests_wrap.dart';

class UserProfilePersonalInfoPage extends StatefulWidget {
  final User user;

  UserProfilePersonalInfoPage({Key key, @required this.user}) : super(key: key);

  @override
  _UserProfilePersonalInfoPageState createState() =>
      _UserProfilePersonalInfoPageState();
}

class _UserProfilePersonalInfoPageState
    extends State<UserProfilePersonalInfoPage> {
  final ScrollController _scrollController = ScrollController();
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
          _scrollController.jumpTo(1.0);
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
    return SafeArea(
      child: Material(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.only(
            left: 30.0,
            top: 1.0,
            right: 30.0,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              children: <Widget>[
                TileIconButton(
                  // FUTURE: design inspiration from centered close button to provide a nicer design
                  icon: Icons.close,
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      (route) => route.settings.name == 'userprofile',
                    );
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 30.0),
                Column(
                  children: List<Widget>.from(
                      widget.user.personalInfo.keys.map((name) {
                    final dynamic value = widget.user.personalInfo[name];
                    assert(value != null);
                    if ((value is String || value is List) && value.isEmpty) {
                      return SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            name,
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20.0,
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 100.0),
                            child: Text(
                              value is List
                                  ? value.join(', ')
                                  : value.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
                ),
                SizedBox(height: 30.0),
                Container(
                  width: 100.0,
                  height: 5.0,
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(height: 30.0),
                widget.user.interests.isEmpty
                    ? Text(
                        'No interests',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 16.0,
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
                                color: AppColors.gold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          InterestsWrap(interests: widget.user.interests),
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
