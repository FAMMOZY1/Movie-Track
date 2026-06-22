import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:movie_track/core/constants/app_constants.dart';
import 'package:movie_track/core/enum/network_status.dart';
import 'package:movie_track/core/models/movie.dart';
import 'package:movie_track/core/theme/export.dart';
import 'package:movie_track/core/widgets/poster_card.dart';
import 'package:movie_track/core/widgets/section_header.dart';
import 'package:movie_track/core/widgets/state_view.dart';
import 'package:movie_track/features/home/cubit/home/home_cubit.dart';
import 'package:movie_track/features/home/widgets/home_skeleton.dart';

/// Home tab: editorial hero banner, "Trending Now" and "Popular Movies"
/// shelves, and a "Browse by Genre" bento grid. Renders only the body + app
/// bar — the bottom navigation is owned by the parent shell.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: const Text('MovieTrack'),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsBold.magnifyingGlass),
            color: AppColor.onSurface,
            onPressed: () => context.push('/search'),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColor.outlineVariant,
          ),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status.isError) {
            return StateView(
              icon: PhosphorIconsBold.warningCircle,
              title: 'Something went wrong',
              subtitle: state.errorMessage,
              actionLabel: 'Try Again',
              onAction: () => context.read<HomeCubit>().getPopularMovies(),
            );
          }
          if (state.status.isSuccess) {
            if (state.movies.isEmpty) {
              return const StateView(
                icon: PhosphorIconsBold.filmSlate,
                title: 'No movies found',
                subtitle: 'Pull down to refresh and try again.',
              );
            }
            return _HomeContent(movies: state.movies);
          }
          // initial / loading
          return const HomeSkeleton();
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final List<Movie> movies;

  const _HomeContent({required this.movies});

  @override
  Widget build(BuildContext context) {
    final trending = movies.take(8).toList();
    final hero = movies.first;

    return RefreshIndicator(
      color: AppColor.primary,
      backgroundColor: AppColor.surfaceContainer,
      onRefresh: () => context.read<HomeCubit>().refresh(),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _HeroBanner(movie: hero),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Trending Now',
            onViewAll: () => context.push('/search'),
          ),
          _Shelf(movies: trending, cardWidth: 220),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Popular Movies',
            onViewAll: () => context.push('/search'),
          ),
          _Shelf(movies: movies, cardWidth: 160),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Browse by Genre'),
          const _GenreGrid(),
        ],
      ),
    );
  }
}

/// Editorial hero with a backdrop image and a bottom-to-top gradient scrim.
class _HeroBanner extends StatelessWidget {
  final Movie movie;

  const _HeroBanner({required this.movie});

  @override
  Widget build(BuildContext context) {
    final path = movie.posterPath;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadiusToken.lg),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.outlineVariant),
            borderRadius: BorderRadius.circular(AppRadiusToken.lg),
            color: AppColor.surfaceContainer,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (path != null && path.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: '${AppConstants.imageBaseUrl}$path',
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const SizedBox.shrink(),
                ),
              // Gradient scrim bottom -> top.
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xE6101415),
                      Color(0x99101415),
                      Color(0x00101415),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "EDITOR'S CHOICE",
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: AppColor.primary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Discover Your Next Masterpiece',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 24,
                            height: 1.15,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal poster shelf with edge padding and no visible scrollbar.
class _Shelf extends StatelessWidget {
  final List<Movie> movies;
  final double cardWidth;

  const _Shelf({required this.movies, required this.cardWidth});

  @override
  Widget build(BuildContext context) {
    final height = cardWidth * 3 / 2 + 64;
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return PosterCard(
            movie: movie,
            width: cardWidth,
            onTap: () => context.push('/movie-detail/${movie.id}'),
          );
        },
      ),
    );
  }
}

/// "Browse by Genre" bento grid: two genre tiles + a full-width tile.
class _GenreGrid extends StatelessWidget {
  const _GenreGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(child: _GenreTile(label: 'ACTION', height: 96)),
              SizedBox(width: 12),
              Expanded(child: _GenreTile(label: 'SCI-FI', height: 96)),
            ],
          ),
          const SizedBox(height: 12),
          const _GenreTile(label: 'ALL CATEGORIES', height: 80),
        ],
      ),
    );
  }
}

class _GenreTile extends StatelessWidget {
  final String label;
  final double height;

  const _GenreTile({required this.label, required this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/search'),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.surfaceContainer,
          borderRadius: BorderRadius.circular(AppRadiusToken.md),
          border: Border.all(color: AppColor.outlineVariant),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: AppColor.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
