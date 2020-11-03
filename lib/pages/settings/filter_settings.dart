import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/filter.dart';
import 'package:tundr/models/personal_info_field.dart';
import 'package:tundr/repositories/current_user.dart';
import 'package:tundr/pages/filters/checkbox_filter.dart';
import 'package:tundr/pages/filters/range_slider_filter.dart';
import 'package:tundr/pages/filters/text_list_filter.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/filter_method.dart';
import 'package:tundr/enums/personal_info_type.dart';
import 'package:tundr/constants/personal_info_fields.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/loaders/loader.dart';

// FUTURE: find a better way to organize filters

class FilterSettingsPage extends StatefulWidget {
  @override
  _FilterSettingsPageState createState() => _FilterSettingsPageState();
}

class _FilterSettingsPageState extends State<FilterSettingsPage> {
  void _openFilter(BuildContext context, Filter filter) async {
    // filter value is modified directly
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          switch (filter.field.type) {
            case PersonalInfoType.numInput:
            case PersonalInfoType.slider:
              return RangeSliderFilterPage(filter: filter);
            case PersonalInfoType.textInput:
            case PersonalInfoType.textList:
              return TextListFilterPage(filter: filter);
            case PersonalInfoType.radioGroup:
              return CheckboxFilterPage(filter: filter);
            default:
              throw Exception(
                  'Invalid filter field type: ${filter.field.type}');
          }
        },
      ),
    );
    Provider.of<CurrentUser>(context).privateInfo.otherFilters
    await UsersService.setUserFilter(
      uid: Provider.of<CurrentUser>(context).profile.uid,
      filter: filter,
    );
    setState(() {});
  }

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
        title: Text('Filters'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: UsersService.getUserFilters(
            Provider.of<CurrentUser>(context).profile.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: Loader());
          final filters = snapshot.data.data;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: List<Widget>.from(personalInfoFields.keys.map(
                (fieldName) {
                  if (filters.containsKey(fieldName) &&
                      filters[fieldName] != null) {
                    final dynamic filterOptions = filters[fieldName]['options'];
                    final filter = Filter(
                      field: PersonalInfoField.fromMap(
                          fieldName, personalInfoFields[fieldName]),
                      options: filterOptions is List<String>
                          ? List<String>.from(filterOptions)
                          : filterOptions,
                      method: FilterMethod.values
                          .elementAt(filters[fieldName]['method']),
                    );
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            fieldName,
                            style: TextStyle(fontSize: 16.0),
                          ),
                          GestureDetector(
                            child: Row(
                              children: <Widget>[
                                filter.options ==
                                        null // backwards compatibility?
                                    ? SizedBox.shrink()
                                    : ConstrainedBox(
                                        constraints:
                                            BoxConstraints(maxWidth: 100.0),
                                        child: Text(
                                          filter.options is List
                                              ? filter.options.join(', ')
                                              : filter.options.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                      ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Theme.of(context).accentColor,
                                ),
                              ],
                            ),
                            onTap: () => _openFilter(
                              context,
                              filter,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          fieldName,
                          style: TextStyle(
                            color: MyPalette.white,
                            fontSize: 16.0,
                          ),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).accentColor,
                          ),
                          onTap: () => _openFilter(
                            context,
                            Filter(
                              field: PersonalInfoField.fromMap(
                                  fieldName, personalInfoFields[fieldName]),
                              options: null,
                              method: FilterMethod.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),
            ),
          );
        },
      ),
    );
  }
}
