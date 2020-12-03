import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/pages/interests/edit_interests.dart';
import 'package:tundr/pages/interests/widgets/interests_wrap.dart';
import 'package:tundr/pages/personal_info/widgets/personal_info_list.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/services/storage_service.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/media/extra_media_grid.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _aboutMeController = TextEditingController();
  final FocusNode _aboutMeFocusNode = FocusNode();

  void _previewProfile() => Navigator.pushNamed(
        context,
        '/profile',
        arguments: Provider.of<User>(context, listen: false).profile,
      );

  void _updateAboutMe() {
    Provider.of<User>(context, listen: false)
        .updateProfile({'aboutMe': _aboutMeController.text});
  }

  void _updateMedia() {
    Provider.of<User>(context, listen: false).updateProfile({
      'extraMedia': Provider.of<User>(context, listen: false)
          .profile
          .extraMedia
          .map((media) => media == null
              ? null
              : {
                  'type': MediaType.values.indexOf(media.type),
                  'url': media.url,
                })
    });
  }

  void _editInterests() => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => EditInterestsPage(),
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
              height: 150,
              child: Center(
                child: Text(
                  'No interests yet.\nClick to add your interests.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MyPalette.grey,
                    fontSize: 16,
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
    final width = MediaQuery.of(context).size.width;
    final profile = Provider.of<User>(context, listen: false).profile;
    _aboutMeController.text = profile.aboutMe;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TileIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('My profile'),
        actions: <Widget>[
          DescribedFeatureOverlay(
            featureId: 'preview_profile',
            tapTarget: Icon(Icons.remove_red_eye),
            title: Text('Preview profile'),
            description: Text(
                'Click on this eye to learn how others will view your profile'),
            targetColor: MyPalette.white.withOpacity(0.8),
            backgroundColor: Theme.of(context).accentColor,
            child: TileIconButton(
              icon: Icons.remove_red_eye, // DESIGN: find better icon
              onPressed: _previewProfile,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
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
                          fontSize: 20,
                        ),
                      ),
                      _aboutMeFocusNode.hasFocus
                          ? GestureDetector(
                              key: ValueKey('updateAboutMeBtn'),
                              child: Icon(
                                Icons.done,
                                color: MyPalette.gold,
                                size: 20,
                              ),
                              onTap: () {
                                _aboutMeFocusNode.unfocus();
                                _updateAboutMe();
                                setState(() {});
                              },
                            )
                          : GestureDetector(
                              key: ValueKey('editAboutMeBtn'),
                              child: Icon(
                                Icons.edit,
                                color: MyPalette.gold,
                                size: 20,
                              ),
                              onTap: () => FocusScope.of(context)
                                  .requestFocus(_aboutMeFocusNode),
                            ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    key: ValueKey('aboutMeField'),
                    maxLines: null,
                    decoration: null,
                    keyboardType: TextInputType.multiline,
                    controller: _aboutMeController,
                    focusNode: _aboutMeFocusNode,
                  ),
                ],
              ),
              SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Photos and videos',
                    style: TextStyle(
                      color: MyPalette.gold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 16),
                  ExtraMediaGrid(
                    size: width - 60,
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
                        setState(() => Provider.of<User>(context, listen: false)
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
                ],
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Personal info',
                    style: TextStyle(
                      color: MyPalette.gold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  PersonalInfoList(
                    personalInfo: profile.personalInfo,
                    onChanged: (name, value) {
                      Provider.of<User>(context, listen: false)
                          .profile
                          .personalInfo[name] = value;
                      Provider.of<User>(context, listen: false)
                          .writeField('personalInfo', UserProfile);
                      setState(() {});
                    },
                  ),
                ],
              ),
              SizedBox(height: 24),
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
                          fontSize: 20,
                        ),
                      ),
                      GestureDetector(
                        child:
                            Icon(Icons.edit, color: MyPalette.gold, size: 20),
                        onTap: _editInterests,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _buildInterests(profile.interests + profile.customInterests),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}