import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:movie_track/core/enum/network_status.dart';
import 'package:movie_track/features/favorite/cubit/favorite/favorite_cubit.dart';
import 'package:movie_track/features/favorite/widgets/favorite_card.dart';
import 'package:movie_track/features/favorite/widgets/remove_favorite_modal.dart';
import 'package:movie_track/core/theme/export.dart';
import 'package:movie_track/core/widgets/state_view.dart';

/// "My Favorites" screen. Reads the shared FavoriteCubit provided at app root.
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: const Text('My Favorites'),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsBold.magnifyingGlass),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state.status.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.primary),
            );
          }
          if (state.favorites.isEmpty) {
            return StateView(
              icon: PhosphorIconsBold.heartBreak,
              title: 'No favorites yet',
              subtitle:
                  'Movies you save will appear here.\nStart building your collection.',
              actionLabel: 'Browse Movies',
              onAction: () => context.go('/home'),
            );
          }

          final favorites = state.favorites;
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: _CollectionHeader(),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.52,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final movie = favorites[index];
                      return FavoriteCard(
                        movie: movie,
                        onTap: () =>
                            context.push('/movie-detail/${movie.id}'),
                        onRemove: () async {
                          final confirmed =
                              await RemoveFavoriteModal.show(context, movie);
                          if (confirmed && context.mounted) {
                            context
                                .read<FavoriteCubit>()
                                .removeFavorite(movie.id);
                          }
                        },
                      );
                    },
                    childCount: favorites.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  child: _SyncBanner(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CollectionHeader extends StatelessWidget {
  const _CollectionHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('COLLECTION',
                    style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 4),
                Text('Saved Movies',
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const Spacer(),
            Text(
              '${state.favorites.length} Items',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      },
    );
  }
}

class _SyncBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadiusToken.md),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        children: [
          const Icon(PhosphorIconsFill.sparkle,
              color: AppColor.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            'Curating your cinema journey.\nYour favorites are saved on this device.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
