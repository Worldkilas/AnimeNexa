import 'package:anime_nexa/features/home/views/media_fullscreen.dart';
import 'package:anime_nexa/models/mediaitem.dart';
import 'package:anime_nexa/shared/utils.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:giphy_flutter_sdk/giphy_media_view.dart';
import 'package:go_router/go_router.dart';

class PostMedia extends StatelessWidget {
  final List<MediaItem> media;

  const PostMedia({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    Widget mediaTile(
      MediaItem mediaItem,
      int index,
    ) {
      return InkWell(
        onTap: () {
          context.push('/mediafullscreen', extra: (media, index));
        },
        child: Hero(
          tag: index,
          child: switch (mediaItem.type) {
            MediaType.image || MediaType.video => Container(
                height: double.infinity,
                width: double.infinity,
                margin: EdgeInsets.all(0.7),
                decoration: ShapeDecoration(
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 10,
                      cornerSmoothing: 0.8,
                    ),
                  ),
                  image: DecorationImage(
                      image: NetworkImage(mediaItem.type == MediaType.video
                          ? mediaItem.thumbnailPath!
                          : mediaItem.mediaPath!),
                      fit: BoxFit.cover),
                ),
              ),
            MediaType.gif => GiphyMediaView(mediaId: mediaItem.mediaPath)
          },
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: switch (media.length) {
        1 => mediaTile(media[0], 0),
        2 => Row(
            children: [
              Expanded(child: mediaTile(media[0], 0)),
              Expanded(child: mediaTile(media[1], 1)),
            ],
          ),
        3 => Row(
            children: [
              Expanded(child: mediaTile(media[0], 0)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.48,
                child: Column(
                  children: [
                    Expanded(child: mediaTile(media[1], 1)),
                    Expanded(child: mediaTile(media[2], 2)),
                  ],
                ),
              ),
            ],
          ),
        _ => GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.8,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  mediaTile(
                    media[index],
                    index,
                  ),
                  if (index == 3 && media.length > 4)
                    Container(
                      color: Colors.black.withOpacity(0.6),
                      alignment: Alignment.center,
                      child: Text(
                        '+${media.length - 4}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              );
            },
          )
      },
    );
  }
}
