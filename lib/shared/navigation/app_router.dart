import 'package:anime_nexa/features/create/views/create_reels.dart';
import 'package:anime_nexa/features/discover/views/discover_page.dart';
import 'package:anime_nexa/features/home/views/homepage.dart';
import 'package:anime_nexa/features/post/views/create_post.dart';

import 'package:anime_nexa/features/user_profile/views/edit_profile.dart';
import 'package:anime_nexa/features/user_profile/views/user_profile.dart';
import 'package:anime_nexa/shared/view/layout_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/views/auth_screen.dart';
import '../../features/auth/views/create_account.dart';
import '../../features/auth/views/genre_selection.dart';
import '../../features/auth/views/name_screen.dart';
import '../../features/auth/views/sign_in.dart';
import '../../features/auth/views/verify_email.dart';
import '../../features/messaging/views/inbox.dart';
import '../../features/onboarding/views/onboarding_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final appRouterConfig = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingScreen(),
      routes: [
        GoRoute(
          path: '/auth',
          builder: (context, state) => const AuthScreen(),
          routes: [
            GoRoute(
              path: '/createAcct',
              builder: (context, state) => const CreateAccount(),
            ),
            GoRoute(
              path: '/signIn',
              builder: (context, state) => const SignIn(),
              routes: [
                GoRoute(
                  path: '/verifyEmail',
                  builder: (context, state) => const EmailVerificationScreen(),
                ),
                GoRoute(
                  path: '/setNameAndUsername',
                  builder: (context, state) => NameScreen(),
                  routes: [
                    GoRoute(
                      path: '/genre',
                      builder: (context, state) => const GenresScreen(),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => LayoutScaffold(
        statefulNavigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const Homepage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/discover',
              builder: (context, state) => const DiscoverPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/crete',
              builder: (context, state) => const CreateReels(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/messaging',
              builder: (context, state) => const InboxView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/edit',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/post',
      builder: (context, state) => const CreatePost(),
    ),
  ],
);
