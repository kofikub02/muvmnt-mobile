import 'package:dio/dio.dart';
import '../api_response.dart';

// Bug with the cached token when you change account
class TokenInterceptor extends Interceptor {
  final Future<String?> Function() getToken;

  String? _cachedToken;
  final int _maxRetry = 1;
  final Map<String, int> _retryCount = {};
  final Dio _dio = Dio();

  TokenInterceptor({
    required this.getToken,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (_cachedToken != null) {
        options.headers['Authorization'] = 'Bearer $_cachedToken';
        return handler.next(options);
      }

      final authToken = await getToken();
      if (authToken != null) {
        _cachedToken = authToken;
        options.headers['Authorization'] = 'Bearer $authToken';
      }

      handler.next(options);
    } on DioException catch (_) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Failed to retrieve token',
        ),
        true,
      );
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Maintain retry count at instance level to prevent reset during retry
    final requestPath = err.requestOptions.path;
    _retryCount[requestPath] = (_retryCount[requestPath] ?? 0) + 1;
    final currentRetryCount = _retryCount[requestPath] ?? 0;

    if ((err.response?.statusCode == 401) && currentRetryCount <= _maxRetry) {
      try {
        _cachedToken = null;

        final authToken = await getToken();
        if (authToken != null) {
          _cachedToken = authToken;
          err.requestOptions.headers['Authorization'] = 'Bearer $authToken';

          final response = await _dio.request<dynamic>(
            err.requestOptions.path,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            ),
            queryParameters: err.requestOptions.queryParameters,
            data: err.requestOptions.data,
          );

          // Convert response data to ApiResponse and update the response
          if (response.data is Map<String, dynamic>) {
            final apiResponse = ApiResponse<dynamic>.fromJson(
              response.data as Map<String, dynamic>,
              (json) => json,
            );
            response.data = apiResponse;
          }

          // Only clear the retry counter if successful
          _retryCount.remove(requestPath);
          return handler.resolve(response);
        }
      } on DioException catch (_) {
        if (currentRetryCount >= _maxRetry) {
          _retryCount.remove(requestPath);
        }
        return handler.next(err);
      }
    } else {
      // Clear counter for non-auth errors or exceeded retries
      _retryCount.remove(requestPath);
      handler.next(err);
    }
  }

  void clearToken() {
    _cachedToken = null;
  }
}
