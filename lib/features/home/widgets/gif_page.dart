import 'package:flutter/material.dart';
import 'package:anime_nexa/models/mediaitem.dart';
import 'package:giphy_flutter_sdk/giphy_media_view.dart';

class GifPage extends StatelessWidget {
  final MediaItem media;
  const GifPage({required this.media, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: GiphyMediaView(mediaId: media.mediaPath));
  }
}
