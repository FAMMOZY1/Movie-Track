import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:movie_track/core/models/movie.dart';
import 'package:movie_track/core/widgets/poster_card.dart';

/// 2-column grid skeleton shown while a search request is in flight.
class SearchSkeleton extends StatelessWidget {
  const SearchSkeleton({super.key});

  static const Movie _placeholder = Movie(
    id: 0,
    title: 'Placeholder Movie Title',
    posterPath: null,
    releaseDate: '2024-01-01',
    voteAverage: 8.0,
    overview: '',
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.58,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return PosterCard(
            movie: _placeholder,
            width: double.infinity,
            onTap: () {},
          );
        },
      ),
    );
  }
}
