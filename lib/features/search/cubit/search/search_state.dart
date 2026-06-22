part of 'search_cubit.dart';

class SearchState extends Equatable {
  const SearchState({
    this.status = NetWorkStatus.initial,
    this.movies = const [],
    this.query = '',
    this.errorMessage,
  });

  final NetWorkStatus status;
  final List<Movie> movies;
  final String query;
  final String? errorMessage;

  SearchState copyWith({
    NetWorkStatus? status,
    List<Movie>? movies,
    String? query,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      query: query ?? this.query,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, movies, query, errorMessage];
}
