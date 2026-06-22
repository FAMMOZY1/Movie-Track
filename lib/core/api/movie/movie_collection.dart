import 'package:movie_track/core/models/movie.dart';
import 'package:movie_track/core/models/movie_detail.dart';
import 'package:movie_track/core/models/movie_response.dart';
import 'package:movie_track/core/services/dio_service.dart';

/// TMDB movie API client — one method per endpoint (Sennalabs "Collection").
class MovieCollection {
  Future<List<Movie>> getPopularMovies() async {
    final response =
        await DioService().clientService.get('/movie/popular');
    final movieResponse =
        MovieResponse.fromJson(response.data as Map<String, dynamic>);
    return movieResponse.results;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await DioService().clientService.get(
      '/search/movie',
      queryParameters: {'query': query},
    );
    final movieResponse =
        MovieResponse.fromJson(response.data as Map<String, dynamic>);
    return movieResponse.results;
  }

  Future<MovieDetail> getMovieDetail(int movieId) async {
    final response =
        await DioService().clientService.get('/movie/$movieId');
    return MovieDetail.fromJson(response.data as Map<String, dynamic>);
  }
}
