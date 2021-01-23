import 'package:flutter/material.dart';
import 'package:tundr/models/filter.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/buttons/back.dart';
import 'package:tundr/pages/filters/widgets/filter_method_selector.dart';
import 'package:tundr/widgets/pages/stack_scroll.dart';

class TextListFilterPage extends StatefulWidget {
  final Filter filter;

  TextListFilterPage({
    Key key,
    @required this.filter,
  }) : super(key: key);

  @override
  _TextListFilterPageState createState() => _TextListFilterPageState();
}

class _TextListFilterPageState extends State<TextListFilterPage> {
  bool _inputting = false;

  @override
  Widget build(BuildContext context) {
    return StackScrollPage(
      builder: (context, width, height) => <Widget>[
        MyBackButton(),
        Positioned(
          left: width * 50 / 375,
          top: height * 150 / 812,
          width: width / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.filter.field.name,
                style: TextStyle(fontSize: 50),
              ),
              SizedBox(height: 10),
              Text(
                widget.filter.field.prompt,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Container(
                width: width / 2,
                child: FilterMethodSelector(
                  defaultMethod: widget.filter.method,
                  onChanged: (method) =>
                      setState(() => widget.filter.method = method),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: height * 82 / 812,
          right: 20,
          // width: width / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List<Widget>.from(
                  widget.filter.options == null
                      ? []
                      : widget.filter.options
                          .asMap()
                          .map((i, text) => MapEntry(
                                i,
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: GestureDetector(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          width: text.length * 10.0,
                                          height: 5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                        Text(
                                          text,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    onTap: () => setState(() =>
                                        widget.filter.options.removeAt(i)),
                                  ),
                                ),
                              ))
                          .values,
                ) +
                [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: _inputting
                        ? Container(
                            width: 200,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            color: MyPalette.gold,
                            child: TextField(
                              autofocus: true,
                              textDirection: TextDirection.rtl,
                              cursorColor: MyPalette.white,
                              style: TextStyle(
                                fontSize: 20,
                                color: MyPalette.white,
                              ),
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                              onSubmitted: (text) => setState(() {
                                if (text.isNotEmpty) {
                                  widget.filter.options ??= [];
                                  widget.filter.options.add(text);
                                }
                                _inputting = false;
                              }),
                            ),
                          )
                        : GestureDetector(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  width: 50,
                                  height: 5,
                                  color: MyPalette.gold,
                                ),
                                SizedBox(height: 3),
                                Text(
                                  '+ Add new',
                                  style: TextStyle(
                                    color: MyPalette.gold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => setState(() => _inputting = true),
                          ),
                  ),
                ],
          ),
        ),
      ],
    );
  }
}
