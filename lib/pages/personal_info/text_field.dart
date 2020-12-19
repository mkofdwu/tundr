import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/models/personal_info_field.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';

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
  final TextEditingController _otherTextController = TextEditingController();
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.value != null
        ? widget.field.options.indexOf(widget.value)
        : null;
    if (widget.value != null && !widget.field.options.contains(widget.value)) {
      _otherTextController.text = widget.value;
    }
    _otherTextController.addListener(() {
      if (_otherTextController.text.isNotEmpty) {
        // -1 indicates the other option is selected
        setState(() => _selectedIndex = -1);
      }
    });
  }

  void _return() {
    if (_selectedIndex == null) {
      Navigator.pop(context, null);
    } else if (_selectedIndex == -1) {
      Navigator.pop(
        context,
        _otherTextController.text.isEmpty ? null : _otherTextController.text,
      );
    } else {
      Navigator.pop(context, widget.field.options[_selectedIndex]);
    }
  }

  Widget _buildOtherTextField() {
    final color = _selectedIndex == -1 && _otherTextController.text.isNotEmpty
        ? MyPalette.gold
        : Theme.of(context).colorScheme.onPrimary.withOpacity(0.6);
    return TextField(
      controller: _otherTextController,
      style: TextStyle(
        fontSize: 18,
        color: color,
      ),
      cursorColor: color,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.only(
          left: 60,
          top: 10,
          bottom: 10,
        ),
        hintText: 'Other...',
        hintStyle: TextStyle(
          fontSize: 18,
          color: color,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: color,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: color,
          ),
        ),
        suffixIcon: _otherTextController.text.isEmpty
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 20, right: 40),
                child: GestureDetector(
                  onTap: () => setState(() => _otherTextController.text = ''),
                  child: Icon(Icons.clear, color: color, size: 20),
                ),
              ),
        suffixIconConstraints: BoxConstraints(maxWidth: 84),
      ),
    );
  }

  Widget _buildOption(int i, String option) {
    final color = i == _selectedIndex
        ? MyPalette.gold
        : Theme.of(context).colorScheme.onPrimary;
    return Padding(
      padding: const EdgeInsets.only(
        left: 60,
        bottom: 14,
        right: 40,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => setState(() => _selectedIndex = i),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 18,
                color: color,
              ),
            ),
          ),
          if (i == _selectedIndex)
            GestureDetector(
              onTap: () => setState(() => _selectedIndex = null),
              child: Icon(Icons.clear, color: color, size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionsScrollView() => SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 30,
          bottom: MediaQuery.of(context).viewInsets.bottom + 70,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (widget.field.options as List)
                  .asMap()
                  .map((i, religion) => MapEntry<int, Widget>(
                        i,
                        _buildOption(i, religion),
                      ))
                  .values
                  .toList() +
              [_buildOtherTextField()],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _return();
        return Future(() => false);
      },
      child: Material(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TileIconButton(
                    icon: Icons.arrow_back,
                    onPressed: _return,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 60,
                      top: height * 80 / 736,
                      bottom: 40,
                    ),
                    child: SizedBox(
                      width: width * 200 / 414,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.field.name,
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 12),
                          Text(
                            widget.field.prompt,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.04),
                      width: double.infinity,
                      child: _buildOptionsScrollView(),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
