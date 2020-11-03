import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/current_user.dart';
import 'package:tundr/pages/interests/interests_edit.dart';

import 'package:tundr/services/storage_service.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/pages/interests/widgets/interests_wrap.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/widgets/media/extra_media_grid.dart';
import 'package:tundr/pages/personal_info/widgets/personal_info_list.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';

class OwnProfileEditPage extends StatefulWidget {
  @override
  _OwnProfileEditPageState createState() => _OwnProfileEditPageState();
}

class _OwnProfileEditPageState extends State<OwnProfileEditPage> {
  final TextEditingController _aboutMeController = TextEditingController();
  final FocusNode _aboutMeFocusNode = FocusNode();

  void _previewProfile() => Navigator.pushNamed(
        context,
        'userprofile',
        arguments: Provider.of<CurrentUser>(context).profile,
      );

  void _updateAboutMe() {
    Provider.of<CurrentUser>(context).profile.aboutMe = _aboutMeController.text;
    UsersService.setProfileField(Provider.of<CurrentUser>(context).profile.uid,
        'aboutMe', _aboutMeController.text);
  }

  void _updateMedia() {
    UsersService.setProfileField(
      Provider.of<CurrentUser>(context).profile.uid,
      'extraMedia',
      List<Map<String, dynamic>>.from(Provider.of<CurrentUser>(context)
          .profile
          .extraMedia
          .map((media) => media == null
              ? null
              : {
                  'type': MediaType.values.indexOf(media.type),
                  'url': media.url,
                })),
    );
  }

  void _editInterests() => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => InterestsEditPage(),
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(
                opacity: animation1, child: child); // ANIMATION
          },
        ),
      ).then((_) => setState(() {}));

  Widget _buildInterests(List<String> allInterests) {
    return allInterests.isEmpty
        ? GestureDetector(
            child: SizedBox(
              height: 150.0,
              child: Center(
                child: Text(
                  'No interests yet.\nClick to add your interests.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MyPalette.grey,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            onTap: _editInterests,
          )
        : InterestsWrap(interests: allInterests);
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<CurrentUser>(context).profile;
    _aboutMeController.text = profile.aboutMe;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: TileIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('My profile'),
        actions: <Widget>[
          TileIconButton(
            icon: Icons.remove_red_eye, // DESIGN: find better icon
            onPressed: _previewProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'About me',
                        style: TextStyle(
                          color: MyPalette.gold,
                          fontSize: 20.0,
                        ),
                      ),
                      _aboutMeFocusNode.hasFocus
                          ? GestureDetector(
                              child: Icon(
                                Icons.done,
                                color: MyPalette.gold,
                                size: 20.0,
                              ),
                              onTap: () {
                                _aboutMeFocusNode.unfocus();
                                _updateAboutMe();
                                setState(() {});
                              },
                            )
                          : GestureDetector(
                              child: Icon(
                                Icons.edit,
                                color: MyPalette.gold,
                                size: 20.0,
                              ),
                              onTap: () => FocusScope.of(context)
                                  .requestFocus(_aboutMeFocusNode),
                            ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    maxLines: null,
                    decoration: null,
                    keyboardType: TextInputType.multiline,
                    controller: _aboutMeController,
                    focusNode: _aboutMeFocusNode,
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Photos and videos',
                    style: TextStyle(
                      color: MyPalette.gold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  LayoutBuilder(
                    builder: (context, constraints) => ExtraMediaGrid(
                      size: constraints.maxWidth,
                      extraMedia: profile.extraMedia,
                      onChangeMedia: (i, media) async {
                        media.url = await StorageService.uploadMedia(
                          uid: profile.uid,
                          media: media,
                          oldUrl: profile.extraMedia[i]?.url,
                          prefix: 'extra_media',
                        );
                        media.isLocalFile = false;
                        if (mounted) {
                          setState(() => Provider.of<CurrentUser>(context)
                              .profile
                              .extraMedia[i] = media);
                          _updateMedia();
                        }
                      },
                      onRemoveMedia: (i) {
                        StorageService.deleteMedia(profile.extraMedia[i].url);
                        setState(() => profile.extraMedia[i] = null);
                        _updateMedia();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Personal info',
                    style: TextStyle(
                      color: MyPalette.gold,
                      fontSize: 20.0,
                    ),
                  ),
                  PersonalInfoList(
                    personalInfo: profile.personalInfo,
                    onChanged: (name, value) {
                      final updatedPersonalInfo = {
                        ...profile.personalInfo,
                        name: value,
                      };
                      UsersService.setProfileField(
                          profile.uid, 'personalInfo', updatedPersonalInfo);
                      setState(() {});
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Interests',
                        style: TextStyle(
                          color: MyPalette.gold,
                          fontSize: 20.0,
                        ),
                      ),
                      GestureDetector(
                        child:
                            Icon(Icons.edit, color: MyPalette.gold, size: 20.0),
                        onTap: _editInterests,
                      ),
                    ],
                  ),
                  _buildInterests(profile.interests + profile.customInterests),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
