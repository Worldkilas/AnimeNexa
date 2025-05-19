import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/utils.dart';
import 'package:anime_nexa/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class CustomPopupMenu extends StatelessWidget {
  final void Function(String)? onItemSelected;

  const CustomPopupMenu({Key? key, this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (onItemSelected != null) {
          onItemSelected!(value);
        }
      },
      itemBuilder: (context) => [
        _buildMenuItem(context, 'Profile', 'profile'),
        _buildMenuItem(context, 'Wallet', 'wallet'),
        _buildMenuItem(context, 'Marketplace', 'market'),
        _buildMenuItem(context, 'Manga Library', 'manga'),
        _buildMenuItem(context, 'Settings', 'settings'),
        _buildMenuItem(context, 'Support', 'support'),
      ],
      icon: const Icon(Icons.menu),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(
      BuildContext context, String text, String icon) {
    return PopupMenuItem<String>(
      value: text,
      onTap: () {
        utilitySnackBar(context, "Coming soon");
      },
      child: SizedBox(
        width: 45.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: AppTypography.textMedium),
            SvgPicture.asset(iconPathGen(icon)),
          ],
        ),
      ),
    );
  }
}
