import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/personal_info_field.dart';
import 'package:tundr/repositories/theme_manager.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/radio_groups/tile.dart';

class RadioGroupFieldPage extends StatefulWidget {
  final PersonalInfoField field;
  final String value;

  RadioGroupFieldPage({
    Key key,
    @required this.field,
    @required this.value,
  }) : super(key: key);

  @override
  _RadioGroupFieldPageState createState() => _RadioGroupFieldPageState();
}

class _RadioGroupFieldPageState extends State<RadioGroupFieldPage> {
  String _option;

  @override
  void initState() {
    super.initState();
    _option = widget.value;
  }

  void _selectOption(BuildContext context, String option) =>
      setState(() => _option = option);

  void _return() => Navigator.pop(context, _option);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _return();
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: TileIconButton(
            icon: Icons.arrow_back,
            onPressed: _return,
          ),
          title: Text(widget.field.name),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: TileRadioGroup(
            theme: Provider.of<ThemeManager>(context).theme,
            forceColumn: widget.field.options.length > 5,
            options: List<String>.from(widget.field.options),
            selected: widget.value,
            onChanged: (option) => _selectOption(context, option),
          ),
        ),
      ),
    );
  }
}
