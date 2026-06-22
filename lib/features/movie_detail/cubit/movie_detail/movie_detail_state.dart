part of 'movie_detail_cubit.dart';

class MovieDetailState extends Equatable {
  const MovieDetailState({
    this.status = NetWorkStatus.initial,
    this.movie,
    this.errorMessage,
  });

  final NetWorkStatus status;
  final MovieDetail? movie;
  final String? errorMessage;

  MovieDetailState copyWith({
    NetWorkStatus? status,
    MovieDetail? movie,
    String? errorMessage,
  }) {
    return MovieDetailState(
      status: status ?? this.status,
      movie: movie ?? this.movie,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, movie, errorMessage];
}
