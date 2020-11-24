import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tundr/pages/profile_setup/interests.dart';
import 'package:tundr/repositories/registration_info.dart';
import 'package:tundr/services/media_picker_service.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';

class SetupProfilePicPage extends StatefulWidget {
  @override
  _SetupProfilePicPageState createState() => _SetupProfilePicPageState();
}

class _SetupProfilePicPageState extends State<SetupProfilePicPage> {
  void _selectImageFrom(ImageSource source) async {
    final profilePic = await MediaPickerService.pickMedia(
      type: MediaType.image,
      source: source,
      context: context,
    );
    if (profilePic != null) {
      setState(
          () => Provider.of<RegistrationInfo>(context).profilePic = profilePic);
    }
  }

  void _nextPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => SetupInterestsPage(),
        transitionsBuilder: (context, animation1, animation2, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0.0, 1.0),
              end: Offset(0.0, 0.0),
            ).animate(animation1),
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildSourceSelection() => Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: MyPalette.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: MyPalette.shadowGrey,
                      offset: Offset(0.0, 3.0),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.photo_camera,
                        color: MyPalette.gold,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Camera',
                        style: TextStyle(
                          color: MyPalette.gold,
                          fontSize: 20.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              onTap: () => _selectImageFrom(ImageSource.camera),
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: MyPalette.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: MyPalette.shadowGrey,
                      offset: Offset(0.0, 3.0),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.photo_library,
                        color: MyPalette.gold,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Gallery',
                        style: TextStyle(
                          color: MyPalette.gold,
                          fontSize: 20.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              onTap: () => _selectImageFrom(ImageSource.gallery),
            ),
          ),
        ],
      );

  Widget _buildImageAndReplacementOptions() {
    // FUTURE: improve this
    final profilePic = Provider.of<RegistrationInfo>(context).profilePic;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth,
            height: min(
                constraints.maxWidth, MediaQuery.of(context).size.height - 350),
            decoration: BoxDecoration(
              color: MyPalette.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [MyPalette.secondaryShadow],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.file(File(profilePic.url), fit: BoxFit.cover),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Replace',
          style: TextStyle(
            color: MyPalette.black,
            fontSize: 20.0,
          ),
        ),
        SizedBox(height: 10.0),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyPalette.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: MyPalette.shadowGrey,
                          offset: Offset(0.0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.photo_camera,
                            color: MyPalette.gold,
                            size: 30.0,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            'Camera',
                            style: TextStyle(
                              color: MyPalette.gold,
                              fontSize: 14.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () => _selectImageFrom(ImageSource.camera),
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyPalette.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: MyPalette.shadowGrey,
                          offset: Offset(0.0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.photo_library,
                              color: MyPalette.gold,
                              size: 30.0,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              'Gallery',
                              style: TextStyle(
                                color: MyPalette.gold,
                                fontSize: 14.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () => _selectImageFrom(ImageSource.gallery),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Align(
          alignment: Alignment.center,
          child: NextPageArrow(
            dark: false,
            onNextPage: _nextPage,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final profilePic = Provider.of<RegistrationInfo>(context).profilePic;
    return GestureDetector(
      child: SafeArea(
        child: Material(
          color: MyPalette.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 40.0),
                Text(
                  'Profile pic',
                  style: TextStyle(
                    color: MyPalette.black,
                    fontSize: 40.0,
                    fontFamily: 'Helvetica Neue',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40.0),
                Expanded(
                  child: profilePic == null
                      ? _buildSourceSelection()
                      : _buildImageAndReplacementOptions(),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if (details.delta.dy < -1.0 && profilePic != null) {
          _nextPage();
        } else if (details.delta.dy > 1.0) Navigator.pop(context);
      },
    );
  }
}
