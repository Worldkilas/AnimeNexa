import 'package:go_router/go_router.dart';

import '../../features/auth/views/auth_screen.dart';
import '../../features/auth/views/create_account.dart';
import '../../features/auth/views/sign_in.dart';
import '../../features/auth/views/verify_email.dart';
import '../../features/onboarding/views/onboarding_screen.dart';

final appRouterConfig = GoRouter(
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
                    builder: (context, state) =>
                        const EmailVerificationScreen(),
                  )
                ]),
          ],
        ),
      ],
    ),
  ],
);
