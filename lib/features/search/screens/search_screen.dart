import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:movie_track/core/enum/network_status.dart';
import 'package:movie_track/core/theme/export.dart';
import 'package:movie_track/core/widgets/poster_card.dart';
import 'package:movie_track/core/widgets/state_view.dart';
import 'package:movie_track/features/search/cubit/search/search_cubit.dart';
import 'package:movie_track/features/search/widgets/search_skeleton.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  String _lastQuery = '';
  int _activeFilter = 0;

  static const List<String> _filters = [
    'All Results',
    'Movies',
    'Box Office',
    'Trailers',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String query) {
    setState(() {}); // refresh clear-button visibility
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _lastQuery = query;
      context.read<SearchCubit>().search(query);
    });
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    _lastQuery = '';
    setState(() {});
    context.read<SearchCubit>().clear();
  }

  void _retry() {
    if (_lastQuery.trim().isNotEmpty) {
      context.read<SearchCubit>().search(_lastQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchField(),
            _buildFilterChips(),
            const SizedBox(height: AppSpace.xs),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) => _buildBody(context, state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    final hasText = _controller.text.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: SizedBox(
        height: 48,
        child: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColor.onSurface,
                fontSize: 15,
              ),
          onChanged: _onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.surfaceContainerLow,
            hintText: 'Search movies...',
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            prefixIcon: const Icon(
              PhosphorIconsBold.magnifyingGlass,
              size: 20,
              color: AppColor.textMuted,
            ),
            suffixIcon: hasText
                ? IconButton(
                    icon: const Icon(
                      PhosphorIconsBold.x,
                      size: 18,
                      color: AppColor.textMuted,
                    ),
                    onPressed: _clear,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadiusToken.normal),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadiusToken.normal),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadiusToken.normal),
              borderSide: const BorderSide(color: AppColor.primary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final active = index == _activeFilter;
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = index),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color:
                    active ? AppColor.primary : AppColor.surfaceContainer,
                borderRadius: BorderRadius.circular(AppRadiusToken.full),
                border: Border.all(
                  color: active ? AppColor.primary : AppColor.border,
                ),
              ),
              child: Text(
                _filters[index],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: active ? AppColor.white : AppColor.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, SearchState state) {
    if (state.status.isLoading) {
      return const SearchSkeleton();
    }
    if (state.status.isError) {
      return StateView(
        icon: PhosphorIconsBold.warningCircle,
        iconColor: AppColor.error,
        title: 'Something went wrong',
        subtitle: state.errorMessage,
        actionLabel: 'Try Again',
        onAction: _retry,
      );
    }
    if (state.status.isSuccess) {
      if (state.movies.isEmpty && state.query.isNotEmpty) {
        return const StateView(
          icon: PhosphorIconsBold.filmReel,
          title: 'No results found',
          subtitle: 'Try searching for something else',
        );
      }
      if (state.movies.isNotEmpty) {
        return _buildResults(context, state);
      }
    }
    // initial
    return const StateView(
      icon: PhosphorIconsBold.magnifyingGlass,
      title: 'Search for a movie',
      subtitle: 'Find your next favorite film',
    );
  }

  Widget _buildResults(BuildContext context, SearchState state) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          sliver: SliverToBoxAdapter(
            child: Text(
              '${state.movies.length} results',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.52,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final movie = state.movies[index];
                return PosterCard(
                  movie: movie,
                  width: double.infinity,
                  onTap: () => context.push('/movie-detail/${movie.id}'),
                );
              },
              childCount: state.movies.length,
            ),
          ),
        ),
        SliverToBoxAdapter(child: _buildRecommendedSearches(context)),
      ],
    );
  }

  Widget _buildRecommendedSearches(BuildContext context) {
    const items = <(IconData, String)>[
      (PhosphorIconsBold.filmReel, 'Top 250 Movies'),
      (PhosphorIconsBold.arrowClockwise, 'Recently Released'),
      (PhosphorIconsBold.filmReel, 'Academy Award Winners'),
      (PhosphorIconsBold.magnifyingGlass, 'Now in Cinemas'),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Recommended Searches',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final item in items)
            InkWell(
              onTap: () {}, // decorative
              borderRadius: BorderRadius.circular(AppRadiusToken.normal),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Icon(item.$1, size: 20, color: AppColor.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.$2,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
