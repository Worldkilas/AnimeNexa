import 'package:anime_nexa/shared/constants/app_theme.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({super.key, required this.statefulNavigationShell});
  final StatefulNavigationShell statefulNavigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: statefulNavigationShell,
      bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          surfaceTintColor: null,
          labelTextStyle: WidgetStateTextStyle.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTypography.textXSmall
                  .copyWith(color: appTheme.primaryColor);
            }

            return AppTypography.textXSmall.copyWith(color: Colors.grey);
          }),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: statefulNavigationShell.currentIndex,
          onDestinationSelected: (index) => index == 2
              ? context.push('/post')
              : statefulNavigationShell.goBranch(index),
          indicatorColor: Colors.transparent,
          destinations: [
            NavigationDestination(
              icon: SvgPicture.asset('lib/assets/icons/home.svg'),
              label: 'Home',
              selectedIcon: SvgPicture.asset(
                'lib/assets/icons/home.svg',
                colorFilter:
                    ColorFilter.mode(appTheme.primaryColor, BlendMode.srcIn),
              ),
            ),
            NavigationDestination(
              icon: SvgPicture.asset('lib/assets/icons/discover.svg'),
              label: 'Discover',
              selectedIcon: SvgPicture.asset(
                'lib/assets/icons/discover.svg',
                colorFilter:
                    ColorFilter.mode(appTheme.primaryColor, BlendMode.srcIn),
              ),
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'lib/assets/icons/Add.svg',
              ),
              label: '',
            ),
            NavigationDestination(
              icon: SvgPicture.asset('lib/assets/icons/messages.svg'),
              label: 'Message',
              selectedIcon: SvgPicture.asset(
                'lib/assets/icons/messages.svg',
                colorFilter:
                    ColorFilter.mode(appTheme.primaryColor, BlendMode.srcIn),
              ),
            ),
            NavigationDestination(
              icon: SvgPicture.asset('lib/assets/icons/profile.svg'),
              label: 'Profile',
              selectedIcon: SvgPicture.asset(
                'lib/assets/icons/profile.svg',
                colorFilter:
                    ColorFilter.mode(appTheme.primaryColor, BlendMode.srcIn),
              ),
            ),
          ]),
    );
  }
}
