import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:tundr/repositories/current_user.dart';
import 'package:tundr/pages/own_profile.dart';
import 'package:tundr/pages/settings/settings.dart';

import 'package:tundr/services/database_service.dart';
import 'package:tundr/services/media_picker_service.dart';
import 'package:tundr/services/storage_service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/enums/media_type.dart';
import 'package:tundr/constants/gradients.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/widgets/buttons/simple_icon.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
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
    SchedulerBinding.instance.addPostFrameCallback((duration) =>
        _nameController.text = Provider.of<CurrentUser>(context).user.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CurrentUser>(context).user;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Material(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                GestureDetector(
                  child: getNetworkImage(
                    user.profileImageUrl,
                    width: width,
                    height: height / 2,
                  ),
                  onTap: _changeProfilePic,
                ),
                fromTheme(
                  context,
                  dark: Container(
                    width: width,
                    height: 100.0,
                    decoration: BoxDecoration(
                      gradient: Gradients.blackToTransparent,
                    ),
                  ),
                  light: SizedBox.shrink(),
                ),
                TileIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () => Navigator.pop(context),
                ),
                Positioned(
                  bottom: 0.0,
                  child: Container(
                    width: width,
                    height: 100.0,
                    // padding:
                    //     EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      gradient: Gradients.transparentToBlack,
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
                                        cursorColor: AppColors.white,
                                        backgroundCursorColor: AppColors.white,
                                        style: TextStyle(
                                          color: AppColors.white,
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
                                                text: user.name,
                                                style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 30.0,
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: VerifiedBadge(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Born ${DateFormat.yMd().format(user.birthday)}',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SimpleIconButton(
                            icon: Icons.edit,
                            color: AppColors.white,
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
              child: user.popularityHistory.isEmpty
                  ? Center(
                      child: Text(
                        'Your popularity history will be shown here',
                        style: TextStyle(
                          color: AppColors.grey,
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
                                    spots: List<FlSpot>.from(user
                                        .popularityHistory.entries
                                        .map((entry) => FlSpot(
                                              entry.key.toDouble(),
                                              entry.value.toDouble(),
                                            ))),
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
                                    color: AppColors.gold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  user.popularityScore.toString(),
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                  ),
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
                    icon: Icons.settings,
                    label: 'Settings',
                    onPressed: _openSettings,
                  ),
                  SimpleIconButton(
                    icon: Icons.person,
                    label: 'Profile',
                    onPressed: _openOwnProfileEdit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editName() {
    setState(() => _editingName = true);
    FocusScope.of(context).requestFocus(_nameFocusNode);
  }

  void _changeName() {
    Provider.of<CurrentUser>(context).user.name = _nameController.text;
    DatabaseService.setUserField(
      Provider.of<CurrentUser>(context).user.uid,
      'name',
      _nameController.text,
    );
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
      uid: Provider.of<CurrentUser>(context).user.uid,
      media: imageMedia,
      prefix: 'profile_image',
    );
    await DatabaseService.setUserField(
      Provider.of<CurrentUser>(context).user.uid,
      'profileImageUrl',
      newProfileImageUrl,
    );
    setState(() => Provider.of<CurrentUser>(context).user.profileImageUrl =
        newProfileImageUrl);
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
          pageBuilder: (context, animation1, animation2) =>
              OwnProfileEditPage(),
          // transitionsBuilder: (context, animation1, animation2) { ANIMATION

          // },
        ),
      );
}
