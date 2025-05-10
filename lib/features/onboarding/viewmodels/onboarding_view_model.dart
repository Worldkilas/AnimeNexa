import 'package:anime_nexa/core/typedefs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

FutureVoid markOnboardingComplete() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('onboarding_complete', true);
}

final onboardingCompleteProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboarding_complete') ?? false;
});

final onboardingProvider = StateNotifierProvider<OnboardingViewModel, int>(
  (ref) => OnboardingViewModel(),
);

class OnboardingViewModel extends StateNotifier<int> {
  OnboardingViewModel() : super(0);

  void setPageIndex(int index) {
    state = index;
  }

  void nextPage(int length) {
    if (state < 2) {
      state++;
    }
  }

  void previousPage() {
    if (state > 0) {
      state--;
    }
  }

  void skipToLast(int length) {
    state = 2;
  }
}
