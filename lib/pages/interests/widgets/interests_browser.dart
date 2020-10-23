import 'package:flutter/material.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/constants/interests.dart';
import 'package:tundr/widgets/loaders/loader.dart';
import 'package:tundr/widgets/tabbars/simple.dart';
import 'package:tundr/widgets/textfields/plain.dart';

import 'add_custom_interest_chip.dart';

class InterestsBrowser extends StatefulWidget {
  final List<String> interests;
  final List<String> customInterests;

  InterestsBrowser({
    Key key,
    @required this.interests,
    @required this.customInterests,
  }) : super(key: key);

  @override
  _InterestsBrowserState createState() => _InterestsBrowserState();
}

class _InterestsBrowserState extends State<InterestsBrowser> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _selectedCategory = interests.keys.first;
  }

  Future<List<String>> _searchForInterests() async {
    return allInterestsList
        .where((interest) =>
            interest.toLowerCase().contains(_searchController.text))
        .toList();
  }

  List<Widget> _interestsChipList(availableInterests, selectedInterests) =>
      List<Widget>.from(
        availableInterests.map(
          (interest) {
            final bool selected = selectedInterests.contains(interest);
            return GestureDetector(
              child: Chip(
                backgroundColor: selected ? AppColors.gold : AppColors.white,
                elevation: 5.0,
                label: Text(
                  interest,
                  style: TextStyle(
                    color: selected ? AppColors.white : AppColors.black,
                    fontSize: 14.0,
                  ),
                ),
              ),
              onTap: () {
                setState(
                  () {
                    if (selected) {
                      selectedInterests.remove(interest);
                    } else {
                      selectedInterests.add(interest);
                    }
                  },
                );
              },
            );
          },
        ),
      );
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: PlainTextField(
                      controller: _searchController,
                      hintText: 'Search',
                      hintTextColor: Theme.of(context).accentColor,
                      color: Theme.of(context).accentColor,
                      fontSize: 30.0,
                    ),
                  ),
                  Icon(
                    Icons.search,
                    color: Theme.of(context).accentColor,
                    size: 30.0,
                  ),
                ],
              ),
              SizedBox(height: 30.0),
            ] +
            (_searchController.text.length < 3
                ? [
                    SimpleTabBar(
                      color: Theme.of(context).accentColor,
                      tabNames: ['Custom'] + interests.keys.toList(),
                      defaultTab: interests.keys.first,
                      onSelected: (tab) {
                        setState(() => _selectedCategory = tab);
                      },
                    ),
                    SizedBox(height: 20.0),
                    if (_selectedCategory == null)
                      SizedBox.shrink()
                    else if (_selectedCategory == 'Custom')
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Wrap(
                              spacing: 10.0,
                              children: <Widget>[
                                    AddCustomInterestChip(
                                      onAddCustomInterest: (interest) =>
                                          setState(() => widget.customInterests
                                              .add(interest)),
                                    )
                                  ] +
                                  List<Widget>.from(
                                    widget.customInterests.map((interest) {
                                      return Chip(
                                        backgroundColor: AppColors.gold,
                                        elevation: 5.0,
                                        label: Text(
                                          interest,
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        deleteIconColor: AppColors.white,
                                        onDeleted: () => setState(() => widget
                                            .customInterests
                                            .remove(interest)),
                                      );
                                    }),
                                  ),
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Wrap(
                              spacing: 10.0,
                              children: _interestsChipList(
                                interests[_selectedCategory],
                                widget.interests,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ]
                : [
                    Expanded(
                      child: FutureBuilder<List<String>>(
                        future: _searchForInterests(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Loader(),
                            );
                          }
                          if (snapshot.data.isEmpty) {
                            return Center(
                              child: Text(
                                'No interests found :(',
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 16.0,
                                ),
                              ),
                            );
                          }
                          return SingleChildScrollView(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Wrap(
                                spacing: 10.0,
                                children: _interestsChipList(
                                    snapshot.data, widget.interests),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ]),
      ),
    );
  }
}
