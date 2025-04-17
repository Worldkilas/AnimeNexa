import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/constants/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../widgets/password_requirement.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  late GestureRecognizer _gestureRecognizer;
  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    _gestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        // Navigate to the create account screen
        context.go('/auth/createAcct');
      };
  }

  void togglePasswordVisibility() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'lib/assets/icons/Logo.svg',
              ),
              SizedBox(height: 2.5.h),
              Text(
                'Welcome back!',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(fontSize: 34),
              ),
              SizedBox(height: 1.h),
              Text(
                'Enter your details to continue exploring AnimeNexa',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),

              SizedBox(height: 3.h),
              CustomTextField(
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                height: 6.h,
              ),
              SizedBox(height: 1.5.h),
              CustomTextField(
                labelText: 'Password',
                height: 6.h,
                keyboardType: TextInputType.visiblePassword,
                obscureText: isObscure,
                showVisibilityToggle: true,
                onVisibilityToggle: togglePasswordVisibility,
              ),

              SizedBox(height: 2.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (value) {},
                      ),
                      Text(
                        'Remember me',
                        style: theme.textTheme.bodyMedium,
                      )
                    ],
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: AppColors.primary,
                        ),
                      ))
                ],
              ),
              SizedBox(height: 2.h),
              CustomButton(
                text: 'Sign in',
                height: 6.h,
                onPressed: () {
                  //TODO: Implement sign in functionality
                  context.go('/auth/signIn/verifyEmail');
                },
              ),
              SizedBox(height: 2.h),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: theme.dividerColor,
                      thickness: 1,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'or sign up with',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Divider(
                      color: theme.dividerColor,
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     getSocialLoginButton(
              //       path: 'lib/assets/icons/twitter_icon.png',
              //       onTap: () {},
              //     ),
              //     getSocialLoginButton(
              //       path: 'lib/assets/icons/google_icon.png',
              //       onTap: () {},
              //     ),
              //     getSocialLoginButton(
              //       path: 'lib/assets/icons/apple_icon.png',
              //       onTap: () {},
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
