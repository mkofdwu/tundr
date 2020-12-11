import 'package:flutter/material.dart';
import 'package:tundr/models/personal_info_field.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/pages/stack_scroll.dart';

class TextFieldPage extends StatefulWidget {
  final PersonalInfoField field;
  final String value;

  TextFieldPage({
    Key key,
    @required this.field,
    @required this.value,
  }) : super(key: key);

  @override
  _TextFieldPageState createState() => _TextFieldPageState();
}

class _TextFieldPageState extends State<TextFieldPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.value != null) _controller.text = widget.value;
  }

  void _return() {
    Navigator.pop(context, _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _return();
        return Future(() => false);
      },
      child: StackScrollPage(
        builder: (context, width, height) => <Widget>[
          SafeArea(
            child: TileIconButton(
              icon: Icons.arrow_back,
              onPressed: _return,
            ),
          ),
          Positioned(
            left: width * 37 / 375,
            top: height * 100 / 812,
            width: width * 200 / 375,
            child: Text(
              widget.field.prompt,
              style: TextStyle(fontSize: 40),
            ),
          ),
          Positioned(
            right: 40,
            top: height * 400 / 812,
            width: width * 200 / 375,
            child: TextField(
              autofocus: true,
              controller: _controller,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
