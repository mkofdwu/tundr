import 'package:flutter/cupertino.dart';
import 'package:tundr/models/suggestion.dart';

class UserSuggestions extends ChangeNotifier {
  List<Suggestion> suggestions = [];
  bool loading = true;
}
