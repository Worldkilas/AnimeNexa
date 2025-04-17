import 'package:anime_nexa/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';

class XPProgressBar extends StatelessWidget {
  final int currentXP;
  final int maxXP;

  const XPProgressBar(
      {super.key, required this.currentXP, required this.maxXP});

  @override
  Widget build(BuildContext context) {
    double progress = currentXP / maxXP;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: AppColors.primary,
          ),
          SizedBox(height: 4),
          Text("$currentXP/$maxXP XP", style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
