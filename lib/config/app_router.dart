import 'package:go_router/go_router.dart';
import 'package:movie_track/features/home/screens/home_screen.dart';
import 'package:movie_track/features/search/screens/search_screen.dart';
import 'package:movie_track/features/favorite/screens/favorite_screen.dart';
import 'package:movie_track/features/movie_detail/screens/movie_detail_screen.dart';
import 'package:movie_track/features/review/screens/review_screen.dart';
import 'package:movie_track/core/widgets/splash_screen.dart';
import 'package:movie_track/core/widgets/main_shell.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      // Bottom-nav tabs share a persistent MainShell.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainShell(
          currentIndex: navigationShell.currentIndex,
          onTap: (i) => navigationShell.goBranch(
            i,
            initialLocation: i == navigationShell.currentIndex,
          ),
          child: navigationShell,
        ),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => const FavoriteScreen(),
            ),
          ]),
        ],
      ),
      // Full-screen routes (no bottom nav).
      GoRoute(
        path: '/movie-detail/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return MovieDetailScreen(movieId: id);
        },
      ),
      GoRoute(
        path: '/review',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ReviewScreen(
            movieId: extra?['movieId'] as int? ?? 0,
            movieTitle: extra?['movieTitle'] as String? ?? '',
            posterPath: extra?['posterPath'] as String?,
            subtitle: extra?['subtitle'] as String?,
            rating: extra?['rating'] as double?,
          );
        },
      ),
    ],
  );
}
