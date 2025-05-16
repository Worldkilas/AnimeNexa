// lib/core/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextStyle? labelStyle;
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool showVisibilityToggle;
  final VoidCallback? onVisibilityToggle;
  final TextInputType? keyboardType;
  final bool isError;
  final double? width;
  final double? height;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.labelStyle,
    this.height,
    this.width,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.controller,
    this.errorText,
    this.onChanged,
    this.showVisibilityToggle = false,
    this.onVisibilityToggle,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 100.w,
      height: height ?? 7.h,
      child: TextFormField(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        keyboardType: keyboardType ?? TextInputType.text,
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: labelStyle ?? Theme.of(context).textTheme.bodyMedium,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isError ? AppColors.error : Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isError ? AppColors.error : Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: isError ? AppColors.error : Colors.purple,
            ),
          ),
          errorText: errorText,
          errorStyle: const TextStyle(color: AppColors.error),
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          suffixIcon: showVisibilityToggle
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: onVisibilityToggle,
                )
              : null,
        ),
      ),
    );
  }
}
