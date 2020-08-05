import "package:flutter/material.dart";
import 'package:tundr/services/database-service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/widgets/buttons/tile-icon.dart';
import 'package:tundr/widgets/profile-tile.dart';
import 'package:tundr/repositories/provider-data.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() => setState(() {}));
  }

  _openUser(user) => Navigator.pushNamed(
        context,
        "userprofile",
        arguments: user,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: TileIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _usernameController,
          autofocus: true,
          cursorColor: Theme.of(context).accentColor,
          style: Theme.of(context).textTheme.headline6,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(
              fontSize: 20.0,
              color: Theme.of(context).accentColor,
            ),
            suffixIcon: Icon(
              Icons.search,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
      body: _usernameController.text.length < 4
          ? SizedBox.shrink()
          : FutureBuilder(
              future:
                  DatabaseService.searchForUsers(_usernameController.text, 10),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SizedBox.shrink();
                if (snapshot.data.isEmpty)
                  return Center(
                    child: Text(
                      "No users found :(",
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 16.0,
                      ),
                    ),
                  );
                final String uid = Provider.of<ProviderData>(context).user.uid;
                return SingleChildScrollView(
                  child: Column(
                    children: List<Widget>.from(
                      snapshot.data.map((user) {
                        if (user.uid == uid) return SizedBox.shrink();
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 20.0),
                          child: SizedBox(
                            height: 200.0,
                            child: GestureDetector(
                              child: ProfileTile(user: user),
                              onTap: () => _openUser(user),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
