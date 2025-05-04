import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/constants/app_colors.dart';

class PasswordRequirementItem extends ConsumerWidget {
  final String text;
  final bool isMet;

  const PasswordRequirementItem({
    super.key,
    required this.text,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isMet ? AppColors.success : Colors.grey.shade400,
          ),
          child: Icon(
            Icons.check,
            size: 14,
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isMet ? AppColors.success : Colors.grey.shade400,
            ),
          ),
        ),
      ],
    );
  }
}
