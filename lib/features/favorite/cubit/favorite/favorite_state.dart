part of 'favorite_cubit.dart';

class FavoriteState extends Equatable {
  const FavoriteState({
    this.status = NetWorkStatus.initial,
    this.favorites = const [],
  });

  final NetWorkStatus status;
  final List<FavoriteMovie> favorites;

  FavoriteState copyWith({
    NetWorkStatus? status,
    List<FavoriteMovie>? favorites,
  }) {
    return FavoriteState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props => [status, favorites];
}
