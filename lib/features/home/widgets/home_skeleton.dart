import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:movie_track/core/models/movie.dart';
import 'package:movie_track/core/theme/export.dart';
import 'package:movie_track/core/widgets/poster_card.dart';
import 'package:movie_track/core/widgets/section_header.dart';

/// Loading placeholder for the Home screen. Mirrors the real layout (hero
/// banner + two horizontal shelves) wrapped in a [Skeletonizer] so the
/// shimmering bones match the final content shape.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  static const Movie _fake = Movie(
    id: 0,
    title: 'Placeholder Movie Title',
    posterPath: null,
    releaseDate: '2024-01-01',
    voteAverage: 8.5,
    overview: '',
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // Hero banner placeholder.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Skeleton.leaf(
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColor.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppRadiusToken.lg),
                ),
              ),
            ),
          ),
          // Trending shelf.
          const SectionHeader(title: 'Trending Now'),
          const _Shelf(width: 220, height: 220 * 3 / 2 + 64),
          const SizedBox(height: 24),
          // Popular shelf.
          const SectionHeader(title: 'Popular Movies'),
          const _Shelf(width: 160, height: 160 * 3 / 2 + 64),
        ],
      ),
    );
  }
}

class _Shelf extends StatelessWidget {
  final double width;
  final double height;

  const _Shelf({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => PosterCard(
          movie: HomeSkeleton._fake,
          width: width,
          onTap: () {},
        ),
      ),
    );
  }
}
