import 'package:flutter/material.dart';
import 'package:tundr/enums/filter_method.dart';

class FilterMethodSelector extends StatelessWidget {
  final FilterMethod defaultMethod;
  final Function(FilterMethod) onChanged;

  FilterMethodSelector({
    Key key,
    @required this.defaultMethod,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: Theme.of(context).dialogBackgroundColor),
      child: DropdownButton<FilterMethod>(
        value: defaultMethod,
        style: TextStyle(color: Theme.of(context).accentColor),
        items: <DropdownMenuItem<FilterMethod>>[
          DropdownMenuItem(
            child: Text('No filter'),
            value: FilterMethod.none,
          ),
          DropdownMenuItem(
            child: Text('Must contain all of ...'),
            value: FilterMethod.ifContainsAll,
          ),
          DropdownMenuItem(
            child: Text('Must contains any of ...'),
            value: FilterMethod.ifContainsAny,
          ),
          DropdownMenuItem(
            child: Text('Cannot not contain all of ...'),
            value: FilterMethod.ifDoesNotContainAll,
          ),
          DropdownMenuItem(
            child: Text('Cannot not contain any of ...'),
            value: FilterMethod.ifDoesNotContainAny,
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
