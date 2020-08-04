import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/models/filter.dart';
import 'package:tundr/models/providerdata.dart';
import 'package:tundr/services/databaseservice.dart';
import 'package:tundr/widgets/buttons/tileiconbutton.dart';
import 'package:tundr/widgets/checkboxes/simplecheckbox.dart';

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
    if (widget.filter.options == null) widget.filter.options = [];
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
                    if (value)
                      widget.filter.options.add(option);
                    else
                      widget.filter.options.remove(option);
                    DatabaseService.setUserFilter(
                      uid: Provider.of<ProviderData>(context).user.uid,
                      filter: widget.filter,
                    );
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
