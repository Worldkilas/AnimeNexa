import 'package:anime_nexa/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _pinController = TextEditingController();
  String _enteredCode = "";

  void _verifyCode() {
    // TODO: Call api
  }

  void _resendCode() {
    // TODO: Trigger resend logic
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Text(
                "Verify Your\n Email",
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Check your email and enter the\n4 digit code sent",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 12.5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.scale,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 60,
                    fieldWidth: 60,
                    activeColor: Colors.purple,
                    selectedColor: Colors.deepPurple,
                    inactiveColor: Colors.grey.shade400,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  onChanged: (value) {
                    setState(
                      () {
                        _enteredCode = value;
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),
              CustomButton(
                text: 'Verify code',
                onPressed: () {
                  //TODO; VERIFY CODE
                  context.go('/auth/signIn/setNameAndUsername');
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Didn't receive code? "),
                  GestureDetector(
                    onTap: _resendCode,
                    child: Text(
                      "Resend code",
                      style: TextStyle(color: theme.primaryColor),
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
