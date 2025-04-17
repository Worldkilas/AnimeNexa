import 'package:anime_nexa/shared/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/widgets/custom_text_field.dart';
import '../widgets/password_requirement.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  late GestureRecognizer _gestureRecognizer;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;

  void togglePasswordVisibility() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  @override
  void initState() {
    super.initState();
    _gestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        // Navigate to the sign-in screen
        context.go('/auth/signIn');
      };
  }

  @override
  void dispose() {
    _gestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                'Create Your Account',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(fontSize: 34),
              ),
              SizedBox(height: 1.h),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: 'Already have an account? ',
                    ),
                    TextSpan(
                      text: ' Sign In',
                      recognizer: _gestureRecognizer,
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ],
                ),
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
              SizedBox(height: 1.5.h),
              SizedBox(height: 1.7),
              PasswordRequirementItem(
                isMet: _passwordController.text.length >= 8,
                text: 'At least 8 characters',
              ),
              PasswordRequirementItem(
                text: 'Must contain a special character',
                isMet: true,
              ),
              SizedBox(height: 3.3.h),
              CustomButton(
                text: 'Create an account',
                onPressed: () {
                  //TODO: Implement create account functionality
                },
              ),
              SizedBox(height: 2.h),
              //sign with socials divider

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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getSocialLoginButton(
                    path: 'lib/assets/icons/twitter_icon.png',
                    onTap: () {},
                  ),
                  getSocialLoginButton(
                    path: 'lib/assets/icons/google_icon.png',
                    onTap: () {},
                  ),
                  getSocialLoginButton(
                    path: 'lib/assets/icons/apple_icon.png',
                    onTap: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget getSocialLoginButton({
  required String path,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: 24,
      height: 24,
      child: Image.asset(path),
    ),
  );
}
