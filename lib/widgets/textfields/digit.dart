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
  final DigitEntryController
      controller; // FUTURE: FIXME: come up with a better solution
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
    // FUTURE: FIXME: come up with a better solution
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
    _controller.addListener(() {
      if (_controller.selection.baseOffset == 0) {
        setState(() {
          _controller.selection = TextSelection.collapsed(offset: 1);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.0,
      height: 50.0,
      child: TextField(
        controller: _controller,
        style: _containsDigit
            ? TextStyle(
                color: MyPalette.gold,
                fontSize: 30.0,
              )
            : TextStyle(
                color: MyPalette.grey,
                fontSize: 24.0,
              ),
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: MyPalette.white,
              width: 2.0,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: MyPalette.white,
              width: 5.0,
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
            final digitEntered = int.tryParse(value.substring(1));
            if (digitEntered == null ||
                !widget.validDigits.contains(digitEntered)) {
              // not a valid integer / digit, rejected
              setState(() {
                _controller.text = value.substring(0, 1);
                _controller.selection = TextSelection.collapsed(offset: 1);
              });
            } else {
              setState(() {
                _controller.text = digitEntered.toString();
                _containsDigit = true;
              });
              widget.onChanged(digitEntered);
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
