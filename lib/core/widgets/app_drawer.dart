import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:movie_track/core/theme/export.dart';

/// Side navigation drawer opened from the menu button on tab screens.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(AppRadiusToken.lg)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(AppRadiusToken.md),
                    ),
                    child: const Icon(PhosphorIconsFill.filmSlate,
                        color: AppColor.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MovieTrack', style: AppText.appTitle),
                      Text('Track your favorite movies',
                          style: AppText.metadata),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Nav items
            _DrawerItem(
              icon: PhosphorIconsBold.house,
              label: 'Home',
              onTap: () {
                Navigator.pop(context);
                context.go('/home');
              },
            ),
            _DrawerItem(
              icon: PhosphorIconsBold.magnifyingGlass,
              label: 'Search',
              onTap: () {
                Navigator.pop(context);
                context.go('/search');
              },
            ),
            _DrawerItem(
              icon: PhosphorIconsBold.heart,
              label: 'Favorites',
              onTap: () {
                Navigator.pop(context);
                context.go('/favorites');
              },
            ),

            const Spacer(),
            const Divider(),
            _DrawerItem(
              icon: PhosphorIconsBold.info,
              label: 'About',
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'MovieTrack',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(PhosphorIconsFill.filmSlate,
                      color: AppColor.primary),
                  children: const [
                    Text('Find and track your favorite movies, powered by TMDB.'),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColor.onSurfaceVariant, size: 22),
      title: Text(label, style: AppText.movieTitle),
      onTap: onTap,
      visualDensity: VisualDensity.compact,
    );
  }
}
