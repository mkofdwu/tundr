import 'package:flutter/material.dart';
import 'package:tundr/models/personal_info_field.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/pages/stack_scroll.dart';

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

  void _return() {
    Navigator.pop(context, _textList);
  }

  @override
  Widget build(BuildContext context) => StackScrollPage(
        builder: (context, width, height) => <Widget>[
          SafeArea(
            child: TileIconButton(
              icon: Icons.arrow_back,
              onPressed: _return,
            ),
          ),
          Positioned(
            left: width * 50 / 375,
            top: height * 150 / 812,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.field.name,
                  style: TextStyle(fontSize: 50),
                ),
                SizedBox(height: 10),
                Text(
                  widget.field.prompt,
                  style: TextStyle(fontSize: 16),
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
                    _textList
                        .asMap()
                        .map((i, text) => MapEntry(
                              i,
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: GestureDetector(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        width: text.length * 10.0,
                                        height: 5,
                                      ),
                                      Text(
                                        text,
                                        style: TextStyle(fontSize: 20),
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
                      padding: EdgeInsets.only(top: 20),
                      child: _inputting
                          ? Container(
                              width: 200,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              color: MyPalette.gold,
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
