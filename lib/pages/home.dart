import "package:flutter/material.dart";
import 'package:tundr/pages/dashboard.dart';
import 'package:tundr/pages/messages/messages.dart';
import 'package:tundr/pages/most-popular.dart';
import 'package:tundr/pages/search.dart';
import 'package:tundr/pages/swiping/swiping.dart';
import 'package:tundr/constants/colors.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          // FUTURE: new tab bar
          preferredSize: Size.fromHeight(50.0),
          child: Container(
            color: Colors.transparent,
            child: TabBar(
              indicatorColor: AppColors.gold,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 10.0),
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  child: Icon(
                    Icons.person,
                    color: _tabController.index == 0
                        ? AppColors.gold
                        : Theme.of(context).accentColor,
                  ),
                ),
                Tab(
                  child: Icon(
                    Icons.people,
                    color: _tabController.index == 1
                        ? AppColors.gold
                        : Theme.of(context).accentColor,
                  ),
                ), // FUTURE: find flame icon
                Tab(
                  // child: Icon(
                  //   Icons.offline_bolt,
                  //   color: _tabController.index == 2
                  //       ? AppColors.gold
                  //       : Theme.of(context).accentColor,
                  // ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: ShapeDecoration(
                      color: _tabController.index == 2
                          ? AppColors.gold
                          : Theme.of(context).accentColor,
                      shape: CircleBorder(),
                    ),
                  ),
                ), // FUTURE: lightning icon
                Tab(
                  child: Icon(
                    Icons.search,
                    color: _tabController.index == 3
                        ? AppColors.gold
                        : Theme.of(context).accentColor,
                  ),
                ),
                Tab(
                  child: Icon(
                    Icons.chat,
                    color: _tabController.index == 4
                        ? AppColors.gold
                        : Theme.of(context).accentColor,
                  ),
                ),
              ],
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
      ),
    );
  }
}
