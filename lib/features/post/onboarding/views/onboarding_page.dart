import 'package:anime_nexa/features/post/onboarding/models/onboarding_item.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, required this.item});
  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // image to fill screen
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(item.imagePath),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),

          //content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                Text(
                  item.subtitle,
                  style:
                      theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15.h),
              ],
            ),
          )
        ],
      ),
    );
  }
}
