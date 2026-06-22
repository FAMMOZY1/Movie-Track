import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_track/core/enum/network_status.dart';
import 'package:movie_track/core/models/movie_detail.dart';
import 'package:movie_track/core/repositories/movie_repository.dart';

part 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  MovieDetailCubit({MovieRepository? movieRepository})
      : _movieRepository = movieRepository ?? MovieRepository(),
        super(const MovieDetailState());

  final MovieRepository _movieRepository;

  Future<void> getMovieDetail(int movieId) async {
    try {
      emit(state.copyWith(status: NetWorkStatus.loading));
      final movie = await _movieRepository.getMovieDetail(movieId);
      emit(state.copyWith(status: NetWorkStatus.success, movie: movie));
    } catch (e) {
      emit(state.copyWith(
          status: NetWorkStatus.error, errorMessage: e.toString()));
    }
  }
}
