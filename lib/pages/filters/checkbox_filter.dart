import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/filter.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/checkboxes/simple.dart';

class CheckboxFilterPage extends StatefulWidget {
  final Filter filter;

  CheckboxFilterPage({Key key, this.filter}) : super(key: key);

  @override
  _CheckboxFilterPageState createState() => _CheckboxFilterPageState();
}

class _CheckboxFilterPageState extends State<CheckboxFilterPage> {
  @override
  void initState() {
    // FUTURE: nicer solution?
    super.initState();
    widget.filter.options ??= [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TileIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.filter.field.name,
          style: Theme.of(context).textTheme.headline6,
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List<Widget>.from(
            widget.filter.field.options.map(
              (option) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: SimpleCheckbox(
                  text: option,
                  value: widget.filter.options
                      .contains(option), // FUTURE: or Map<String, bool>?
                  onChanged: (value) {
                    if (value) {
                      widget.filter.options.add(option);
                    } else {
                      widget.filter.options.remove(option);
                    }
                    Provider.of<User>(context).updateAlgorithmData({
                      'otherFilters': {
                        ...Provider.of<User>(context)
                            .algorithmData
                            .otherFilters,
                        widget.filter.field.name: widget.filter,
                      }
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
