import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../onboarding/models/onboarding_item.dart';

final onboardingItemsProvider = Provider<List<OnboardingItem>>(
  (ref) {
    return [
      OnboardingItem(
        title: 'Welcome to ',
        subtitle: 'Unite with Fans. Explore Content. Support Creators.',
        imagePath: 'lib/assets/images/onboarding_1.png',
      ),
      OnboardingItem(
        title: 'Community Engagement',
        subtitle:
            'Join a vibrant community, create clans, and engage with fans who share your love for anime things.',
        imagePath: 'lib/assets/images/onboarding_2.png',
      ),
      OnboardingItem(
        title: 'Empower Creativity',
        subtitle:
            'Support your favorite creators. Let’s build the future of anime, together.',
        imagePath: 'lib/assets/images/onboarding_3.png',
      ),
    ];
  },
);
