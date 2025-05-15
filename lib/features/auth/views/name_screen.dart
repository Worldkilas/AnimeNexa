import 'package:anime_nexa/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../user_profile/view_models/profile_view_models.dart/edit_profile_vm.dart';

class NameScreen extends ConsumerStatefulWidget {
  const NameScreen({super.key});

  @override
  ConsumerState<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends ConsumerState<NameScreen> {
  final _fullNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(editProfileVmProvider.notifier).submitProfile(
            fullName: _fullNameController.text,
            username: _userNameController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usernameAsync = ref.watch(editProfileVmProvider);
    final theme = Theme.of(context);
    ref.listen<AsyncValue<void>>(
      editProfileVmProvider,
      (_, next) {
        next.whenOrNull(
          error: (e, _) => utilitySnackBar(
            context,
            e.toString(),
          ),
          data: (_) {
            context.go('/home');
          },
        );
      },
    );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Form(
            key: _formKey,
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
                  style:
                      theme.textTheme.bodyMedium!.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 7.h),
                CustomTextField(
                  labelText: 'Full Name',
                  keyboardType: TextInputType.name,
                  controller: _fullNameController,
                  height: 6.h,
                ),
                SizedBox(height: 3.h),
                CustomTextField(
                  labelText: 'Username',
                  keyboardType: TextInputType.name,
                  controller: _userNameController,
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
                      onPressed: submit,
                      isLoading: usernameAsync.isLoading,
                      width: 140,
                    )
                  ],
                ),
                SizedBox(height: 4.h)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
