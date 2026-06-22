import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_track/core/enum/network_status.dart';
import 'package:movie_track/core/models/review.dart';
import 'package:movie_track/core/repositories/review_repository.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit({ReviewRepository? reviewRepository})
      : _reviewRepository = reviewRepository ?? ReviewRepository(),
        super(const ReviewState());

  final ReviewRepository _reviewRepository;

  Future<void> loadReviews(int movieId) async {
    try {
      emit(state.copyWith(status: NetWorkStatus.loading));
      final reviews = await _reviewRepository.reviewsFor(movieId);
      emit(state.copyWith(status: NetWorkStatus.success, reviews: reviews));
    } catch (e) {
      emit(state.copyWith(status: NetWorkStatus.error));
    }
  }

  Future<void> submitReview(Review review) async {
    try {
      emit(state.copyWith(status: NetWorkStatus.loading));
      await _reviewRepository.addReview(review);
      final reviews = await _reviewRepository.reviewsFor(review.movieId);
      emit(state.copyWith(status: NetWorkStatus.success, reviews: reviews));
    } catch (e) {
      emit(state.copyWith(status: NetWorkStatus.error));
    }
  }
}
