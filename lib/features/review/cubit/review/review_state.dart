part of 'review_cubit.dart';

class ReviewState extends Equatable {
  const ReviewState({
    this.status = NetWorkStatus.initial,
    this.reviews = const [],
  });

  final NetWorkStatus status;
  final List<Review> reviews;

  ReviewState copyWith({
    NetWorkStatus? status,
    List<Review>? reviews,
  }) {
    return ReviewState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
    );
  }

  @override
  List<Object?> get props => [status, reviews];
}
