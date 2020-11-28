import 'package:feature_discovery/feature_discovery.dart';
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
      if (_tabController.indexIsChanging) return;
      if (_tabController.index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        ).then((_) => _tabController.animateTo(_tabController.previousIndex));
      } else if (_tabController.index == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        ).then((_) => _tabController.animateTo(_tabController.previousIndex));
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await FeatureDiscovery.clearPreferences(
          context, <String>['most_popular_tab']); // TODO REMOVE THIS
      FeatureDiscovery.discoverFeatures(context, <String>['most_popular_tab']);
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
        preferredSize: Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: TabBar(
            controller: _tabController,
            indicatorWeight: 3,
            indicatorColor: MyPalette.gold,
            labelColor: MyPalette.gold,
            unselectedLabelColor: Theme.of(context).colorScheme.onPrimary,
            tabs: <Tab>[
              Tab(
                key: ValueKey('dashboardTab'),
                child: Icon(Icons.person),
              ),
              Tab(
                key: ValueKey('mostPopularTab'),
                child: DescribedFeatureOverlay(
                  featureId: 'most_popular_tab',
                  tapTarget: const Icon(Icons.people),
                  title: Text('Most popular people'),
                  description: Text(
                      'Here you can find a list of the most popular users on the app (based on swipes), with their popularity scores indicated by size.'),
                  targetColor: MyPalette.white.withOpacity(0.8),
                  backgroundColor: Theme.of(context).accentColor,
                  child: const Icon(Icons.people),
                ),
              ),
              Tab(
                key: ValueKey('swipingTab'),
                child: Icon(Icons.contacts),
              ),
              Tab(
                key: ValueKey('searchTab'),
                child: Icon(Icons.search),
              ),
              Tab(
                key: ValueKey('chatTab'),
                child: Icon(Icons.chat),
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
    );
  }
}
