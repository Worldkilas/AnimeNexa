import 'package:anime_nexa/models/auth_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/constants/app_colors.dart';
import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../view_model/auth_view_model.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late GestureRecognizer _gestureRecognizer;
  bool isObscure = false;
  BuildContext? _progressIndicatorContext;

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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _gestureRecognizer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen<AuthState>(
      authViewModelProvider,
      (_, authState) {
        if (authState is Authenticating) {
          showDialog(
            context: context,
            barrierDismissible: false,
            useRootNavigator: true,
            builder: (context) {
              _progressIndicatorContext = context;
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
          return;
        }
        // close circular progress indicator after rebuild to guarantee that the
        // context is still valid
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (_progressIndicatorContext != null &&
              _progressIndicatorContext!.mounted) {
            Navigator.of(_progressIndicatorContext!, rootNavigator: true).pop();
            _progressIndicatorContext = null;
          }
        });
        if (authState is Authenticated) {
          if (authState.user!.displayName.isEmpty &&
              authState.user!.username.isEmpty) {
            context.go('/auth/setUsername');
          } else {
            context.go('/home');
          }
        }
        if (authState is Unauthenticated) {
          utilitySnackBar(context, authState.error!);
        }
      },
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
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
                  controller: _emailController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(val)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  height: 6.h,
                ),
                SizedBox(height: 1.5.h),
                CustomTextField(
                  labelText: 'Password',
                  controller: _passwordController,
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
                    if (_formKey.currentState!.validate()) {
                      ref
                          .read(authViewModelProvider.notifier)
                          .signInWithEmailandPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                    }
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
                CustomButton(
                  text: 'Continue with Google',
                  leadingIcon: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Image.asset(
                      'lib/assets/icons/google_icon.png',
                      height: 24,
                      width: 24,
                    ),
                  ),
                  height: 6.h,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  onPressed: () {
                    ref.read(authViewModelProvider.notifier).signInWithGoogle();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
