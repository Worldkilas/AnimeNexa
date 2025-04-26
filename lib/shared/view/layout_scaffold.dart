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
          selectedIndex: statefulNavigationShell.currentIndex,
          onDestinationSelected: (index) => index == 2 ? context.push('/post') : statefulNavigationShell.goBranch(index),
          indicatorColor: Theme.of(context).primaryColor,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: [
            NavigationDestination(
              icon: SvgPicture.asset('lib/assets/icons/home.svg'),
              label: 'Home',
            ),
            NavigationDestination(
              icon: SvgPicture.asset('lib/assets/icons/discover.svg'),
              label: 'Discover',
            ),
            NavigationDestination(
              icon: SvgPicture.asset('lib/assets/icons/Add.svg'),
              label: '',
            ),
            NavigationDestination(
              icon: SvgPicture.asset('lib/assets/icons/messages.svg'),
              label: 'Messages',
            ),
            NavigationDestination(
              icon: SvgPicture.asset('lib/assets/icons/profile.svg'),
              label: 'Profile',
            ),
          ]),
    );
  }
}
