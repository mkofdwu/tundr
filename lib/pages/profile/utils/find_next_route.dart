import 'package:tundr/models/user_profile.dart';

final pages = [
  ['/profile/main', (profile) => true],
  ['/profile/about_me', (profile) => profile.aboutMe.isNotEmpty],
  ['/profile/homework', (profile) => profile.homework.isNotEmpty],
  [
    '/profile/extra_media',
    (profile) => profile.extraMedia.any((media) => media != null)
  ],
  [
    '/profile/personal_info',
    (profile) =>
        profile.interests.isNotEmpty ||
        profile.customInterests.isNotEmpty ||
        profile.personalInfo.isNotEmpty
  ],
];

String findNextRoute(String current, UserProfile profile) {
  // find the next page with content to display
  final currentIndex =
      pages.indexWhere((pageAndTester) => pageAndTester[0] == current);
  for (var i = currentIndex + 1; i < pages.length; ++i) {
    final pageAndTester = pages[i];
    final shouldDisplay = (pageAndTester[1] as Function)(profile) as bool;
    if (shouldDisplay) return pageAndTester[0];
  }
  return null;
}
