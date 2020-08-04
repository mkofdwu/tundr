import "package:flutter/material.dart";
import 'package:tundr/models/personalinfofield.dart';
import 'package:tundr/utils/constants/colors.dart';
import 'package:tundr/widgets/buttons/tileiconbutton.dart';
import 'package:tundr/widgets/pages/stackscrollpage.dart';

class TextListFieldPage extends StatefulWidget {
  final PersonalInfoField field;
  final List<String> value;

  TextListFieldPage({
    Key key,
    @required this.field,
    this.value,
  }) : super(key: key);

  @override
  _TextListFieldPageState createState() => _TextListFieldPageState();
}

class _TextListFieldPageState extends State<TextListFieldPage> {
  List<String> _textList = [];
  bool _inputting = false;

  @override
  void initState() {
    super.initState();
    if (widget.value != null) _textList = widget.value;
  }

  _return() {
    Navigator.pop(context, _textList);
  }

  @override
  Widget build(BuildContext context) => StackScrollPage(
        builder: (context, width, height) => <Widget>[
          TileIconButton(
            icon: Icons.arrow_back,
            onPressed: _return,
          ),
          Positioned(
            left: width * 48 / 375,
            top: height * 90 / 812,
            child: Column(
              children: <Widget>[
                Text(
                  widget.field.name,
                  style: TextStyle(fontSize: 60.0),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    widget.field.prompt,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: height * 82 / 812,
            right: 20.0,
            // width: width / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List<Widget>.from(
                    _textList
                        .asMap()
                        .map((i, text) => MapEntry(
                              i,
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: GestureDetector(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        width: text.length * 10.0,
                                        height: 5.0,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      Text(
                                        text,
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ],
                                  ),
                                  onTap: () =>
                                      setState(() => _textList.removeAt(i)),
                                ),
                              ),
                            ))
                        .values,
                  ) +
                  [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: _inputting
                          ? Container(
                              width: 200.0,
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              color: AppColors.gold,
                              child: TextField(
                                autofocus: true,
                                textDirection: TextDirection.rtl,
                                style: Theme.of(context).textTheme.headline6,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                                onSubmitted: (text) => setState(() {
                                  if (text.isNotEmpty) _textList.add(text);
                                  _inputting = false;
                                }),
                              ),
                            )
                          : GestureDetector(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    width: 50.0,
                                    height: 5.0,
                                    color: AppColors.gold,
                                  ),
                                  SizedBox(height: 3.0),
                                  Text(
                                    "+ Add new",
                                    style: TextStyle(
                                      color: AppColors.gold,
                                      fontSize: 20.0,
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
