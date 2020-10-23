import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/personal_info_field.dart';
import 'package:tundr/repositories/theme_notifier.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/radio_groups/tile.dart';
import 'package:tundr/enums/app_theme.dart';

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
        backgroundColor: AppColors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: TileIconButton(
            icon: Icons.arrow_back,
            onPressed: _return,
          ),
          title: Text(
            widget.field.name,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20.0,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: TileRadioGroup(
            theme: AppTheme.dark,
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
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: TileIconButton(
            icon: Icons.arrow_back,
            onPressed: _return,
          ),
          title: Text(
            widget.field.name,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 20.0,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TileRadioGroup(
            theme: AppTheme.light,
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
    switch (Provider.of<ThemeNotifier>(context).theme) {
      case AppTheme.dark:
        return _buildDark(context);
      case AppTheme.light:
        return _buildLight(context);
      default:
        throw Exception('Invalid theme: ' +
            Provider.of<ThemeNotifier>(context).theme.toString());
    }
  }
}
