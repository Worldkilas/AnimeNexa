import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/utils.dart';

class PrivacyOptionsBottomSheet extends StatefulWidget {
  final String selectedPrivacy;
  final Function(String) onPrivacyChanged;

  const PrivacyOptionsBottomSheet({
    super.key,
    required this.selectedPrivacy,
    required this.onPrivacyChanged,
  });

  @override
  State<PrivacyOptionsBottomSheet> createState() =>
      _PrivacyOptionsBottomSheetState();
}

class _PrivacyOptionsBottomSheetState extends State<PrivacyOptionsBottomSheet> {
  late String _selectedPrivacy;

  @override
  void initState() {
    super.initState();
    _selectedPrivacy = widget.selectedPrivacy;
  }

  Widget _buildPrivacyOption(
    BuildContext context,
    StateSetter setModalState,
    String title,
    String icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          setModalState(() {
            _selectedPrivacy = title;
          });
          widget.onPrivacyChanged(title);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xffECECEC),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    iconPathGen(icon),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppTypography.textMediumBold.copyWith(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Radio<String>(
              value: title,
              groupValue: _selectedPrivacy,
              onChanged: (String? value) {
                setModalState(() {
                  _selectedPrivacy = value!;
                });
                widget.onPrivacyChanged(value!);
              },
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.close, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            'Privacy Options - Who can see your posts?',
            style: AppTypography.textMediumBold.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildPrivacyOption(
            context,
            setState,
            'Public',
            'public',
          ),
          _buildPrivacyOption(
            context,
            setState,
            'Followers Only',
            'followers',
          ),
          _buildPrivacyOption(
            context,
            setState,
            'Clan Members Only',
            'clan',
          ),
          _buildPrivacyOption(
            context,
            setState,
            'Friends Only',
            'friends',
          ),
          _buildPrivacyOption(
            context,
            setState,
            'Private (Only Me)',
            'private',
          ),
          const SizedBox(height: 16),
          const Text(
            'Comment Control',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}