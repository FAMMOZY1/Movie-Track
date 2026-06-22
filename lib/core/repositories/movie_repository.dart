import 'package:movie_track/core/api/movie/movie_collection.dart';
import 'package:movie_track/core/models/movie.dart';
import 'package:movie_track/core/models/movie_detail.dart';

/// Wraps [MovieCollection]. Constructor-injectable for testability.
class MovieRepository {
  MovieRepository({MovieCollection? movieCollection})
      : _collection = movieCollection ?? MovieCollection();

  final MovieCollection _collection;

  Future<List<Movie>> getPopularMovies() => _collection.getPopularMovies();

  Future<List<Movie>> searchMovies(String query) =>
      _collection.searchMovies(query);

  Future<MovieDetail> getMovieDetail(int movieId) =>
      _collection.getMovieDetail(movieId);
}
