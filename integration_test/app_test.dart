import 'package:flutter_test/flutter_test.dart';

import 'flows/login.dart' as login;
import 'flows/chat/chat.dart' as chat;
import 'flows/edit_filters.dart' as edit_filters;
import 'flows/edit_profile.dart' as edit_profile;
import 'flows/registration.dart' as registration;
import 'flows/most_popular.dart' as most_popular;
import 'flows/search_users.dart' as search_users;
import 'flows/swiping.dart' as swiping;
import 'flows/delete_account.dart' as delete_account;

void main() {
  group('Registration', registration.main);
  group('Login', login.main);
  group('Swiping page', swiping.main);
  group('Most popular page', most_popular.main);
  group('Search for users', search_users.main);
  group('Edit profile', edit_profile.main);
  group('Edit filters', edit_filters.main);
  group('Chats', chat.main);
  group('Delete account', delete_account.main);
}
