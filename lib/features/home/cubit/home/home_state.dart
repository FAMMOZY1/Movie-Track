part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = NetWorkStatus.initial,
    this.movies = const [],
    this.errorMessage,
  });

  final NetWorkStatus status;
  final List<Movie> movies;
  final String? errorMessage;

  HomeState copyWith({
    NetWorkStatus? status,
    List<Movie>? movies,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, movies, errorMessage];
}
