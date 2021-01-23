import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tundr/pages/setup/interests.dart';
import 'package:tundr/store/registration_info.dart';
import 'package:tundr/services/media_picker_service.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/widgets/pages/scroll_down.dart';
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
      setState(() {
        Provider.of<RegistrationInfo>(context, listen: false).profilePic =
            profilePic;
      });
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
              begin: Offset(0, 1),
              end: Offset(0, 0),
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
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [MyPalette.primaryShadow],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.photo_camera,
                        color: MyPalette.gold,
                        size: 100,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Camera',
                        style: TextStyle(
                          color: MyPalette.gold,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              onTap: () => _selectImageFrom(ImageSource.camera),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: MyPalette.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [MyPalette.primaryShadow],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.photo_library,
                        color: MyPalette.gold,
                        size: 100,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Gallery',
                        style: TextStyle(
                          color: MyPalette.gold,
                          fontSize: 20,
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
    final profilePic =
        Provider.of<RegistrationInfo>(context, listen: false).profilePic;
    return Column(
      children: <Widget>[
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => Container(
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: MyPalette.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [MyPalette.secondaryShadow],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.file(File(profilePic.url), fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Replace',
            style: TextStyle(
              color: MyPalette.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: MyPalette.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [MyPalette.primaryShadow],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.photo_camera,
                          color: MyPalette.gold,
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Camera',
                          style: TextStyle(
                            color: MyPalette.gold,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () => _selectImageFrom(ImageSource.camera),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: GestureDetector(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: MyPalette.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [MyPalette.primaryShadow],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) => Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.photo_library,
                            color: MyPalette.gold,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Gallery',
                            style: TextStyle(
                              color: MyPalette.gold,
                              fontSize: 16,
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
        SizedBox(height: 30),
        ScrollDownArrow(
          dark: false,
          onNextPage: _nextPage,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final profilePic =
        Provider.of<RegistrationInfo>(context, listen: false).profilePic;
    return ScrollDownPage(
      color: MyPalette.white,
      builder: (context, width, height) => Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            Text(
              'Profile pic',
              style: TextStyle(
                color: MyPalette.black,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: profilePic == null
                  ? _buildSourceSelection()
                  : _buildImageAndReplacementOptions(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      canScrollDown: profilePic != null,
      onScrollDown: _nextPage,
    );
  }
}
