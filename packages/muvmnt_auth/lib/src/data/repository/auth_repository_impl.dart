import 'package:dio/dio.dart';
import 'package:muvmnt_auth/src/data/datasources/auth_firebase_service.dart';
import 'package:muvmnt_auth/src/domain/entities/auth_entity.dart';
import 'package:muvmnt_auth/src/domain/repository/auth_repository.dart';
import 'package:muvmnt_core/muvmnt_core.dart';

class AuthRepositoryImpl extends AuthRepository {
  final Dio _dio = Dio();
  final AuthFirebaseService _firebaseDataSource = AuthFirebaseService();

  @override
  Stream<DataState<AuthEntity?>> get authChanges {
    return _firebaseDataSource.authChanges.map((authUserModel) {
      return DataSuccess(authUserModel);
    });
  }

  @override
  Future<DataState<String?>> getAuthToken(String? exchangeUrl) async {
    try {
      final currentUser = _firebaseDataSource.getCurrentUser;
      if (currentUser != null) {
        final firebaseIdToken = await currentUser.getIdToken();
        if (exchangeUrl != null) {
          var response = await _dio.get(exchangeUrl, options: Options(headers: { 'Authorization': 'Bearer $firebaseIdToken' }));
          if (response.data != null && response.data['data'] != null) {
            return DataSuccess(response.data['data']);
          }
        } else {
          return DataSuccess(firebaseIdToken);
        }
      }

      return DataSuccess(null);
    } on DioException catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> signInWithApple() async {
    try {
      await _firebaseDataSource.signInWithApple();
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
      await _firebaseDataSource.signInWithGoogle();
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
      await _firebaseDataSource.signInWithFacebook();
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
      final result = await _firebaseDataSource.signInAnonymous();
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
      await _firebaseDataSource.sendPhoneVerification(
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
      await _firebaseDataSource.verifyPhoneCode(
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
      final result = await _firebaseDataSource.signInWithEmailAndPassword(
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
      final result = await _firebaseDataSource.signUpWithEmailAndPassword(
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
        await _firebaseDataSource.sendEmailVerification(email, isNew),
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
      return DataSuccess(await _firebaseDataSource.confirmEmailVerification());
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
      await _firebaseDataSource.resetPassword(email);
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
      await _firebaseDataSource.signOut();
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
