import 'package:test/test.dart';

import 'groups/chat.dart';
import 'groups/edit_filters.dart';
import 'groups/edit_profile.dart';
import 'groups/login.dart';
import 'groups/registration.dart';
import 'groups/most_popular.dart';
import 'groups/search_users.dart';

void main() {
  group('Login', loginTests);
  group('Registration', registrationTests);
  // group('Swiping page', swipingPageTests);
  // group('Most popular page', mostPopularTests);
  // group('Feature discovery', featureDiscoveryTests);
  group('Search for users', searchUsersTests);
  // group('Edit profile', editProfileTests);
  // group('Edit filters', editFiltersTests);
  // group('Chats', chatTests);
}
