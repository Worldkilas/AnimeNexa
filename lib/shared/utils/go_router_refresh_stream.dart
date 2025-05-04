import 'dart:async';

import 'package:flutter/material.dart';

/// Wraps FirebaseAuth.instance.authStateChanges() as a Listenable for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _sub;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.asBroadcastStream().listen(
          // On auth change, notify GoRouter to re-run redirects
          (dynamic event) => notifyListeners(),
        );
  }
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
