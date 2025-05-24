import 'package:anime_nexa/models/mediaitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giphy_flutter_sdk/giphy_media_view.dart';
import 'package:video_player/video_player.dart';
import 'package:anime_nexa/shared/utils/utils.dart';
import 'package:anime_nexa/features/home/widgets/image_page.dart';
import 'package:anime_nexa/features/home/widgets/gif_page.dart';
import 'package:anime_nexa/features/home/widgets/video_page.dart';

class MediaFullScreen extends ConsumerStatefulWidget {
  final List<MediaItem> mediaItems;
  final int currentItem;
  const MediaFullScreen({
    required this.mediaItems,
    required this.currentItem,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MediaFullScreenState();
}

class _MediaFullScreenState extends ConsumerState<MediaFullScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentItem;
    _pageController = PageController(initialPage: widget.currentItem);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.mediaItems.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final media = widget.mediaItems[index];
          return switch (media.type) {
            MediaType.image => ImagePage(media: media),
            MediaType.video => VideoPage(media: media),
            MediaType.gif => GifPage(media: media),
          };
        },
      ),
    );
  }
}
