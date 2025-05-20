import 'package:anime_nexa/models/mediaitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giphy_flutter_sdk/giphy_media_view.dart';
import 'package:video_player/video_player.dart';

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
  VideoPlayerController? _videoController;
  bool _videoIsPlaying = false;
  double _sliderVal = 0;
  bool _isVideoInitialized = false;
  bool _isVideoLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentItem);
    _preloadVideo(widget.currentItem);
  }

  Future<void> _preloadVideo(int index) async {
    if (index < 0 || index >= widget.mediaItems.length) return;
    final media = widget.mediaItems[index];
    if (media.type != MediaType.video || media.mediaPath == null) return;

    setState(() {
      _isVideoLoading = true;
      _isVideoInitialized = false;
      _videoIsPlaying = false;
      _sliderVal = 0;
    });

    if (_videoController != null) {
      await _videoController!.pause();
      await _videoController!.dispose();
    }

    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(media.mediaPath!))
          ..addListener(() {
            if (_videoController!.value.isInitialized) {
              setState(() {
                _sliderVal =
                    _videoController!.value.position.inSeconds.toDouble();
                _isVideoInitialized = true;
                _isVideoLoading = false;
              });
            }
            if (_videoController!.value.isCompleted) {
              setState(() {
                _videoIsPlaying = false;
                _sliderVal = 0;
              });
            }
          });

    try {
      await _videoController!.initialize();
      setState(() {
        _isVideoInitialized = true;
        _isVideoLoading = false;
      });
    } catch (e) {
      setState(() {
        _isVideoInitialized = false;
        _isVideoLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load video: $e')),
      );
    }
  }

  Future<void> _playVideo() async {
    if (_videoController == null) return;

    if (!_videoController!.value.isInitialized) {
      setState(() {
        _isVideoLoading = true;
      });
      try {
        await _videoController!.initialize();
        setState(() {
          _isVideoInitialized = true;
          _isVideoLoading = false;
        });
      } catch (e) {
        setState(() {
          _isVideoLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to play video: $e')),
        );
        return;
      }
    }

    await _videoController!.play();
    setState(() {
      _videoIsPlaying = true;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController?.pause();
    _videoController?.dispose();
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
          if (_videoController != null) {
            _videoController!.pause();
            setState(() {
              _videoIsPlaying = false;
              _isVideoInitialized = false;
              _sliderVal = 0;
            });
          }
          _preloadVideo(index);
        },
        itemBuilder: (context, index) {
          final media = widget.mediaItems[index];
          return Center(
            child: switch (media.type) {
              MediaType.image => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      filterQuality: FilterQuality.high,
                      image: NetworkImage(media.mediaPath!),
                    ),
                  ),
                ),
              MediaType.video => Stack(
                  alignment: Alignment.center,
                  children: [
                    _isVideoInitialized && _videoController != null
                        ? AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          )
                        : AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  image: NetworkImage(media.thumbnailPath!),
                                ),
                              ),
                            ),
                          ),
                    if (_isVideoLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    if (_isVideoInitialized && _videoController != null)
                      Positioned(
                        bottom: -5,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              IconButton.filled(
                                iconSize: 20,
                                onPressed: _isVideoLoading
                                    ? null
                                    : () {
                                        if (_videoIsPlaying) {
                                          _videoController?.pause();
                                          setState(() {
                                            _videoIsPlaying = false;
                                          });
                                        } else {
                                          _playVideo();
                                        }
                                      },
                                icon: Icon(
                                  _videoIsPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2.0,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 6.0,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Slider(
                                      min: 0,
                                      max: _videoController == null ||
                                              !_videoController!
                                                  .value.isInitialized
                                          ? 1
                                          : _videoController!
                                              .value.duration.inSeconds
                                              .toDouble(),
                                      value: _sliderVal,
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.grey,
                                      onChanged: (value) {
                                        if (_videoController != null &&
                                            _videoController!
                                                .value.isInitialized) {
                                          if (!_videoIsPlaying) {
                                            _playVideo();
                                          }
                                          setState(() {
                                            _sliderVal = value;
                                            _videoController!.seekTo(Duration(
                                                seconds: value.toInt()));
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              MediaType.gif => GiphyMediaView(mediaId: media.mediaPath)
            },
          );
        },
      ),
    );
  }
}
