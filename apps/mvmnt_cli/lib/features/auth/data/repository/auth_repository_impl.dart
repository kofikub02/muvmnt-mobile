import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/auth/data/datasources/auth_firebase_service.dart';
import 'package:mvmnt_cli/features/auth/domain/entities/auth_entity.dart';
import 'package:mvmnt_cli/features/auth/domain/repository/auth_repository.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthFirebaseService firebaseDataSource;

  AuthRepositoryImpl({required this.firebaseDataSource});

  @override
  Stream<DataState<AuthEntity?>> get authChanges {
    return firebaseDataSource.authChanges.map((authUserModel) {
      return DataSuccess(authUserModel);
    });
  }

  @override
  Future<DataState<void>> signInWithApple() async {
    try {
      await firebaseDataSource.signInWithApple();
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> signInWithGoogle() async {
    try {
      await firebaseDataSource.signInWithGoogle();
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> signInWithFacebook() async {
    try {
      await firebaseDataSource.signInWithFacebook();
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<AuthEntity>> signInAnonymous() async {
    try {
      final result = await firebaseDataSource.signInAnonymous();
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> sendPhoneVerification({
    required String phoneNumber,
    required onVerificaitonFailed,
    required onCodeSent,
    required onCodeAutoRetrievalTimeOut,
    int? forceResendingToken,
  }) async {
    try {
      await firebaseDataSource.sendPhoneVerification(
        phoneNumber: phoneNumber,
        onVerificaitonFailed: onVerificaitonFailed,
        onCodeSent: onCodeSent,
        onCodeAutoRetrievalTimeOut: onCodeAutoRetrievalTimeOut,
        forceResendingToken: forceResendingToken,
      );
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> verifyPhoneCode({
    required String phoneCode,
    required String verificationId,
  }) async {
    try {
      await firebaseDataSource.verifyPhoneCode(
        smsCode: phoneCode,
        verificationId: verificationId,
      );
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await firebaseDataSource.signInWithEmailAndPassword(
        email,
        password,
      );
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await firebaseDataSource.signUpWithEmailAndPassword(
        email,
        password,
      );
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> sendEmailVerification(
    String email,
    bool isNew,
  ) async {
    try {
      return DataSuccess(
        await firebaseDataSource.sendEmailVerification(email, isNew),
      );
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<bool>> confirmEmailVerification() async {
    try {
      return DataSuccess(await firebaseDataSource.confirmEmailVerification());
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> resetEmailPassword(String email) async {
    try {
      await firebaseDataSource.resetPassword(email);
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> logout() async {
    try {
      await firebaseDataSource.signOut();
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: e.toString(),
        ),
      );
    }
  }
}
