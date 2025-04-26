// Reusable Modal Bottom Sheet widget
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class ReusableModalSheet extends StatelessWidget {
  final String title;
  final List<Widget> children;
  // final double heightFactor;
  final Widget? actionWidget;

  const ReusableModalSheet({
    super.key,
    required this.title,
    required this.children,
    // this.heightFactor,
    this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 1.5,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => context.pop(),
                  ),
                  Text(title, style: AppTypography.textMediumBold),
                  actionWidget != null ? actionWidget! : SizedBox(width: 10.w),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: children,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
