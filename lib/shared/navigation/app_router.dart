import 'package:anime_nexa/features/create/views/create_reels.dart';
import 'package:anime_nexa/features/discover/views/discover_page.dart';
import 'package:anime_nexa/features/home/views/homepage.dart';
import 'package:anime_nexa/features/settings/view/notifications_screen.dart';
import 'package:anime_nexa/features/post/views/create_post.dart';
import 'package:anime_nexa/features/user_profile/views/edit_profile.dart';
import 'package:anime_nexa/features/user_profile/views/user_profile.dart';
import 'package:anime_nexa/providers/global_providers.dart';
import 'package:anime_nexa/shared/view/layout_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/views/auth_screen.dart';
import '../../features/auth/views/create_account.dart';
import '../../features/auth/views/genre_selection.dart';
import '../../features/auth/views/name_screen.dart';
import '../../features/auth/views/sign_in.dart';
import '../../features/auth/views/verify_email.dart';
import '../../features/messaging/views/chat_view.dart';
import '../../features/messaging/views/inbox.dart';
import '../../features/onboarding/views/onboarding_screen.dart';
import '../../features/settings/view/accounts.dart';
import '../../features/settings/view/settings_screen.dart';
import '../utils/go_router_refresh_stream.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final appRouterProvider = Provider<GoRouter>(
  (ref) {
    final auth = ref.watch(firebaseAuthProvider);

    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      refreshListenable: GoRouterRefreshStream(auth.authStateChanges()),
      initialLocation: '/',
      redirect: (ctx, state) async {
        final isLoggedIn = auth.currentUser != null;
        final isAuthRoute = state.uri.path.startsWith('/auth');
        // Force refresh the current user to ensure we have the latest state from Firebase
        // try {
        //   if (isLoggedIn) {
        //     await auth.currentUser?.reload();
        //     // If user was deleted on server, this might change isLoggedIn to false
        //     if (auth.currentUser == null) {
        //       return '/auth';
        //     }
        //   }
        // } catch (e) {
        //   // If reload fails (e.g., user was deleted), force logout and go to auth
        //   await auth.signOut();
        //   return '/auth';
        // }
        // If not logged in, force to /auth
        if (!isLoggedIn && !isAuthRoute) {
          return '/auth';
        }
        // // If logged in but trying to access auth flow, send to /home
        // if (isLoggedIn && isAuthRoute) {
        //   return '/home';
        // }

        // Allow navigation
        return null;
      },
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
                    routes:[

                  ]
                ),
                GoRoute(
                  path: '/signIn',
                  builder: (context, state) => const SignIn(),
                ),
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
                  routes: [
                    GoRoute(
                      path: '/chatView',
                      builder: (context, state) => const ChatView(),
                    ),
                    GoRoute(
                      path: '/settings',
                      builder: (context, state) => const SettingsScreen(),
                      routes: [
                        GoRoute(
                          path: '/accounts',
                          builder: (context, state) => const Accounts(),
                        ),
                        GoRoute(
                          path: '/notification',
                          builder: (context, state) =>
                              const NotificationsScreen(),
                        )
                      ],
                    ),
                  ],
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
  },
);
