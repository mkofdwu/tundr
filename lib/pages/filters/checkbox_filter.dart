import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/filter.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/widgets/buttons/back.dart';
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
    super.initState();
    widget.filter.options ??= [];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Material(
      child: Stack(
        children: [
          MyBackButton(),
          Positioned(
            left: width * 40 / 375,
            top: 0,
            width: width * 280 / 375,
            height: height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      SizedBox(height: 140),
                      Text(
                        widget.filter.field.name,
                        style: TextStyle(fontSize: 50),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.filter.field.prompt,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 40),
                    ] +
                    List<Widget>.from(
                      widget.filter.field.options.map(
                        (option) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: SimpleCheckbox(
                            text: option,
                            value: widget.filter.options.contains(option),
                            onChanged: (value) {
                              if (value) {
                                widget.filter.options.add(option);
                              } else {
                                widget.filter.options.remove(option);
                              }
                              Provider.of<User>(context, listen: false)
                                  .updateAlgorithmData({
                                'otherFilters': {
                                  ...Provider.of<User>(context, listen: false)
                                      .algorithmData
                                      .otherFilters,
                                  widget.filter.field.name: widget.filter,
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ) +
                    [
                      SizedBox(height: 50),
                    ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
