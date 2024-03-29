import 'package:flutter/material.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/profile_tile.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  void _openUser(user) => Navigator.pushNamed(
        context,
        '/profile',
        arguments: user,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TileIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          key: ValueKey('searchTextField'),
          controller: _nameController,
          autofocus: true,
          style: Theme.of(context).textTheme.headline6,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(fontSize: 18),
            suffixIcon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
      body: _nameController.text.length < 4
          ? SizedBox.shrink()
          : FutureBuilder(
              future: UsersService.searchForUsers(_nameController.text, 10),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SizedBox.shrink();
                if (snapshot.data.isEmpty) {
                  return Center(
                    child: Text(
                      'No users found :(',
                      style: TextStyle(
                        color: MyPalette.grey,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context)
                        .viewInsets
                        .bottom, // account for keyboard
                  ),
                  child: Column(
                    key: ValueKey('searchResultsColumn'),
                    children: List<Widget>.from(
                      snapshot.data.map((resultProfile) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          child: SizedBox(
                            height: 200,
                            child: GestureDetector(
                              child: ProfileTile(profile: resultProfile),
                              onTap: () => _openUser(resultProfile),
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
