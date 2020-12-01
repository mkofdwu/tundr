import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/registration_info.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/pages/stack_scroll.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/textfields/tile.dart';

class SetupAboutMePage extends StatefulWidget {
  @override
  _SetupAboutMePageState createState() => _SetupAboutMePageState();
}

class _SetupAboutMePageState extends State<SetupAboutMePage> {
  final TextEditingController _controller = TextEditingController();

  void _return() {
    Provider.of<RegistrationInfo>(context, listen: false).aboutMe =
        _controller.text;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _controller.text =
        Provider.of<RegistrationInfo>(context, listen: false).aboutMe;
    return StackScrollPage(
      color: MyPalette.white,
      builder: (context, width, height) => <Widget>[
        TileIconButton(
          icon: Icons.arrow_back,
          iconColor: MyPalette.black,
          onPressed: _return,
        ),
        Positioned(
          left: 40,
          top: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'About me',
                style: TextStyle(
                  color: MyPalette.black,
                  // fontFamily: 'javanese text',
                  fontSize: 60,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  'Write a short, interesting description about yourself\n(not more than 200 characters)', // FUTURE: change this text
                  style: TextStyle(color: MyPalette.black, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: TileTextField(
            width: MediaQuery.of(context).size.width - 75,
            height: 200,
            controller: _controller,
            maxChars: 200,
            maxLines: null,
            autoFocus: true,
          ),
        ),
      ],
    );
  }
}
// javanese text
