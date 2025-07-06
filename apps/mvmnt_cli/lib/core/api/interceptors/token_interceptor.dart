import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mvmnt_cli/core/api/api_config.dart';

// Bug with the cached token when you change account

class TokenInterceptor extends Interceptor {
  final Dio dio;
  final FirebaseAuth firebaseAuth;

  final Dio _tokenDio = Dio();

  static final Map<String, int> _retryCount = {};
  // int currentRetryCount = 0;
  final int maxRetry = 1;
  String? _cachedToken;
  DateTime? _tokenExpiry;

  TokenInterceptor({required this.dio, required this.firebaseAuth});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (_cachedToken != null &&
          _tokenExpiry != null &&
          _tokenExpiry!.isAfter(DateTime.now())) {
        print('using cached token');
        print(_cachedToken);
        options.headers['Authorization'] = 'Bearer $_cachedToken';
        return handler.next(options);
      }

      var currUser = firebaseAuth.currentUser;
      if (currUser != null) {
        final firebaseToken = await currUser.getIdToken(true);
        if (firebaseToken != null) {
          var response = await _tokenDio.get(
            '${ApiConfig.baseUrl}/auth/token/muvmnt_cli',
            options: Options(
              headers: {'Authorization': 'Bearer $firebaseToken'},
            ),
          );

          if (response.data != null && response.data['data'] != null) {
            final authToken = response.data['data'];
            _cachedToken = authToken;
            print(_cachedToken);
            // Set token expiry (for example, 50 minutes from now)
            _tokenExpiry = DateTime.now().add(Duration(minutes: 60));
            options.headers['Authorization'] = 'Bearer $authToken';
          }
        }
      }

      handler.next(options);
    } catch (e) {
      print(e);
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

    final int currentRetryCount = _retryCount[requestPath] ?? 0;

    if ((err.response?.statusCode == 401) && currentRetryCount <= maxRetry) {
      try {
        _cachedToken = null;
        _tokenExpiry = null;

        var currUser = firebaseAuth.currentUser;
        if (currUser != null) {
          final firebaseToken = await currUser.getIdToken(true);
          if (firebaseToken != null) {
            var response = await _tokenDio.get(
              '${ApiConfig.baseUrl}/auth/token/muvmnt_cli',
              options: Options(
                headers: {'Authorization': 'Bearer $firebaseToken'},
              ),
            );

            if (response.data != null && response.data['data'] != null) {
              final authToken = response.data['data'];
              _cachedToken = authToken;
              // Set token expiry (for example, 50 minutes from now)
              _tokenExpiry = DateTime.now().add(Duration(minutes: 60));
              err.requestOptions.headers['Authorization'] = 'Bearer $authToken';
            }
          }

          // Create a new request with updated token
          final response = await dio.request(
            err.requestOptions.path,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            ),
            queryParameters: err.requestOptions.queryParameters,
            data: err.requestOptions.data,
          );

          // Only clear the retry counter if successful
          _retryCount.remove(requestPath);
          return handler.resolve(response);
        }
      } catch (e) {
        if (currentRetryCount >= maxRetry) {
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
    _tokenExpiry = null;
    print('token cleared');
  }
}
