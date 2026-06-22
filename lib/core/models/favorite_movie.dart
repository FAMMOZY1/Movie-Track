import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_movie.freezed.dart';
part 'favorite_movie.g.dart';

/// A movie persisted to the favorites JSON file. Holds just enough data to
/// render favorite cards and the remove modal without re-fetching the API.
@freezed
class FavoriteMovie with _$FavoriteMovie {
  const factory FavoriteMovie({
    required int id,
    required String title,
    String? posterPath,
    @Default('') String releaseDate,
    @Default(0.0) double voteAverage,
    @Default('') String genre,
    @Default(0) int runtime,
  }) = _FavoriteMovie;

  factory FavoriteMovie.fromJson(Map<String, dynamic> json) =>
      _$FavoriteMovieFromJson(json);
}
