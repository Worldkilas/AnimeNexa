import 'package:flutter/material.dart';
import 'package:anime_nexa/models/mediaitem.dart';

class ImagePage extends StatelessWidget {
  final MediaItem media;
  const ImagePage({required this.media, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            filterQuality: FilterQuality.high,
            image: NetworkImage(media.mediaPath!),
          ),
        ),
      ),
    );
  }
}
