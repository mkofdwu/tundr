import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/repositories/provider-data.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/services/database-service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/constants/shadows.dart';
import 'package:tundr/utils/from-theme.dart';
import 'package:tundr/utils/get-network-image.dart';
import 'package:tundr/widgets/buttons/flat-tile.dart';
import 'package:tundr/widgets/buttons/tile-icon.dart';

class BlockedUsersPage extends StatefulWidget {
  @override
  _BlockedUsersPageState createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: TileIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Blocked users"),
      ),
      body: FutureBuilder<List<String>>(
        future: DatabaseService.getUserBlockedUids(
            Provider.of<ProviderData>(context).user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data.isEmpty)
            return Center(
              child: Text(
                "No blocked users",
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 16.0,
                ),
              ),
            );
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) => FutureBuilder<User>(
              future: DatabaseService.getUser(snapshot.data[i]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SizedBox.shrink();
                final User user = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: fromTheme(
                          context,
                          dark: BoxDecoration(
                            border:
                                Border.all(color: AppColors.white, width: 1.0),
                          ),
                          light: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [Shadows.primaryShadow],
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: fromTheme(
                            context,
                            dark: BorderRadius.zero,
                            light: BorderRadius.circular(10.0),
                          ),
                          child: getNetworkImage(user.profileImageUrl),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          user.name,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      FlatTileButton(
                        text: "Unblock",
                        color: AppColors.red,
                        padding: 10.0,
                        onTap: () {
                          DatabaseService.unblockUser(
                              Provider.of<ProviderData>(context).user.uid,
                              user.uid);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
