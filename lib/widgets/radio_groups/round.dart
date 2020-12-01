import 'package:flutter/material.dart';

class RoundRadioGroup extends StatefulWidget {
  final List<String> options;
  final int selected;
  final Function(int) onChanged;

  RoundRadioGroup({
    Key key,
    @required this.options,
    this.selected,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _RoundRadioGroupState createState() => _RoundRadioGroupState();
}

class _RoundRadioGroupState extends State<RoundRadioGroup> {
  int _selectedOptionIndex;

  @override
  void initState() {
    super.initState();
    if (widget.selected != null) _selectedOptionIndex = widget.selected;
  }

  MapEntry<int, Widget> _buildRoundRadio(int i, String option) => MapEntry(
        i,
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: GestureDetector(
            onTap: i == _selectedOptionIndex
                ? null
                : () {
                    setState(() => _selectedOptionIndex = i);
                    widget.onChanged(_selectedOptionIndex);
                  },
            child: Row(
              children: <Widget>[
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        width: 3,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  child: i == _selectedOptionIndex
                      ? Center(
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 10),
                Text(
                  option,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.from(
          widget.options.asMap().map(_buildRoundRadio).values),
    );
  }
}
