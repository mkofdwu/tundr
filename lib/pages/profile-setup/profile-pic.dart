import 'dart:io';
import 'dart:math';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/registration-info.dart';
import 'package:tundr/pages/profile-setup/extra-info.dart';
import 'package:tundr/services/media-picker-service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/constants/enums/mediatype.dart';
import 'package:tundr/constants/shadows.dart';
import 'package:tundr/widgets/scroll-down-arrow.dart';
import "package:tundr/models/media.dart";

class SetupProfilePicPage extends StatefulWidget {
  @override
  _SetupProfilePicPageState createState() => _SetupProfilePicPageState();
}

class _SetupProfilePicPageState extends State<SetupProfilePicPage> {
  _selectImageFrom(ImageSource source) async {
    final Media profilePic = await MediaPickerService.pickMedia(
      type: MediaType.image,
      source: source,
      context: context,
    );
    if (profilePic != null)
      setState(
          () => Provider.of<RegistrationInfo>(context).profilePic = profilePic);
  }

  _nextPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => SetupExtraInfoPage(),
        transitionsBuilder: (context, animation1, animation2, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0.0, 0.1),
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
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowGrey,
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
                        color: AppColors.gold,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Camera",
                        style: TextStyle(
                          color: AppColors.gold,
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
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowGrey,
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
                        color: AppColors.gold,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Gallery",
                        style: TextStyle(
                          color: AppColors.gold,
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
    final Media profilePic = Provider.of<RegistrationInfo>(context).profilePic;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth,
            height: min(
                constraints.maxWidth, MediaQuery.of(context).size.height - 350),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [Shadows.secondaryShadow],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.file(File(profilePic.url), fit: BoxFit.cover),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          "Replace",
          style: TextStyle(
            color: AppColors.black,
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
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowGrey,
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
                            color: AppColors.gold,
                            size: 30.0,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            "Camera",
                            style: TextStyle(
                              color: AppColors.gold,
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
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowGrey,
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
                              color: AppColors.gold,
                              size: 30.0,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                color: AppColors.gold,
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
    final Media profilePic = Provider.of<RegistrationInfo>(context).profilePic;
    return GestureDetector(
      child: SafeArea(
        child: Material(
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 40.0),
                Text(
                  "Profile pic",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 40.0,
                    fontFamily: "Helvetica Neue",
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
      onVerticalDragUpdate: profilePic == null
          ? null
          : (DragUpdateDetails details) {
              if (details.delta.dy < -1.0)
                _nextPage();
              else if (details.delta.dy > 1.0) Navigator.pop(context);
            },
    );
  }
}
