import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:sizer/sizer.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: OnBoardingSlider(
        headerBackgroundColor: Colors.transparent,
        background: [
          getOnboardingImage('lib/assets/images/onboarding_1.png'),
          getOnboardingImage('lib/assets/images/onboarding_2.png'),
          getOnboardingImage('lib/assets/images/onboarding_3.png'),
        ],
        totalPage: 3,
        controllerColor: theme.primaryColor,
        speed: 1,
        pageBodies: [
          Container(
            alignment: Alignment.center,
            child: Text.rich(
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
                // height: 1.5,
                // fontFamily: 'Epilogue',
              ),
              textAlign: TextAlign.center,
              TextSpan(children: [
                TextSpan(
                  text: 'Welcome to ',
                ),
                TextSpan(
                  text: 'Animenexa',
                  style: theme.textTheme.headlineLarge!.copyWith(
                      // color: theme.primaryColor,
                      ),
                )
              ]),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: 'Welcome to Animenexa'),
              ]),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: 'Welcome to Animenexa'),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

Image getOnboardingImage(String imagePath) {
  return Image.asset(
    imagePath,
    fit: BoxFit.cover,
    height: 100.h,
    width: 100.w,
    filterQuality: FilterQuality.high,
    alignment: Alignment.center,
  );
}
