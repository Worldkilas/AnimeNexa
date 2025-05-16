import 'package:anime_nexa/features/clans/widgets/post_action_button.dart';
import 'package:anime_nexa/features/home/widgets/post_media.dart';
import 'package:anime_nexa/features/post/viewmodel/post_vm.dart';
import 'package:anime_nexa/models/post.dart';
import 'package:anime_nexa/providers/global_providers.dart';
import 'package:anime_nexa/shared/constants/app_theme.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostCard extends ConsumerStatefulWidget {
  final Post post;

  PostCard({super.key, required this.post});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ref.watch(fetchUserDataProvider(widget.post.uid!)).when(
                    data: (user) {
                      return Row(
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
                          Text(
                            user.username,
                            style: AppTypography.textMediumBold.copyWith(
                              color: Colors.black,
                            ),
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
              ]),
          const SizedBox(height: 5),
          if (widget.post.media!.isEmpty)
            Text(
              widget.post.text!,
              style: AppTypography.textMedium,
            ),
          const SizedBox(height: 5),
          if (widget.post.media!.isNotEmpty)
            PostMedia(media: widget.post.media!),
          if (widget.post.media!.isNotEmpty) SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 16,
                children: [
                  GestureDetector(
                      onTap: () {
                        ref.read(postNotifierProvider.notifier).likePost(
                            widget.post,
                            ref.read(firebaseAuthProvider).currentUser!.uid);
                      },
                      child: Icon(
                        widget.post.likes!.contains(
                                ref.read(firebaseAuthProvider).currentUser!.uid)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: widget.post.likes!.contains(
                                ref.read(firebaseAuthProvider).currentUser!.uid)
                            ? Colors.red
                            : Colors.black,
                      )),
                  PostActionButton(
                    imagePath: iconPathGen('comment'),
                    count: widget.post.comments!.length,
                  )
                ],
              ),
              Row(
                spacing: 16,
                children: [
                  SvgPicture.asset(iconPathGen('Save')),
                  SvgPicture.asset(iconPathGen('Gift')),
                  SvgPicture.asset(iconPathGen('Share')),
                ],
              ),
            ],
          ),
          if (widget.post.media!.isNotEmpty)
            Column(
              children: [
                SizedBox(height: 10),
                Text(
                  widget.post.text!,
                  style: AppTypography.textMedium,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
