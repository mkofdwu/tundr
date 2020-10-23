import 'package:flutter/material.dart';
import 'package:tundr/models/filter.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
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
        TileIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        Positioned(
          left: width * 48 / 375,
          top: height * 90 / 812,
          child: Column(
            children: <Widget>[
              Text(
                widget.filter.field.name,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 60.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: FilterMethodSelector(
                  defaultMethod: widget.filter.method,
                  onChanged: (method) => widget.filter.method = method,
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
                  widget.filter.options == null
                      ? []
                      : widget.filter.options
                          .asMap()
                          .map((i, text) => MapEntry(
                                i,
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: GestureDetector(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          width: text.length * 10.0,
                                          height: 5.0,
                                          color: AppColors.white,
                                        ),
                                        Text(
                                          text,
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 20.0,
                                          ),
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
                    padding: EdgeInsets.only(top: 20.0),
                    child: _inputting
                        ? Container(
                            width: 200.0,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            color: AppColors.gold,
                            child: TextField(
                              autofocus: true,
                              textDirection: TextDirection.rtl,
                              cursorColor: AppColors.white,
                              style: Theme.of(context).textTheme.headline6,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                              onSubmitted: (text) => setState(() {
                                if (text.isNotEmpty) {
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
                                  width: 50.0,
                                  height: 5.0,
                                  color: AppColors.gold,
                                ),
                                SizedBox(height: 3.0),
                                Text(
                                  '+ Add new',
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
}
