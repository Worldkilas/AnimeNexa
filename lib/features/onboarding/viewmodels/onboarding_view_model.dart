import 'package:flutter_riverpod/flutter_riverpod.dart';

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
