import 'package:anime_nexa/features/auth/view_model/auth_view_model.dart';
import 'package:anime_nexa/shared/constants/app_theme.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/utils/utils.dart';
import 'package:anime_nexa/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../models/auth_state.dart';
import '../view_models/profile_view_models.dart/edit_profile_vm.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  bool _controllersInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_controllersInitialized) {
      final authState = ref.watch(authViewModelProvider);
      if (authState is Authenticated && authState.user != null) {
        final user = authState.user!;
        if (_nameController.text.isEmpty) {
          _nameController.text = user.displayName;
        }
        if (_usernameController.text.isEmpty) {
          _usernameController.text = user.username;
        }
        if (_bioController.text.isEmpty) {
          _bioController.text = user.bio ?? "";
        }
      }
      _controllersInitialized = true;
    }
  }

  Widget customTextField(TextEditingController ctrl, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Text(
            label,
            style: AppTypography.textMediumBold,
          ),
          TextField(
            controller: ctrl,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            maxLines: label == "Bio" ? 3 : 1,
            style: AppTypography.textMedium,
            textCapitalization: switch (label) {
              "Name" || "Location" => TextCapitalization.words,
              "Bio" => TextCapitalization.sentences,
              _ => TextCapitalization.none,
            },
            // onTap: label == "Birthday"
            //     ? () {
            //         showDatePicker(
            //           context: context,
            //           initialDate: DateTime.now(),
            //           firstDate: DateTime(1900),
            //           lastDate: DateTime.now(),
            //           builder: (context, child) {
            //             return Theme(
            //               data: ThemeData.light().copyWith(
            //                 primaryColor: appTheme.primaryColor,
            //                 colorScheme: appTheme.colorScheme,
            //                 buttonTheme: ButtonThemeData(
            //                   textTheme: ButtonTextTheme.primary,
            //                 ),
            //               ),
            //               child: child!,
            //             );
            //           },
            //     //     ).then(
            //     //       (value) {
            //     //         if (value != null) {
            //     //           _birthdayController.text =
            //     //               DateFormat('dd/MM/yyy').format(value);
            //     //         }
            //     //       },
            //     //     );
            //     //   }
            //     // : null,
            decoration: InputDecoration(
              isDense: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              contentPadding: EdgeInsets.only(left: 0),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: appTheme.primaryColor),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateProfile() {
    ref.read(editProfileVmProvider.notifier).submitProfile(
          fullName: _nameController.text,
          username: _usernameController.text,
          bio: _bioController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(editProfileVmProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) => utilitySnackBar(
          context,
          e.toString(),
        ),
        data: (_) {
          utilitySnackBar(
            context,
            'Updated profile successfully',
          );
          context.replace('/profile');
        },
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: AppTypography.textMediumBold.copyWith(color: Colors.black),
        ),
        leading: TextButton(
          onPressed: () {
            context.replace('/profile');
          },
          child: Text(
            "Cancel",
            style: AppTypography.textMedium.copyWith(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leadingWidth: 100,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(height: 157),
                ClipRect(
                  child: SizedBox(
                    width: double.infinity,
                    height: 125,
                    child: Image.asset(
                      'lib/assets/images/post.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 24,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'lib/assets/images/tengen-uzui-neon-1280x1280-19137.png',
                        ),
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.srcATop,
                        ),
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset('lib/assets/images/camera.png'),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 40, top: 24, left: 24, right: 24),
              child: Column(
                children: [
                  customTextField(_nameController, "Name"),
                  customTextField(_usernameController, "Username"),
                  // customTextField(_locationController, "Location"),
                  // customTextField(_emailController, "Email"),
                  // customTextField(_birthdayController, "Birthday"),
                  customTextField(_bioController, "Bio"),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomButton(
                height: 48,
                text: "Done",
                onPressed: _updateProfile,
                isLoading: ref.watch(editProfileVmProvider).isLoading,
              ),
            )
          ],
        ),
      ),
    );
  }
}
