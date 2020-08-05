import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/models/filter.dart';
import 'package:tundr/models/personal-info-field.dart';
import 'package:tundr/repositories/current-user.dart';
import 'package:tundr/pages/filters/checkbox-filter.dart';
import 'package:tundr/pages/filters/range-slider-filter.dart';
import 'package:tundr/pages/filters/text-list-filter.dart';
import 'package:tundr/services/database-service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/constants/enums/filtermethod.dart';
import 'package:tundr/constants/enums/personalinfotype.dart';
import 'package:tundr/constants/personal-info-fields.dart';
import 'package:tundr/widgets/buttons/tile-icon.dart';
import 'package:tundr/widgets/loaders/loader.dart';

// FUTURE: find a better way to organize filters

class FilterSettingsPage extends StatefulWidget {
  @override
  _FilterSettingsPageState createState() => _FilterSettingsPageState();
}

class _FilterSettingsPageState extends State<FilterSettingsPage> {
  _openFilter(BuildContext context, Filter filter) async {
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
                  "Invalid filter field type: ${filter.field.type}");
          }
        },
      ),
    );
    DatabaseService.setUserFilter(
      uid: Provider.of<CurrentUser>(context).user.uid,
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
        title: Text("Filters"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: DatabaseService.getUserFiltersDoc(
            Provider.of<CurrentUser>(context).user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: Loader());
          final Map<String, dynamic> filters = snapshot.data.data;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: List<Widget>.from(personalInfoFields.keys.map(
                (fieldName) {
                  if (filters.containsKey(fieldName) &&
                      filters[fieldName] != null) {
                    final dynamic filterOptions = filters[fieldName]["options"];
                    final Filter filter = Filter(
                      field: PersonalInfoField.fromMap(
                          fieldName, personalInfoFields[fieldName]),
                      options: filterOptions is List<String>
                          ? List<String>.from(filterOptions)
                          : filterOptions,
                      method: FilterMethod.values
                          .elementAt(filters[fieldName]["method"]),
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
                                              ? filter.options.join(", ")
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
                            color: AppColors.white,
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
