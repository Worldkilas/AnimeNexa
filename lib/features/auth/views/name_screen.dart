import 'package:anime_nexa/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/widgets/custom_button.dart';

class NameScreen extends StatelessWidget {
  const NameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset('lib/assets/icons/Logo.svg'),
              SizedBox(height: 2.h),
              Text(
                'Your Name',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'For a personalized app experience, please enter your first and last name.',
                textAlign: TextAlign.start,
                style: theme.textTheme.bodyMedium!.copyWith(color: Colors.grey),
              ),
              SizedBox(height: 7.h),
              CustomTextField(
                labelText: 'Full Name',
                keyboardType: TextInputType.name,
                height: 6.h,
              ),
              SizedBox(height: 3.h),
              CustomTextField(
                labelText: 'Username',
                keyboardType: TextInputType.name,
                height: 6.h,
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    text: 'Back',
                    backgroundColor: Colors.white,
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                      width: 1.5,
                    ),
                    textColor: Colors.black,
                    onPressed: () {
                      context.pop();
                    },
                    width: 140,
                  ),
                  CustomButton(
                    text: 'Next',
                    onPressed: () {
                      context.go('/auth/signIn/setNameAndUsername/genre');
                    },
                    width: 140,
                  )
                ],
              ),
              SizedBox(height: 4.h)
            ],
          ),
        ),
      ),
    );
  }
}
