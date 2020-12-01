import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/constants/interests.dart';
import 'package:tundr/widgets/tabbars/simple.dart';
import 'package:tundr/widgets/textfields/plain.dart';

import 'add_custom_interest_chip.dart';

class InterestsBrowser extends StatefulWidget {
  final List<String> interests;
  final List<String> customInterests;
  final Function onInterestsChanged;
  final Function onCustomInterestsChanged;

  InterestsBrowser({
    Key key,
    @required this.interests,
    @required this.customInterests,
    @required this.onInterestsChanged,
    @required this.onCustomInterestsChanged,
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

  List<String> _searchForInterests() {
    return allInterestsList
        .where((interest) =>
            interest.toLowerCase().contains(_searchController.text))
        .toList();
  }

  Widget _buildSearchTextField() => Row(
        children: <Widget>[
          Expanded(
            child: PlainTextField(
              controller: _searchController,
              hintText: 'Search',
              hintTextColor: Theme.of(context).colorScheme.onPrimary,
              fontSize: 30,
            ),
          ),
          Icon(
            Icons.search,
            size: 30,
          ),
        ],
      );

  List<Widget> _buildBody() => [
        SimpleTabBar(
          tabNames: ['Custom'] + interests.keys.toList(),
          defaultTab: interests.keys.first,
          onSelected: (tab) {
            setState(() => _selectedCategory = tab);
          },
        ),
        SizedBox(height: 14),
        if (_selectedCategory == null)
          SizedBox.shrink()
        else if (_selectedCategory == 'Custom')
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Wrap(
                  spacing: 10,
                  children: <Widget>[
                        AddCustomInterestChip(
                          onAddCustomInterest: (interest) {
                            setState(
                                () => widget.customInterests.add(interest));
                            widget.onCustomInterestsChanged();
                          },
                        )
                      ] +
                      List<Widget>.from(
                        widget.customInterests.map((interest) {
                          return Chip(
                            backgroundColor: MyPalette.gold,
                            elevation: 5,
                            label: Text(
                              interest,
                              style: TextStyle(
                                color: MyPalette.white,
                                fontSize: 14,
                              ),
                            ),
                            deleteIconColor: MyPalette.white,
                            onDeleted: () {
                              setState(() =>
                                  widget.customInterests.remove(interest));
                              widget.onCustomInterestsChanged();
                            },
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
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Wrap(
                  spacing: 10,
                  children: _buildInterestChips(interests[_selectedCategory]),
                ),
              ),
            ),
          ),
      ];

  Widget _buildSearchResults() {
    final searchResults = _searchForInterests();
    return Expanded(
      child: (searchResults.isEmpty)
          ? Center(
              child: Text(
                'No interests found :(',
                style: TextStyle(
                  color: MyPalette.grey,
                  fontSize: 16,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Wrap(
                  spacing: 10,
                  children: _buildInterestChips(searchResults),
                ),
              ),
            ),
    );
  }

  List<Widget> _buildInterestChips(availableInterests) => List<Widget>.from(
        availableInterests.map(
          (interest) {
            final selected = widget.interests.contains(interest);
            return GestureDetector(
              child: Chip(
                backgroundColor: selected ? MyPalette.gold : MyPalette.white,
                elevation: 5,
                label: Text(
                  interest,
                  style: TextStyle(
                    color: selected ? MyPalette.white : MyPalette.black,
                    fontSize: 14,
                  ),
                ),
              ),
              onTap: () {
                setState(
                  () {
                    if (selected) {
                      widget.interests.remove(interest);
                    } else {
                      widget.interests.add(interest);
                    }
                  },
                );
                widget.onInterestsChanged();
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
          _buildSearchTextField(),
          SizedBox(height: 20),
          if (_searchController.text.length < 3)
            ...(_buildBody())
          else
            _buildSearchResults()
        ],
      ),
    );
  }
}
