import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'interceptors/token_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class ApiClient {
  TokenInterceptor? _tokenInterceptor;

  Dio getDio(String baseUrl) {
    final dio = Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.validateStatus = (status) => true;
    _tokenInterceptor = TokenInterceptor(
      getToken: getToken,
    );
    dio.interceptors.add(_tokenInterceptor!);

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          responseHeader: true,
          requestHeader: true,
          requestBody: true,
          compact: false,
        ),
      );
    }

    return dio;
  }

  void refresh() {
    _tokenInterceptor?.clearToken();
  }

  Future<String?> getToken();
}
