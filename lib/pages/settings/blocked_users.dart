import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/repositories/user.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/widgets/buttons/flat_tile.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';

class BlockedUsersPage extends StatefulWidget {
  @override
  _BlockedUsersPageState createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  @override
  Widget build(BuildContext context) {
    final blocked =
        Provider.of<User>(context, listen: false).privateInfo.blocked;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TileIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Blocked users'),
      ),
      body: blocked.isEmpty
          ? Center(
              child: Text(
                'No blocked users',
                style: TextStyle(
                  color: MyPalette.grey,
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              itemCount: blocked.length,
              itemBuilder: (context, i) => FutureBuilder<UserProfile>(
                future: UsersService.getUserProfile(blocked[i]),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return SizedBox.shrink();
                  final user = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 50,
                          decoration: fromTheme(
                            context,
                            dark: BoxDecoration(
                              border:
                                  Border.all(color: MyPalette.white, width: 1),
                            ),
                            light: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [MyPalette.primaryShadow],
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: fromTheme(
                              context,
                              dark: BorderRadius.zero,
                              light: BorderRadius.circular(10),
                            ),
                            child: getNetworkImage(user.profileImageUrl),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            user.name,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        FlatTileButton(
                          text: 'Unblock',
                          color: MyPalette.red,
                          onTap: () {
                            Provider.of<User>(context, listen: false)
                                .privateInfo
                                .blocked
                                .remove(user.uid);
                            Provider.of<User>(context, listen: false)
                                .writeField('blocked', UserPrivateInfo);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
