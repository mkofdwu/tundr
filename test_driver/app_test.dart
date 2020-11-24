import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'login.dart';
import 'registration.dart';
import 'swiping_page.dart';

void main() {
  group('Login', loginTests);
  group('Registration', registrationTests);
  group('Swiping page', swipingPageTests);
}
