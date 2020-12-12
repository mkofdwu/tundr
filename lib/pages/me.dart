import 'package:feature_discovery/feature_discovery.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:tundr/repositories/user.dart';

import 'package:tundr/services/media_picker_service.dart';
import 'package:tundr/services/storage_service.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/utils/show_options_dialog.dart';
import 'package:tundr/widgets/buttons/back.dart';
import 'package:tundr/widgets/buttons/simple_icon.dart';
import 'package:tundr/widgets/my_feature.dart';
import 'package:tundr/widgets/verified_badge.dart';

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  bool _editingName = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _nameController.text =
          Provider.of<User>(context, listen: false).profile.name;
      FeatureDiscovery.discoverFeatures(
          context, <String>['popularity_history_chart']);
    });
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
                height: 100,
                decoration: BoxDecoration(
                  gradient: MyPalette.blackToTransparent,
                ),
              ),
              MyBackButton(iconColor: MyPalette.white),
              Positioned(
                bottom: 0,
                child: Container(
                  width: width,
                  height: 120,
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
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
                                  ? TextField(
                                      controller: _nameController,
                                      focusNode: _nameFocusNode,
                                      cursorColor: MyPalette.white,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                        color: MyPalette.white,
                                        fontSize: 30,
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
                                                fontSize: 30,
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
                              SizedBox(height: 5),
                              Text(
                                'Born ${DateFormat.yMd().format(profile.birthday)}',
                                style: TextStyle(
                                  color: MyPalette.white,
                                  fontSize: 16,
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
            child: Container(
              transform: fromTheme(
                context,
                dark: Matrix4.identity(),
                light: Matrix4.translationValues(0, -30, 0),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: fromTheme(
                  context,
                  dark: BorderRadius.zero,
                  light: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 20),
                child: privateInfo.popularityHistory.length < 2
                    ? Center(
                        child: Text(
                          'Your popularity history will be shown here',
                          style: TextStyle(
                            color: MyPalette.grey,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Popularity',
                            style: TextStyle(
                              color: MyPalette.gold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(privateInfo.popularityScore.toString()),
                          SizedBox(height: 20),
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: MyFeature(
                                featureId: 'popularity_history_chart',
                                tapTarget: SizedBox.shrink(),
                                title: 'Popularity history chart',
                                description:
                                    "Your popularity score is updated every day. It's based on how many people swipe right on your profile, and the average is always kept at 100",
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
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SimpleIconButton(
                  key: ValueKey('settingsBtn'),
                  icon: Icons.settings,
                  size: 34,
                  label: 'Settings',
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                ),
                SimpleIconButton(
                  key: ValueKey('myProfileBtn'),
                  icon: Icons.person,
                  size: 34,
                  label: 'Profile',
                  onPressed: () =>
                      Navigator.pushNamed(context, '/edit_profile'),
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
    _nameFocusNode.requestFocus();
  }

  void _changeName() {
    Provider.of<User>(context, listen: false)
        .updateProfile({'name': _nameController.text});
    setState(() => _editingName = false);
  }

  void _changeProfilePic() async {
    final source = await showOptionsDialog(
      context: context,
      title: 'Change profile picture',
      options: {
        'Camera': ImageSource.camera,
        'Gallery': ImageSource.gallery,
      },
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
}
