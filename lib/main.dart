import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_track/config/app_router.dart';
import 'package:movie_track/core/theme/export.dart';
import 'package:movie_track/features/favorite/cubit/favorite/favorite_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MovieTrackApp());
}

class MovieTrackApp extends StatelessWidget {
  const MovieTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    // FavoriteCubit is provided app-wide so the detail screen and favorites tab
    // share one source of truth.
    return BlocProvider(
      create: (_) => FavoriteCubit()..loadFavorites(),
      child: MaterialApp.router(
        title: 'MovieTrack',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
