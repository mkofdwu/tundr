import "package:flutter/material.dart";

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
          data: ThemeData(unselectedWidgetColor: Theme.of(context).accentColor),
          child: Checkbox(
            checkColor: Theme.of(context).primaryColor,
            activeColor: Theme.of(context).accentColor,
            value: _selected,
            onChanged: (value) {
              setState(() => _selected = value);
              widget.onChanged(value);
            },
          ),
        ),
        SizedBox(width: 10.0),
        Text(
          widget.text,
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
