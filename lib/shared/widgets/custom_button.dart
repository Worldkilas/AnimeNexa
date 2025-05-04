import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final BorderSide? borderSide;
  final double? elevation;
  final bool isLoading;
  final Widget? leadingIcon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.padding,
    this.borderSide,
    this.elevation,
    this.isLoading = false,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 7.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ??
              theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}) ??
              theme.primaryColor,
          elevation: elevation,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            side: borderSide ?? BorderSide.none,
          ),
        ).merge(theme.elevatedButtonTheme.style),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leadingIcon ?? const SizedBox.shrink(),
            isLoading
                ? CircularProgressIndicator()
                : Text(
                    text,
                    style: textStyle ??
                        theme.textTheme.labelLarge?.copyWith(
                          color: textColor ?? Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
          ],
        ),
      ),
    );
  }
}
