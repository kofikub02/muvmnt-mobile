import 'package:auth/src/domain/entities/auth_entity.dart';


abstract class AuthRepository {
  Stream<DataState<AuthEntity?>> get authChanges;

  Future<DataState<void>> signInWithGoogle();
  Future<DataState<void>> signInWithApple();
  Future<DataState<void>> signInWithFacebook();
  Future<DataState<void>> signInAnonymous();

  Future<DataState<void>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<DataState<void>> signUpWithEmailAndPassword(
    String email,
    String password,
  );
  Future<DataState<void>> resetEmailPassword(String email);
  Future<DataState<void>> sendEmailVerification(String email, bool isNew);
  Future<DataState<bool>> confirmEmailVerification();

  Future<DataState<void>> sendPhoneVerification({
    required String phoneNumber,
    required onVerificaitonFailed,
    required onCodeSent,
    required onCodeAutoRetrievalTimeOut,
    int? forceResendingToken,
  });
  Future<DataState<void>> verifyPhoneCode({
    required String phoneCode,
    required String verificationId,
  });

  Future<DataState<void>> logout();
}
