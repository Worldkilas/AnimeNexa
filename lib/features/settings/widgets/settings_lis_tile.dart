import 'package:flutter/material.dart';

import '../../../shared/constants/app_typography.dart';

class SettingsListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? iconColor;
  final bool isExpandable;
  final bool isExpanded;
  final Widget? expandedChild;

  const SettingsListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.titleColor,
    this.iconColor,
    this.expandedChild,
    this.isExpandable = false,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: iconColor ?? Colors.black,
          ),
          title: Text(
            title,
            style: AppTypography.textMedium,
          ),
          trailing: isExpandable
              ? Icon(isExpanded ? Icons.expand_less : Icons.expand_more)
              : Icon(
                  Icons.chevron_right,
                ),
          onTap: onTap,
        ),
        if (isExpandable && isExpanded && expandedChild != null)
          Container(
            // padding: const EdgeInsets.only(left: 60),
            child: expandedChild,
          ),
      ],
    );
  }
}
