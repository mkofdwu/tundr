import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/personal_info_field.dart';
import 'package:tundr/repositories/theme_manager.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/pages/stack_scroll.dart';
import 'package:tundr/widgets/textfields/underline.dart';

class NumberFieldPage extends StatefulWidget {
  final PersonalInfoField field;
  final int value;

  NumberFieldPage({
    Key key,
    @required this.field,
    @required this.value,
  }) : super(key: key);

  @override
  _NumberFieldPageState createState() => _NumberFieldPageState();
}

class _NumberFieldPageState extends State<NumberFieldPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.value != null) _controller.text = widget.value.toString();
  }

  void _return() {
    Navigator.pop(context, int.tryParse(_controller.text));
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
            left: 40,
            top: height * 120 / 812,
            width: width - 100,
            child: Text(
              widget.field.prompt,
              style: TextStyle(fontSize: 34),
            ),
          ),
          Positioned(
            left: width * 150 / 375,
            top: height * 500 / 812,
            width: width * 200 / 375,
            child: TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              controller: _controller,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    // color: MyPalette.white,
                    width: 2,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    // color: MyPalette.white,
                    width: 5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
