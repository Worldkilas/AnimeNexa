import 'package:anime_nexa/features/discover/widgets/post_action_button.dart';
import 'package:anime_nexa/features/discover/widgets/post_images.dart';
import 'package:anime_nexa/shared/constants/app_theme.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClanPostCard extends StatefulWidget {
  List<String>? imagePath;
  String? clanName;
  String? posterName;
  String? posterUsername;
  String? text;
  bool? withinClan = false;

  ClanPostCard({
    super.key,
    this.imagePath,
    this.clanName,
    this.posterName,
    this.posterUsername,
    this.text,
    this.withinClan,
  });

  @override
  State<ClanPostCard> createState() => _ClanPostCardState();
}

class _ClanPostCardState extends State<ClanPostCard> {
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
                      if (!widget.withinClan!)
                        Row(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.clanName!,
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
                      Row(
                        spacing: 3,
                        children: [
                          Text(
                            widget.posterName!,
                            style: widget.withinClan!
                                ? AppTypography.textMediumBold.copyWith(
                                    color: Colors.black,
                                  )
                                : AppTypography.textXSmall.copyWith(
                                    color: const Color(0xff888888),
                                  ),
                          ),
                          Text(
                            '@${widget.posterUsername!}',
                            style: widget.withinClan!
                                ? AppTypography.textMedium.copyWith(
                                    color: const Color(0xff888888),
                                  )
                                : AppTypography.textXSmall.copyWith(
                                    color: const Color(0xff888888),
                                  ),
                          ),
                          Text(
                            '•',
                            style: widget.withinClan!
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
                      ),
                    ],
                  ),
                ],
              ),
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
          if (widget.imagePath!.isEmpty)
            Text(
              widget.text!,
              style: AppTypography.textMedium,
            ),
          const SizedBox(height: 3),
          if (widget.imagePath!.isNotEmpty)
            PostImages(images: widget.imagePath!),
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
          if (widget.imagePath!.isNotEmpty)
            Text(
              widget.text!,
              style: AppTypography.textMedium,
            ),
        ],
      ),
    );
  }
}
