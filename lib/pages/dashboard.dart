import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/pages/profile.dart';
import 'package:tundr/pages/settings/settings.dart';

import 'package:tundr/services/media_picker_service.dart';
import 'package:tundr/services/storage_service.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/widgets/buttons/back.dart';
import 'package:tundr/widgets/buttons/simple_icon.dart';
import 'package:tundr/widgets/verified_badge.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  bool _editingName = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) => _nameController
        .text = Provider.of<User>(context, listen: false).profile.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<User>(context, listen: false).profile;
    final privateInfo = Provider.of<User>(context, listen: false).privateInfo;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Material(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              GestureDetector(
                child: getNetworkImage(
                  profile.profileImageUrl,
                  width: width,
                  height: height / 2,
                ),
                onTap: _changeProfilePic,
              ),
              Container(
                width: width,
                height: 100.0,
                decoration: BoxDecoration(
                  gradient: MyPalette.blackToTransparent,
                ),
              ),
              MyBackButton(iconColor: MyPalette.white),
              Positioned(
                bottom: 0.0,
                child: Container(
                  width: width,
                  height: 100.0,
                  // padding:
                  //     EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    gradient: MyPalette.transparentToBlack,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _editingName
                                  ? EditableText(
                                      controller: _nameController,
                                      focusNode: _nameFocusNode,
                                      cursorColor: MyPalette.white,
                                      backgroundCursorColor: MyPalette.white,
                                      style: TextStyle(
                                        color: MyPalette.white,
                                        fontSize: 30.0,
                                      ),
                                      onEditingComplete: _changeName,
                                    )
                                  : GestureDetector(
                                      onTap: _editName,
                                      child: RichText(
                                        text: TextSpan(
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text: profile.name,
                                              style: TextStyle(
                                                color: MyPalette.white,
                                                fontSize: 30.0,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: VerifiedBadge(
                                                color: MyPalette.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              SizedBox(height: 5.0),
                              Text(
                                'Born ${DateFormat.yMd().format(profile.birthday)}',
                                style: TextStyle(
                                  color: MyPalette.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SimpleIconButton(
                          icon: Icons.edit,
                          color: MyPalette.white,
                          onPressed: _editName, // BACKEND
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: privateInfo.popularityHistory.isEmpty
                ? Center(
                    child: Text(
                      'Your popularity history will be shown here',
                      style: TextStyle(
                        color: MyPalette.grey,
                        fontSize: 16.0,
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  colors: [Theme.of(context).accentColor],
                                  dotData: FlDotData(show: false),
                                  spots: List<FlSpot>.from(privateInfo
                                      .popularityHistory
                                      .map((entryString) {
                                    // each entry string is formatted as: `timestamp:score`
                                    final entry = entryString.split(':');
                                    return FlSpot(
                                      double.parse(entry[0]),
                                      double.parse(entry[1]),
                                    );
                                  })),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Popularity',
                                style: TextStyle(
                                  color: MyPalette.gold,
                                  fontSize: 20.0,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                privateInfo.popularityScore.toString(),
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SimpleIconButton(
                  key: ValueKey('settingsBtn'),
                  icon: Icons.settings,
                  size: 34,
                  label: 'Settings',
                  onPressed: _openSettings,
                ),
                SimpleIconButton(
                  key: ValueKey('myProfileBtn'),
                  icon: Icons.person,
                  size: 34,
                  label: 'Profile',
                  onPressed: _openOwnProfileEdit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editName() {
    setState(() => _editingName = true);
    FocusScope.of(context).requestFocus(_nameFocusNode);
  }

  void _changeName() {
    Provider.of<User>(context, listen: false)
        .updateProfile({'name': _nameController.text});
    setState(() => _editingName = false);
  }

  void _changeProfilePic() async {
    // FUTURE: better ui for selecting source
    final source = await showDialog(
      context: context,
      child: SimpleDialog(
        title: Text('Change profile picture'),
        children: <Widget>[
          FlatButton(
            child: Text('Camera'),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          FlatButton(
            child: Text('Gallery'),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );
    if (source == null) return;
    final imageMedia = await MediaPickerService.pickMedia(
      type: MediaType.image,
      source: source,
      context: context,
    );
    if (imageMedia == null) return;
    final newProfileImageUrl = await StorageService.uploadMedia(
      uid: Provider.of<User>(context, listen: false).profile.uid,
      media: imageMedia,
      prefix: 'profile_image',
    );
    await Provider.of<User>(context, listen: false)
        .updateProfile({'profileImageUrl': newProfileImageUrl});
  }

  void _openSettings() => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => SettingsPage(),
          // transitionsBuilder: (context, animation1, animation2) { ANIMATION

          // },
        ),
      );

  void _openOwnProfileEdit() => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => ProfileEditPage(),
          // transitionsBuilder: (context, animation1, animation2) { ANIMATION

          // },
        ),
      );
}
