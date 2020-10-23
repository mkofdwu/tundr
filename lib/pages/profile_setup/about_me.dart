import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/registration_info.dart';
import 'package:tundr/constants/colors.dart';
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
    Provider.of<RegistrationInfo>(context).aboutMe = _controller.text;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = Provider.of<RegistrationInfo>(context).aboutMe;
    return StackScrollPage(
      color: AppColors.white,
      builder: (context, width, height) => <Widget>[
        TileIconButton(
          icon: Icons.arrow_back,
          iconColor: AppColors.black,
          onPressed: _return,
        ),
        Positioned(
          left: 40.0,
          top: 60.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'About me',
                style: TextStyle(
                  color: AppColors.black,
                  // fontFamily: 'javanese text',
                  fontSize: 60.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Text(
                  'Write a short, interesting description about yourself\n(not more than 200 characters)', // FUTURE: change this text
                  style: TextStyle(color: AppColors.black, fontSize: 12.0),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: TileTextField(
            width: MediaQuery.of(context).size.width - 75,
            height: 200.0,
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
