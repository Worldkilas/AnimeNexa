import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../shared/widgets/custom_button.dart';
import '../../providers/onboarding_provider.dart';
import '../viewmodels/onboarding_view_model.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Initialize the PageController with the initial page from the ViewModel
    final initialPage = ref.read(onboardingProvider);
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    // Dispose of the PageController to prevent memory leaks
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentPage = ref.watch(onboardingProvider);
    final onboardingItems = ref.watch(onboardingItemsProvider);
    final onbaordingViewModel = ref.read(onboardingProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          // PageView for onboarding pages
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingItems.length,
            onPageChanged: (index) {
              onbaordingViewModel
                  .setPageIndex(index); // Update the ViewModel when swiping
            },
            itemBuilder: (context, index) {
              return OnboardingPage(item: onboardingItems[index]);
            },
          ),

          // Smooth Page Indicator
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  // Page indicator
                  SmoothPageIndicator(
                    onDotClicked: (index) {
                      onbaordingViewModel.setPageIndex(index);
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                    controller: _pageController,
                    count: onboardingItems.length,
                    effect: ExpandingDotsEffect(
                      expansionFactor: 3.25,
                      activeDotColor: Colors.white,
                      dotColor: Colors.grey,
                      spacing: 12,
                      radius: 40,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomButton(
                      text: (currentPage == onboardingItems.length - 1)
                          ? 'Get Started'
                          : 'Next',
                      onPressed: () async {
                        if (currentPage == onboardingItems.length - 1) {
                          // Mark onboarding as complete via shared preference
                          await markOnboardingComplete();
                          // Navigate to the login screen
                          context.go('/auth');
                        } else {
                          // Otherwise, go to the next page
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),

          // Skip button
          Positioned(
            top: 5.h,
            right: 4.w,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                onbaordingViewModel.skipToLast(onboardingItems.length);
                _pageController.jumpToPage(onboardingItems.length - 1);
              },
              child: Text(
                'Skip',
                style:
                    TextStyle(color: theme.colorScheme.primary, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
