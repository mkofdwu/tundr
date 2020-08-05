import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/repositories/current-user.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/pages/interests/interests-edit.dart';
import 'package:tundr/services/database-service.dart';
import 'package:tundr/services/storage-service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/constants/enums/mediatype.dart';
import 'package:tundr/pages/interests/widgets/interests-wrap.dart';
import 'package:tundr/widgets/media/extra-media-grid.dart';
import 'package:tundr/pages/personal-info/widgets/personal-info-list.dart';
import 'package:tundr/widgets/buttons/tile-icon.dart';

class OwnProfileEditPage extends StatefulWidget {
  @override
  _OwnProfileEditPageState createState() => _OwnProfileEditPageState();
}

class _OwnProfileEditPageState extends State<OwnProfileEditPage> {
  final TextEditingController _aboutMeController = TextEditingController();
  final FocusNode _aboutMeFocusNode = FocusNode();

  _previewProfile() => Navigator.pushNamed(
        context,
        "userprofile",
        arguments: Provider.of<CurrentUser>(context).user,
      );

  _updateAboutMe() {
    Provider.of<CurrentUser>(context).user.aboutMe = _aboutMeController.text;
    DatabaseService.setUserField(Provider.of<CurrentUser>(context).user.uid,
        "aboutMe", _aboutMeController.text);
  }

  _updateMedia() {
    DatabaseService.setUserField(
      Provider.of<CurrentUser>(context).user.uid,
      "extraMedia",
      List<Map<String, dynamic>>.from(Provider.of<CurrentUser>(context)
          .user
          .extraMedia
          .map((media) => media == null
              ? null
              : {
                  "type": MediaType.values.indexOf(media.type),
                  "url": media.url,
                })),
    );
  }

  _editInterests() => Navigator.push(
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
                  "No interests yet.\nClick to add your interests.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.grey,
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
    // FUTURE: refractor
    final User user = Provider.of<CurrentUser>(context).user;
    _aboutMeController.text = user.aboutMe;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: TileIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("My profile"),
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
                        "About me",
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 20.0,
                        ),
                      ),
                      _aboutMeFocusNode.hasFocus
                          ? GestureDetector(
                              child: Icon(
                                Icons.done,
                                color: AppColors.gold,
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
                                color: AppColors.gold,
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
                    "Photos and videos",
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  LayoutBuilder(
                    builder: (context, constraints) => ExtraMediaGrid(
                      size: constraints.maxWidth,
                      extraMedia: user.extraMedia,
                      onChangeMedia: (i, media) async {
                        print("changing media (uploading)");
                        media.url = await StorageService.uploadMedia(
                          uid: user.uid,
                          media: media,
                          oldUrl: user.extraMedia[i]?.url,
                          prefix: "extra_media",
                        );
                        media.isLocalFile = false;
                        if (mounted) {
                          setState(() => Provider.of<CurrentUser>(context)
                              .user
                              .extraMedia[i] = media);
                          _updateMedia();
                        }
                      },
                      onRemoveMedia: (i) {
                        StorageService.deleteMedia(user.extraMedia[i].url);
                        setState(() => user.extraMedia[i] = null);
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
                    "Personal info",
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 20.0,
                    ),
                  ),
                  PersonalInfoList(
                    onChanged: (name, value) {
                      DatabaseService.setUserField(
                        // CHANGED
                        user.uid,
                        name,
                        value,
                      );
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
                        "Interests",
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 20.0,
                        ),
                      ),
                      GestureDetector(
                        child:
                            Icon(Icons.edit, color: AppColors.gold, size: 20.0),
                        onTap: _editInterests,
                      ),
                    ],
                  ),
                  _buildInterests(user.interests + user.customInterests),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
