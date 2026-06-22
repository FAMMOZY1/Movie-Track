import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_track/core/enum/network_status.dart';
import 'package:movie_track/core/models/favorite_movie.dart';
import 'package:movie_track/core/repositories/favorite_repository.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit({FavoriteRepository? favoriteRepository})
      : _favoriteRepository = favoriteRepository ?? FavoriteRepository(),
        super(const FavoriteState());

  final FavoriteRepository _favoriteRepository;

  Future<void> loadFavorites() async {
    emit(state.copyWith(status: NetWorkStatus.loading));
    final favorites = await _favoriteRepository.loadFavorites();
    emit(state.copyWith(status: NetWorkStatus.success, favorites: favorites));
  }

  Future<void> addFavorite(FavoriteMovie movie) async {
    await _favoriteRepository.addFavorite(movie);
    final favorites = await _favoriteRepository.loadFavorites();
    emit(state.copyWith(status: NetWorkStatus.success, favorites: favorites));
  }

  Future<void> removeFavorite(int movieId) async {
    await _favoriteRepository.removeFavorite(movieId);
    final favorites = await _favoriteRepository.loadFavorites();
    emit(state.copyWith(status: NetWorkStatus.success, favorites: favorites));
  }

  Future<void> toggleFavorite(FavoriteMovie movie) async {
    if (isFavorite(movie.id)) {
      await removeFavorite(movie.id);
    } else {
      await addFavorite(movie);
    }
  }

  bool isFavorite(int movieId) =>
      state.favorites.any((m) => m.id == movieId);
}
