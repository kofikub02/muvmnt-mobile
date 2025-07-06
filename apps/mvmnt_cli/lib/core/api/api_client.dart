import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mvmnt_cli/core/api/api_config.dart';
import 'package:mvmnt_cli/core/api/interceptors/token_interceptor.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  TokenInterceptor? _tokenInterceptor;

  Dio getDio({bool tokenInterceptor = false}) {
    Dio dio = Dio();
    dio.options.baseUrl = ApiConfig.baseUrl;
    dio.options.validateStatus = (status) => true;

    if (tokenInterceptor) {
      _tokenInterceptor = TokenInterceptor(
        dio: dio,
        firebaseAuth: serviceLocator<FirebaseAuth>(),
      );
      dio.interceptors.add(_tokenInterceptor!);
    }

    dio.interceptors.add(
      PrettyDioLogger(
        responseHeader: true,
        responseBody: true,
        requestHeader: true,
        requestBody: true,
        request: true,
        compact: false,
      ),
    );

    return dio;
  }

  void clearAuthToken() {
    _tokenInterceptor?.clearToken();
  }
}
