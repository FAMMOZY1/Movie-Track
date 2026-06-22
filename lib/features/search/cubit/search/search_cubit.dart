import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_track/core/enum/network_status.dart';
import 'package:movie_track/core/models/movie.dart';
import 'package:movie_track/core/repositories/movie_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({MovieRepository? movieRepository})
      : _movieRepository = movieRepository ?? MovieRepository(),
        super(const SearchState());

  final MovieRepository _movieRepository;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(const SearchState());
      return;
    }
    try {
      emit(state.copyWith(status: NetWorkStatus.loading, query: query));
      final movies = await _movieRepository.searchMovies(query);
      emit(state.copyWith(
        status: NetWorkStatus.success,
        movies: movies,
        query: query,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NetWorkStatus.error,
        query: query,
        errorMessage: e.toString(),
      ));
    }
  }

  void clear() {
    emit(const SearchState());
  }
}
