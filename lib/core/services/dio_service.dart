import 'package:dio/dio.dart';
import 'package:movie_track/core/api/dio_interceptor.dart';
import 'package:movie_track/core/constants/app_constants.dart';

/// Singleton holding two Dio instances (Sennalabs convention):
/// [clientService] carries the interceptor; [refreshService] is interceptor-free
/// (reserved for token-refresh flows — unused for TMDB's key-based auth).
class DioService {
  DioService._internal() {
    _clientService = _createDio(withInterceptor: true);
    _refreshService = _createDio(withInterceptor: false);
  }

  static final DioService _instance = DioService._internal();
  factory DioService() => _instance;

  late final Dio _clientService;
  late final Dio _refreshService;

  Dio get clientService => _clientService;
  Dio get refreshService => _refreshService;

  Dio _createDio({required bool withInterceptor}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    if (withInterceptor) dio.interceptors.add(DioInterceptor());
    return dio;
  }
}
