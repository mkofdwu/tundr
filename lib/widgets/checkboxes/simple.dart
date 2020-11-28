import 'package:flutter/material.dart';

class SimpleCheckbox extends StatefulWidget {
  final String text;
  final bool value;
  final Function(bool) onChanged;

  SimpleCheckbox({
    Key key,
    @required this.text,
    @required this.value,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _SimpleCheckboxState createState() => _SimpleCheckboxState();
}

class _SimpleCheckboxState extends State<SimpleCheckbox> {
  bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(
            unselectedWidgetColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              checkColor: Theme.of(context).primaryColor,
              activeColor: Theme.of(context).colorScheme.onPrimary,
              value: _selected,
              onChanged: (value) {
                setState(() => _selected = value);
                widget.onChanged(value);
              },
            ),
          ),
        ),
        SizedBox(width: 10),
        Text(
          widget.text,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}
