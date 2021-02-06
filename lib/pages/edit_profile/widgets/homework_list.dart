import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

class HomeworkList extends StatefulWidget {
  final List<String> homeworkList;
  final Function(String) onAddHomework;
  final Function(int, String) onEditHomework;
  final Function(int) onRemoveHomework;

  HomeworkList({
    @required this.homeworkList,
    @required this.onAddHomework,
    @required this.onEditHomework,
    @required this.onRemoveHomework,
  });

  @override
  _HomeworkListState createState() => _HomeworkListState();
}

class _HomeworkListState extends State<HomeworkList> {
  TextEditingController _editHomeworkController;
  int _editHomeworkIndex;

  final TextEditingController _addHomeworkController = TextEditingController();
  bool _addingHomework = false;

  Widget _buildHomeworkTextField({
    TextEditingController controller,
    Color color,
    String hintText,
    Function onClear,
    Function onEditingComplete,
  }) =>
      TextField(
        controller: controller,
        style: TextStyle(color: color),
        cursorColor: color,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: color),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color),
          ),
          suffixIcon: GestureDetector(
            onTap: onClear,
            child: Icon(
              Icons.clear,
              color: color,
              size: 20,
            ),
          ),
          suffixIconConstraints: BoxConstraints(maxWidth: 40),
        ),
        onEditingComplete: onEditingComplete,
      );

  @override
  void dispose() {
    _addHomeworkController.dispose();
    _editHomeworkController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Homework',
                  style: TextStyle(color: MyPalette.gold, fontSize: 20),
                ),
                if (!_addingHomework)
                  GestureDetector(
                    child: Icon(Icons.add, color: MyPalette.gold),
                    onTap: () => setState(() => _addingHomework = true),
                  ),
              ],
            ),
            SizedBox(height: 10),
          ] +
          widget.homeworkList
              .asMap()
              .map((i, hw) {
                if (_editHomeworkIndex == i) {
                  _editHomeworkController = TextEditingController(text: hw);
                  return MapEntry(
                      i,
                      _buildHomeworkTextField(
                        controller: _editHomeworkController,
                        color: Theme.of(context).colorScheme.onPrimary,
                        hintText: '',
                        onClear: () {
                          widget.onRemoveHomework(i);
                          setState(() => _editHomeworkIndex = null);
                        },
                        onEditingComplete: () {
                          widget.onEditHomework(
                              i, _editHomeworkController.text);
                          setState(() => _editHomeworkIndex = null);
                        },
                      ));
                }
                return MapEntry(
                    i,
                    GestureDetector(
                      onTap: () => setState(() => _editHomeworkIndex = i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(hw, style: TextStyle(fontSize: 16)),
                      ),
                    ));
              })
              .values
              .toList() +
          (_addingHomework
              ? [
                  _buildHomeworkTextField(
                    controller: _addHomeworkController,
                    color: MyPalette.grey,
                    hintText: 'Add homework...',
                    onClear: () => setState(() => _addingHomework = false),
                    onEditingComplete: () {
                      if (_addHomeworkController.text.isNotEmpty) {
                        widget.onAddHomework(_addHomeworkController.text);
                        _addHomeworkController.text = '';
                        setState(() => _addingHomework = false);
                      }
                    },
                  )
                ]
              : []),
    );
  }
}
