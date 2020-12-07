import 'package:test/test.dart';

import 'pages/chat.dart';
import 'pages/edit_filters.dart';
import 'pages/edit_profile.dart';
import 'pages/login.dart';
import 'pages/most_popular.dart';
import 'pages/seach_users.dart';

void main() {
  group('Login', loginTests);
  // group('Registration', registrationTests);
  // group('Swiping page', swipingPageTests);
  group('Most popular page', mostPopularTests);
  group('Search for users', searchUsersTests);
  group('Edit profile', editProfileTests);
  group('Edit filters', editFiltersTests);
  group('Chats', chatTests);
}
