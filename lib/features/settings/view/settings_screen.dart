import 'package:anime_nexa/shared/widgets/reusable_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/constants/app_typography.dart';
import '../widgets/settings_lis_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
          style: AppTypography.linkLarge.copyWith(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            ReusableSearchBar(
              onSearchSubmitted: (value) {},
            ),
            SizedBox(height: 2.5.h),
            SettingsListTile(
              icon: Icons.person_outline,
              title: 'Account',
              onTap: () => context.go('/messaging/settings/accounts'),
            ),
            SizedBox(height: 1.h),
            SettingsListTile(
              icon: Icons.notifications_none,
              title: 'Notifications',
              onTap: () => context.go('/messaging/settings/notification'),
            ),
            SizedBox(height: 0.6.h),
            SettingsListTile(
              icon: Icons.settings_applications_outlined,
              title: 'Content Preferences',
              onTap: () {},
            ),
            SizedBox(height: 0.6.h),
            SettingsListTile(
              icon: Icons.lock_outline,
              title: 'Privacy',
              onTap: () {},
            ),
            SizedBox(height: 0.6.h),
            SettingsListTile(
              icon: Icons.card_giftcard_outlined,
              title: 'Rewards and Blockchain',
              onTap: () {},
            ),
            SizedBox(height: 0.6.h),
            SettingsListTile(
              icon: Icons.group_outlined,
              title: 'Community Features',
              onTap: () {},
            ),
            SizedBox(height: 0.6.h),
            SettingsListTile(
              icon: Icons.display_settings_outlined,
              title: 'Display',
              onTap: () {},
            ),
            SizedBox(height: 0.6.h),
            SettingsListTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {},
            ),
            SizedBox(height: 0.6.h),
            SettingsListTile(
              icon: Icons.info_outline,
              title: 'About AnimeNexa',
              onTap: () {},
            ),
            const Divider(),
            SettingsListTile(
              icon: Icons.logout,
              title: 'Logout',
              titleColor: Colors.red,
              iconColor: Colors.red,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
