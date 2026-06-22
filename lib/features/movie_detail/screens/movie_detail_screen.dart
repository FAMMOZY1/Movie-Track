import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'package:movie_track/core/enum/network_status.dart';
import 'package:movie_track/core/models/favorite_movie.dart';
import 'package:movie_track/core/models/movie_detail.dart';
import 'package:movie_track/core/models/review.dart';
import 'package:movie_track/core/theme/export.dart';
import 'package:movie_track/core/utils/date_utils.dart';
import 'package:movie_track/core/widgets/poster_image.dart';
import 'package:movie_track/core/widgets/state_view.dart';
import 'package:movie_track/features/favorite/cubit/favorite/favorite_cubit.dart';
import 'package:movie_track/features/movie_detail/cubit/movie_detail/movie_detail_cubit.dart';
import 'package:movie_track/features/movie_detail/widgets/detail_skeleton.dart';
import 'package:movie_track/features/review/cubit/review/review_cubit.dart';

/// Formats a runtime in minutes as "Xh Ym" (e.g. 166 -> "2h 46m").
String _formatRuntime(int minutes) {
  if (minutes <= 0) return 'N/A';
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return '${m}m';
  if (m == 0) return '${h}h';
  return '${h}h ${m}m';
}

class MovieDetailScreen extends StatelessWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MovieDetailCubit()..getMovieDetail(movieId),
        ),
        BlocProvider(
          create: (_) => ReviewCubit()..loadReviews(movieId),
        ),
      ],
      child: _MovieDetailView(movieId: movieId),
    );
  }
}

class _MovieDetailView extends StatelessWidget {
  final int movieId;
  const _MovieDetailView({required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        builder: (context, state) {
          if (state.status.isLoading || state.status.isInitial) {
            return const DetailSkeleton();
          }
          if (state.status.isError) {
            return SafeArea(
              child: StateView(
                icon: PhosphorIconsBold.warningCircle,
                title: 'Something went wrong',
                subtitle: state.errorMessage,
                actionLabel: 'Try Again',
                onAction: () => context
                    .read<MovieDetailCubit>()
                    .getMovieDetail(movieId),
              ),
            );
          }
          if (state.status.isSuccess && state.movie != null) {
            return _DetailContent(movie: state.movie!);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final MovieDetail movie;
  const _DetailContent({required this.movie});

  FavoriteMovie _toFavorite() => FavoriteMovie(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        releaseDate: movie.releaseDate,
        voteAverage: movie.voteAverage,
        genre: movie.genres.map((g) => g.name).join(', '),
        runtime: movie.runtime,
      );

  void _share() {
    Share.share(
      '${movie.title}\n\n'
      'Rating: ${movie.voteAverage.toStringAsFixed(1)}/10\n\n'
      'Shared from MovieTrack',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metadata = [
      AppDateUtils.formatYear(movie.releaseDate),
      if (movie.originalLanguage.isNotEmpty)
        movie.originalLanguage.toUpperCase(),
      if (movie.runtime > 0) _formatRuntime(movie.runtime),
    ].join(' • ');

    return SafeArea(
      top: false,
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  backgroundColor: AppColor.background,
                  surfaceTintColor: Colors.transparent,
                  leading: _CircleButton(
                    icon: PhosphorIconsBold.arrowLeft,
                    onTap: () => context.pop(),
                  ),
                  actions: [
                    BlocBuilder<FavoriteCubit, FavoriteState>(
                      builder: (context, favState) {
                        final isFav = favState.favorites
                            .any((m) => m.id == movie.id);
                        return _CircleButton(
                          icon: isFav
                              ? PhosphorIconsFill.heart
                              : PhosphorIconsBold.heart,
                          iconColor: isFav ? AppColor.error : null,
                          onTap: () => context
                              .read<FavoriteCubit>()
                              .toggleFavorite(_toFavorite()),
                        );
                      },
                    ),
                    _CircleButton(
                      icon: PhosphorIconsBold.shareNetwork,
                      onTap: _share,
                    ),
                    const SizedBox(width: 8),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        PosterImage(
                          path: movie.backdropPath ?? movie.posterPath,
                          fit: BoxFit.cover,
                          radius: 0,
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColor.background.withValues(alpha: 0.55),
                                AppColor.background.withValues(alpha: 0.0),
                                AppColor.background.withValues(alpha: 0.85),
                                AppColor.background,
                              ],
                              stops: const [0.0, 0.35, 0.85, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PosterImage(
                          path: movie.posterPath,
                          width: 120,
                          height: 180,
                          radius: AppRadiusToken.md,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(movie.title,
                                    style: theme.textTheme.titleLarge),
                                const SizedBox(height: 8),
                                Text(
                                  metadata,
                                  style: theme.textTheme.bodySmall,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(PhosphorIconsFill.star,
                                        color: AppColor.rating, size: 18),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${movie.voteAverage.toStringAsFixed(1)}/10',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(color: AppColor.rating),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '(${movie.voteCount})',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (movie.genres.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: movie.genres
                            .map((g) => _GenreChip(name: g.name))
                            .toList(),
                      ),
                    ),
                  ),
                if (movie.overview.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Overview',
                              style: theme.textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(
                            movie.overview,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(height: 1.6),
                          ),
                        ],
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: BlocBuilder<ReviewCubit, ReviewState>(
                    builder: (context, reviewState) =>
                        _ReviewsSection(reviews: reviewState.reviews),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
          _BottomActionBar(
            onShare: _share,
            onReview: () => context.push('/review', extra: {
              'movieId': movie.id,
              'movieTitle': movie.title,
            }),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Material(
        color: AppColor.surface.withValues(alpha: 0.55),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon,
                size: 20, color: iconColor ?? AppColor.onSurface),
          ),
        ),
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  final String name;
  const _GenreChip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadiusToken.full),
      ),
      child: Text(
        name,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColor.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final VoidCallback onShare;
  final VoidCallback onReview;
  const _BottomActionBar({required this.onShare, required this.onReview});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: AppColor.background,
        border: Border(top: BorderSide(color: AppColor.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onShare,
                icon: const Icon(PhosphorIconsBold.shareNetwork, size: 18),
                label: const Text('Share'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.onSurface,
                  side: const BorderSide(color: AppColor.border),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadiusToken.normal),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onReview,
                icon: const Icon(PhosphorIconsBold.pencilSimple, size: 18),
                label: const Text('Write Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  final List<Review> reviews;
  const _ReviewsSection({required this.reviews});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Reviews', style: theme.textTheme.titleMedium),
              const SizedBox(width: 8),
              if (reviews.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColor.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppRadiusToken.full),
                  ),
                  child: Text('${reviews.length}',
                      style: theme.textTheme.labelSmall),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (reviews.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No reviews yet. Be the first to write one!',
                style: theme.textTheme.bodySmall,
              ),
            )
          else
            ...reviews.map((r) => _ReviewTile(review: r)),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Review review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadiusToken.md),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(review.reviewerName,
                    style: theme.textTheme.titleSmall),
              ),
              Row(
                children: List.generate(5, (i) {
                  final filled = i < review.rating;
                  return Icon(
                    filled ? PhosphorIconsFill.star : PhosphorIconsBold.star,
                    size: 14,
                    color: filled ? AppColor.rating : AppColor.outline,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.comment,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}
