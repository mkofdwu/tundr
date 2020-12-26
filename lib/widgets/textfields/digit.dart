import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/textfields/digit_controller.dart';

class DigitEntry extends StatefulWidget {
  final String hintChar;
  final List<int> validDigits;
  final bool autoFocus;
  final bool moveFocus;
  final DigitEntryController controller;
  final Function(int) onChanged;

  DigitEntry({
    Key key,
    this.hintChar = '\u2022',
    this.validDigits = const [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    this.autoFocus = false,
    this.moveFocus = true,
    this.controller,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _DigitEntryState createState() => _DigitEntryState(controller);
}

class _DigitEntryState extends State<DigitEntry> {
  final TextEditingController _controller = TextEditingController();
  bool _containsDigit = false;

  _DigitEntryState(DigitEntryController digitEntryController) {
    if (digitEntryController != null) {
      digitEntryController.clear = clear;
      digitEntryController.setDigit = setDigit;
    }
  }

  @override
  void initState() {
    super.initState();
    assert(widget.hintChar.length == 1);
    _controller.text = widget.hintChar;
    // _controller.addListener(() {
    //   if (_controller.selection.baseOffset == 0) {
    //     setState(() {
    //       _controller.selection = TextSelection.collapsed(offset: 1);
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 50,
      child: TextField(
        controller: _controller,
        style: _containsDigit
            ? TextStyle(
                color: MyPalette.gold,
                fontSize: 30,
              )
            : TextStyle(
                color: MyPalette.grey,
                fontSize: 24,
              ),
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: MyPalette.white,
              width: 2,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: MyPalette.white,
              width: 5,
            ),
          ),
        ),
        autofocus: widget.autoFocus,
        showCursor: false,
        maxLength: 2,
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          print('value changed');
          print('|$value|');
          if (value.isEmpty) {
            // user pressed backspace either while it contained
            // hint text or while there was a digit in it,
            // resulting in no text remaining
            setState(() {
              _controller.text = widget.hintChar;
              _containsDigit = false;
            });
            FocusScope.of(context).previousFocus();
          } else {
            final cursorIndex = _controller.selection.baseOffset;

            // ! integration test case
            // ! cursorIndex is always set at -1 by flutter tester, and value only contains one digit
            if (cursorIndex == -1 && value.length == 1) {
              final digit = int.tryParse(value);
              setState(() {
                _controller.text = digit.toString();
                _containsDigit = true;
              });
              widget.onChanged(digit);
              if (widget.moveFocus) FocusScope.of(context).nextFocus();
              return;
            }

            final charEntered = value.substring(cursorIndex - 1, cursorIndex);
            final digit = int.tryParse(charEntered);
            if (digit == null || !widget.validDigits.contains(digit)) {
              // not a valid integer / digit, rejected
              setState(() {
                _controller.text = value.replaceAll(charEntered, '');
              });
            } else {
              setState(() {
                _controller.text = digit.toString();
                _containsDigit = true;
              });
              widget.onChanged(digit);
              if (widget.moveFocus) FocusScope.of(context).nextFocus();
            }
          }
        },
      ),
    );
  }

  void clear() {
    setState(() {
      _controller.text = widget.hintChar;
      _containsDigit = false;
    });
  }

  void setDigit(int digit) {
    assert(widget.validDigits.contains(digit));
    setState(() {
      _controller.text = digit.toString();
      _containsDigit = true;
    });
  }
}
