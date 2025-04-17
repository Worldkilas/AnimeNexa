import 'package:anime_nexa/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset('lib/assets/Frame 551.png'),
          ),
          SizedBox(height: 3.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                CustomButton(
                  text: 'Sign In',
                  padding: EdgeInsets.all(16),
                  borderRadius: 10,
                  height: 60,
                  onPressed: () {
                    //TODO: implement sign in
                    context.go('/auth/signIn');
                  },
                ),
                SizedBox(height: 2.h),
                CustomButton(
                  text: 'Create Account',
                  borderRadius: 10,
                  height: 60,
                  backgroundColor: Colors.white,
                  textColor: Theme.of(context).colorScheme.primary,
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                  onPressed: () {
                    //TODO: implement create account logic
                    context.go('/auth/createAcct');
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
