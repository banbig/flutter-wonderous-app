import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard_outlined),
          label: localizations.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.photo_library_outlined),
          label: localizations.album,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.cleaning_services_outlined),
          label: localizations.clustering,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.recommend_outlined),
          label: localizations.recommend,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_outlined),
          label: localizations.settings,
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 8,
    );
  }
} 