import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_track/core/enum/network_status.dart';
import 'package:movie_track/core/models/movie.dart';
import 'package:movie_track/core/repositories/movie_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({MovieRepository? movieRepository})
      : _movieRepository = movieRepository ?? MovieRepository(),
        super(const HomeState()) {
    getPopularMovies();
  }

  final MovieRepository _movieRepository;

  Future<void> getPopularMovies() async {
    try {
      emit(state.copyWith(status: NetWorkStatus.loading));
      final movies = await _movieRepository.getPopularMovies();
      emit(state.copyWith(status: NetWorkStatus.success, movies: movies));
    } catch (e) {
      emit(state.copyWith(
          status: NetWorkStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> refresh() async {
    try {
      final movies = await _movieRepository.getPopularMovies();
      emit(state.copyWith(status: NetWorkStatus.success, movies: movies));
    } catch (e) {
      emit(state.copyWith(
          status: NetWorkStatus.error, errorMessage: e.toString()));
    }
  }
}
