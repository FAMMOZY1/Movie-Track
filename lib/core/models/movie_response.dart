import 'package:freezed_annotation/freezed_annotation.dart';
import 'movie.dart';

part 'movie_response.freezed.dart';
part 'movie_response.g.dart';

@freezed
class MovieResponse with _$MovieResponse {
  const factory MovieResponse({
    @Default(1) int page,
    @JsonKey(name: 'results') @Default([]) List<Movie> results,
    @JsonKey(name: 'total_pages') @Default(0) int totalPages,
    @JsonKey(name: 'total_results') @Default(0) int totalResults,
  }) = _MovieResponse;

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);
}
