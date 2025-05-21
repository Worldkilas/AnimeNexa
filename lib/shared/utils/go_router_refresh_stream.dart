import 'dart:async';

import 'package:flutter/material.dart';

/// Wraps FirebaseAuth.instance.authStateChanges() as a Listenable for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _authSub;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _authSub = stream.asBroadcastStream().listen(
          // On auth change, notify GoRouter to re-run redirects
          (dynamic event) => notifyListeners(),
        );
  }
  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }
}
