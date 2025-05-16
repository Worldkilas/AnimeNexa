import 'package:anime_nexa/models/comment.dart';
import 'package:anime_nexa/providers/global_providers.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentCard extends ConsumerWidget {
  final Comment comment;
  const CommentCard({required this.comment, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ref.watch(fetchUserDataProvider(comment.userID!)).when(
            data: (user) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(imagePathGen('posteravatar')),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: AppTypography.textMediumBold.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        comment.text!,
                      )
                    ],
                  ),
                ],
              );
            },
            error: (e, __) => SizedBox(
                  child: Text(
                    e.toString(),
                    style: TextStyle(fontSize: 8),
                  ),
                ),
            loading: () => SizedBox())
      ],
    );
  }
}
