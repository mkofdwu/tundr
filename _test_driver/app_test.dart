import 'package:test/test.dart';

import 'groups/login.dart' as login;
import 'groups/logout.dart' as logout;
import 'groups/chat/chat.dart' as chat;
import 'groups/edit_filters.dart' as edit_filters;
import 'groups/edit_profile.dart' as edit_profile;
import 'groups/registration.dart' as registration;
import 'groups/most_popular.dart' as most_popular;
import 'groups/search_users.dart' as search_users;
import 'groups/swiping.dart' as swiping;
import 'groups/delete_account.dart' as delete_account;

void main() {
  group('Registration', registration.main);
  group('Logout', logout.main);
  group('Login', login.main);
  group('Swiping page', swiping.main);
  group('Most popular page', most_popular.main);
  group('Search for users', search_users.main);
  group('Edit profile', edit_profile.main);
  group('Edit filters', edit_filters.main);
  group('Chats', chat.main);
  group('Delete account', delete_account.main);
}
