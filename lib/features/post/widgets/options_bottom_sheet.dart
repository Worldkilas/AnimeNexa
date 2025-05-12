import 'package:anime_nexa/features/post/views/create_post.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class OptionsBottomSheet extends ConsumerWidget {
  final Future<void> Function() onDraftSelected;
  final Future<void> Function() onDeleteSelected;
  const OptionsBottomSheet({
    super.key,
    required this.onDraftSelected,
    required this.onDeleteSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () async {
              await onDraftSelected();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Save as Draft',
                    style: AppTypography.textMedium.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  SvgPicture.asset(iconPathGen('cloud')),
                ],
              ),
            ),
          ),
          // Delete Option
          InkWell(
            onTap: () async {
              Navigator.pop(context);
              await onDeleteSelected();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delete',
                    style: AppTypography.textMedium.copyWith(
                      color: Color(0xffD42E2E),
                    ),
                  ),
                  SvgPicture.asset(iconPathGen('delete')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Cancel Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
