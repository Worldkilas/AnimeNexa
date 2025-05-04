import 'package:anime_nexa/features/auth/view_model/auth_view_model.dart';
import 'package:anime_nexa/models/anime_nexa_user.dart';
import 'package:anime_nexa/shared/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../shared/utils/live_password_checker.dart';
import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../widgets/password_requirement.dart';

//store the password in a provider to check confirm password
final originalPasswordProvider = StateProvider<String>((ref) => '');

class CreateAccount extends ConsumerStatefulWidget {
  const CreateAccount({super.key});

  @override
  ConsumerState<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends ConsumerState<CreateAccount> {
  late GestureRecognizer _gestureRecognizer;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final passwordValidation = ref.watch(passwordValidationProvider);
    final authViewModel = ref.read(authViewModelProvider.notifier);

    ref.listen<AsyncValue<AnimeNexaUser?>>(
      authViewModelProvider,
      (_, next) {
        next.whenOrNull(
          error: (e, _) => utilitySnackBar(
            context,
            e.toString(),
          ),
          data: (user) {
            if (user != null) context.go('/auth/setNameAndUsername');
          },
        );
      },
    );
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
                controller: _emailController,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  ).hasMatch(val)) {
                    return 'Please enter a valid email';
                  }

                  return null;
                },
                height: 6.h,
              ),
              SizedBox(height: 1.5.h),
              CustomTextField(
                labelText: 'Password',
                height: 6.h,
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordController,
                obscureText: isObscure,
                onChanged: (val) {
                  ref.read(passwordValidationProvider.notifier).state =
                      PasswordValidation.fromPassword(val);
                  //store the password in a provider to check confirm password
                  ref.read(originalPasswordProvider.notifier).state = val;
                },
                showVisibilityToggle: true,
                onVisibilityToggle: togglePasswordVisibility,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (!passwordValidation.isPasswordValid) {
                    return 'Password must be at least 8 characters long and contain a special character';
                  }
                  return null;
                },
              ),
              SizedBox(height: 1.5.h),
              CustomTextField(
                labelText: 'Confirm password',
                controller: _confirmPasswordController,
                height: 6.h,
                keyboardType: TextInputType.visiblePassword,
                obscureText: isObscure,
                onChanged: (val) {},
                showVisibilityToggle: true,
                onVisibilityToggle: togglePasswordVisibility,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (val != ref.read(originalPasswordProvider)) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 1.5.h),

              //length checker
              PasswordRequirementItem(
                isMet: passwordValidation.hasMinLength,
                text: 'At least 8 characters',
              ),
              //character checker
              PasswordRequirementItem(
                text: 'Must contain a special character',
                isMet: passwordValidation.hasSpecialChar,
              ),
              SizedBox(height: 3.3.h),
              CustomButton(
                text: 'Create an account',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    authViewModel.signUpWithEmailandPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );
                  }
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
            ],
          ),
        ),
      ),
    );
  }
}
