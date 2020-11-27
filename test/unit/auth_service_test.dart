import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tundr/repositories/registration_info.dart';
import 'package:tundr/services/auth_service.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  static MockFirebaseAuth instance = MockFirebaseAuth();
}

class MockPhoneAuthProvider extends Mock implements PhoneAuthProvider {
  @override
  static MockPhoneAuthProvider credential(
      {String verificationId, String smsCode}) {}
}

void main() {
  setUp(() {});
  tearDown(() {});

  test('sign in', () async {
    when(MockFirebaseAuth.instance
            .signInWithEmailAndPassword(email: null, password: null))
        .thenAnswer((realInvocation) => null);
  });

  test('create account with correct credentials', () async {
    // verifying code populates firestore, creates user
    when(MockFirebaseAuth.instance
            .createUserWithEmailAndPassword(email: null, password: null))
        .thenAnswer((realInvocation) => null);
    when(MockPhoneAuthProvider.credential(
            verificationId: 'vid', smsCode: '123456'))
        .thenReturn(MockPhoneAuthProvider());

    final registrationInfo = RegistrationInfo();
    await AuthService.verifyCodeAndCreateAccount(
        registrationInfo, [1, 2, 3, 4, 5, 6]);
  });

  test('create account fails with invalid credentials', () async {
    // returns false with invalid verification id or verification code
  });

  // that's all
}
