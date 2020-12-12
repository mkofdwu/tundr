import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:tundr/pages/chats_list/chats_list.dart';
import 'package:tundr/pages/most_popular.dart';
import 'package:tundr/pages/swiping/swiping.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/my_feature.dart';

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
        Navigator.pushNamed(context, '/me').then(
            (_) => _tabController.animateTo(_tabController.previousIndex));
      } else if (_tabController.index == 3) {
        Navigator.pushNamed(context, '/search').then(
            (_) => _tabController.animateTo(_tabController.previousIndex));
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(
        context,
        <String>['suggestion_card', 'search_tab', 'most_popular_tab', 'me_tab'],
      );
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
                child: const Icon(Icons.person),
              ),
              Tab(
                key: ValueKey('mostPopularTab'),
                child: MyFeature(
                  featureId: 'most_popular_tab',
                  tapTarget: const Icon(Icons.people),
                  title: 'Most popular people',
                  description:
                      'Here you can find a list of the most popular users on the app (based on swipes), with their popularity scores indicated by size.',
                  child: const Icon(Icons.people),
                ),
              ),
              Tab(
                key: ValueKey('swipingTab'),
                child: Icon(Icons.contacts),
              ),
              Tab(
                key: ValueKey('searchTab'),
                child: MyFeature(
                  featureId: 'search_tab',
                  tapTarget: const Icon(Icons.search),
                  title: 'Find anyone',
                  description:
                      'Use this to search for anyone on the app, male or female, by their username.',
                  child: Icon(Icons.search),
                ),
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
          ChatsListPage(),
        ],
      ),
    );
  }
}
