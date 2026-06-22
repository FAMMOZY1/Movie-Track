import 'package:dio/dio.dart';
import 'package:movie_track/core/constants/app_constants.dart';

/// Injects the TMDB api_key + language on every request (Sennalabs convention:
/// interceptor owns auth/common params, collections own routes).
class DioInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.queryParameters['api_key'] = AppConstants.apiKey;
    options.queryParameters['language'] = 'en-US';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
