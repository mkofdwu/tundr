import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

import 'package:tundr/models/popular_user.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/widgets/my_loader.dart';

class MostPopularPage extends StatefulWidget {
  @override
  _MostPopularPageState createState() => _MostPopularPageState();
}

class _MostPopularPageState extends State<MostPopularPage> {
  static const int maxPages = 10;
  final ScrollController _scrollController = ScrollController();
  int _page = -1;
  final List<PopularUser> _mostPopularUsers = [];
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) => _loadNextPage());
  }

  Future<void> _loadNextPage() async {
    if (_page >= maxPages) return;

    setState(() => _isLoadingMore = true);
    _page++;
    final morePopularUsers = await UsersService.getMostPopular(_page);
    if (mounted) {
      setState(() {
        _mostPopularUsers.addAll(morePopularUsers);
        _isLoadingMore = false;
      });
    }
  }

  Widget _buildPopularUserTile(PopularUser user) => Container(
        height: Random().nextDouble() * 50 + 200,
        decoration: BoxDecoration(
          boxShadow: [MyPalette.primaryShadow],
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: user.profile.profileImageUrl,
                child: getNetworkImage(user.profile.profileImageUrl),
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    user.position.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.profile.name +
                        ', ' +
                        user.profile.ageInYears.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    user.popularityScore.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                ],
              ),
            ),
            Positioned.fill(
                child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  '/profile',
                  arguments: user.profile,
                ),
              ),
            ))
          ],
        ),
      );

  Widget _buildSingleColumn(List<PopularUser> users) => Column(
        children: users
            .map((user) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildPopularUserTile(user),
                ))
            .toList(),
      );

  Widget _buildMostPopularList() => Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildSingleColumn(_mostPopularUsers
                      .where((user) => user.position % 2 == 1)
                      .toList()),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildSingleColumn(_mostPopularUsers
                      .where((user) => user.position % 2 == 0)
                      .toList()),
                ),
              ],
            ),
            if (_isLoadingMore)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: MyLoader(),
              ),
          ],
        ),
      );

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0 &&
        !_isLoadingMore) {
      _loadNextPage();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_mostPopularUsers.isEmpty) {
      return Center(child: MyLoader());
    }
    return NotificationListener(
      onNotification: _onScrollNotification,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: _buildMostPopularList(),
      ),
    );
  }
}
