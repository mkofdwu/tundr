import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/personal_info_field.dart';
import 'package:tundr/repositories/theme_manager.dart';
import 'package:tundr/constants/my_palette.dart';
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

  Widget _buildDark(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _return();
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: MyPalette.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: TileIconButton(
            icon: Icons.arrow_back,
            onPressed: _return,
          ),
          title: Text(
            widget.field.name,
            style: TextStyle(
              color: MyPalette.white,
              fontSize: 20,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: TileRadioGroup(
            theme: ThemeMode.dark,
            forceColumn: widget.field.options.length > 5,
            options: List<String>.from(widget.field.options),
            selected: widget.value,
            onChanged: (option) => _selectOption(context, option),
          ),
        ),
      ),
    );
  }

  Widget _buildLight(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: MyPalette.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: TileIconButton(
            icon: Icons.arrow_back,
            onPressed: _return,
          ),
          title: Text(
            widget.field.name,
            style: TextStyle(
              color: MyPalette.black,
              fontSize: 20,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TileRadioGroup(
            theme: ThemeMode.light,
            forceColumn: widget.field.options.length > 5,
            options: List<String>.from(widget.field.options),
            selected: widget.value,
            onChanged: (option) => _selectOption(context, option),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (Provider.of<ThemeManager>(context).theme) {
      case ThemeMode.dark:
        return _buildDark(context);
      case ThemeMode.light:
        return _buildLight(context);
      default:
        throw Exception('Invalid theme: ' +
            Provider.of<ThemeManager>(context).theme.toString());
    }
  }
}
