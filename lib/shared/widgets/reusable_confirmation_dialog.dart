import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'custom_button.dart';

//Reusable Confirmation Dialog widget
class ReusableConfirmationDialog extends StatelessWidget {
  final Widget? headerIcon;
  final String title;
  final String description;
  final String confirmButtonText;
  // final Color confirmButtonColor;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ReusableConfirmationDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmButtonText,
    required this.onConfirm,
    // this.confirmButtonColor = Colors.purple, // Matches the purple button in the image
    this.onCancel,
    this.headerIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    context.pop();
                    onCancel?.call();
                  },
                ),
              ],
            ),
            headerIcon != null ? headerIcon! : SizedBox.shrink(),
            Text(
              title,
              style: AppTypography.displaySmallBold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: confirmButtonText,
              onPressed: () {
                context.pop();
                onConfirm();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
