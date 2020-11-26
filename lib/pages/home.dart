import 'package:flutter/material.dart';
import 'package:tundr/pages/dashboard.dart';
import 'package:tundr/pages/messages/messages.dart';
import 'package:tundr/pages/most_popular.dart';
import 'package:tundr/pages/search.dart';
import 'package:tundr/pages/swiping/swiping.dart';
import 'package:tundr/constants/my_palette.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, initialIndex: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
      if (_tabController.indexIsChanging) return;
      if (_tabController.index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        ); //.then((_) => _tabController.animateTo(_tabController.previousIndex));
      } else if (_tabController.index == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        ).then((_) => _tabController.animateTo(_tabController.previousIndex));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        // FUTURE: new tab bar
        preferredSize: Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: TabBar(
            indicatorColor: MyPalette.gold,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 10.0),
            controller: _tabController,
            tabs: <IconData>[
              Icons.person,
              Icons.people,
              Icons.contacts,
              Icons.search,
              Icons.chat
            ]
                .asMap()
                .map(
                  (i, iconData) => MapEntry(
                    i,
                    Tab(
                      key: ValueKey('tab' + i.toString()),
                      child: Icon(
                        iconData,
                        color: _tabController.index == i
                            ? MyPalette.gold
                            : Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                )
                .values
                .toList(),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          SizedBox.shrink(),
          LayoutBuilder(
            builder: (context, constraints) => MostPopularPage(
              height: constraints.maxHeight * 2,
              width: constraints.maxWidth,
            ),
          ),
          SwipingPage(),
          SizedBox.shrink(),
          MessagesPage(),
        ],
      ),
    );
  }
}
