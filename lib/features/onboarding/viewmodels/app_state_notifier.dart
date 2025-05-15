import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateNotifier extends ChangeNotifier {
  bool _onboardingComplete = false;
  bool get onboardingComplete => _onboardingComplete;

  AppStateNotifier() {
    _loadOnboardingState();
  }

  Future<void> _loadOnboardingState() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    notifyListeners();
  }

  Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    _onboardingComplete = true;
    notifyListeners();
  }

  // Optional: Reset onboarding state if needed.
  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', false);
    _onboardingComplete = false;
    notifyListeners();
  }
}

final appStateNotifierProvider =
    ChangeNotifierProvider<AppStateNotifier>((ref) => AppStateNotifier());
