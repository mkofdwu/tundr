import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:tundr/models/suggestion.dart';

class UserSuggestions extends ChangeNotifier {
  final List<Suggestion> _suggestions = [];
  bool _loading = true;

  UnmodifiableListView<Suggestion> get suggestions =>
      UnmodifiableListView(suggestions);

  void add(Suggestion suggestion) {
    _suggestions.add(suggestion);
    notifyListeners();
  }

  void addAll(Iterable<Suggestion> suggestions) {
    _suggestions.addAll(suggestions);
    notifyListeners();
  }

  void removeAll() {
    _suggestions.clear();
    notifyListeners();
  }

  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }
}
