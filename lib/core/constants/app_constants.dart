import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get apiKey => dotenv.env['TMDB_API_KEY'] ?? '';
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'https://api.themoviedb.org/3';
  static String get imageBaseUrl => dotenv.env['IMAGE_BASE_URL'] ?? 'https://image.tmdb.org/t/p/w500';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
