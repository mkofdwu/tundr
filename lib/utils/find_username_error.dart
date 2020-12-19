import 'package:tundr/services/users_service.dart';

Future<String> findUsernameError(String username) async {
  // returns the error as a string or null if it's valid
  if (username.contains(RegExp(r'\s'))) {
    return 'Your username cannot contain any spaces';
  }
  if (username.length < 4) {
    return 'Your username must be at least 4 characters long';
  }
  if (await UsersService.usernameAlreadyExists(username)) {
    return 'This username is already taken';
  }
  return null;
}
