import 'package:anime_nexa/features/clans/widgets/post_action_button.dart';
import 'package:anime_nexa/features/clans/widgets/post_media.dart';
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
  String? clan;

  PostCard({super.key, required this.post, this.clan});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!widget.post.isDraft!)
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
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 0,
                    children: [
                      if (widget.clan != null)
                        Row(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.clan!,
                              style: AppTypography.textMediumBold,
                            ),
                            Text(
                              '•',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                'Join',
                                style: AppTypography.textSmall.copyWith(
                                  color: appTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      if (!widget.post.isDraft!)
                        ref.watch(authStateChangesProvider).when(
                            data: (data) {
                              return Row(
                                spacing: 3,
                                children: [
                                  Text(
                                    data.displayName,
                                    style: widget.clan != null
                                        ? AppTypography.textMediumBold.copyWith(
                                            color: Colors.black,
                                          )
                                        : AppTypography.textXSmall.copyWith(
                                            color: const Color(0xff888888),
                                          ),
                                  ),
                                  Text(
                                    '@${data.username}',
                                    style: widget.clan != null
                                        ? AppTypography.textMedium.copyWith(
                                            color: const Color(0xff888888),
                                          )
                                        : AppTypography.textXSmall.copyWith(
                                            color: const Color(0xff888888),
                                          ),
                                  ),
                                  Text(
                                    '•',
                                    style: widget.clan != null
                                        ? AppTypography.textMedium.copyWith(
                                            color: const Color(0xff888888),
                                          )
                                        : AppTypography.textXSmall.copyWith(
                                            color: const Color(0xff888888),
                                          ),
                                  ),
                                  Text(
                                    '2h',
                                    style: AppTypography.textXSmall.copyWith(
                                      color: const Color(0xff888888),
                                    ),
                                  ),
                                ],
                              );
                            },
                            error: (_, __) => SizedBox(),
                            loading: () => SizedBox())
                    ],
                  ),
                ],
              ),
              if (!widget.post.isDraft!)
                Align(
                  alignment: Alignment.topCenter,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(
                      Icons.more_horiz,
                      size: 20,
                    ),
                    onPressed: () {},
                  ),
                ),
            ],
          ),
          if (widget.post.media!.isEmpty)
            Text(
              widget.post.text!,
              style: AppTypography.textMedium,
            ),
          const SizedBox(height: 3),
          if (widget.post.media!.isNotEmpty)
            PostMedia(media: widget.post.media!),
          if (!widget.post.isDraft!)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 16,
                  children: [
                    PostActionButton(
                      imagePath: iconPathGen('arrow_enabled'),
                      count: 4,
                    ),
                    PostActionButton(
                      imagePath: iconPathGen('arrow'),
                      count: 4,
                    ),
                    PostActionButton(
                      imagePath: iconPathGen('comment'),
                      count: 4,
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
            Text(
              widget.post.text!,
              style: AppTypography.textMedium,
            ),
        ],
      ),
    );
  }
}
