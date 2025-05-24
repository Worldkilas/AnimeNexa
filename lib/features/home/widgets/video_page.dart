import 'package:flutter/material.dart';
import 'package:anime_nexa/models/mediaitem.dart';
import 'package:video_player/video_player.dart';
import 'package:anime_nexa/shared/utils/utils.dart';

class VideoPage extends StatefulWidget {
  final MediaItem media;
  const VideoPage({required this.media, super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _videoController;
  bool _videoIsPlaying = false;
  double _sliderVal = 0;
  bool _isVideoInitialized = false;
  bool _isVideoLoading = false;
  bool _showControls = true;
  late final ValueNotifier<bool> _controlsNotifier;
  late final ValueNotifier<double> _sliderNotifier;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controlsNotifier = ValueNotifier(_showControls);
    _sliderNotifier = ValueNotifier(_sliderVal);
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    setState(() {
      _isVideoLoading = true;
      _isVideoInitialized = false;
      _videoIsPlaying = false;
      _sliderVal = 0;
    });
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.media.mediaPath!));
    _videoController!.addListener(_videoListener);
    try {
      await _videoController!.initialize();
      setState(() {
        _isVideoInitialized = true;
        _isVideoLoading = false;
        _sliderVal = 0;
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

  void _videoListener() {
    if (_videoController == null) return;
    if (_videoController!.value.isInitialized) {
      _sliderNotifier.value =
          _videoController!.value.position.inSeconds.toDouble();
      if (_videoController!.value.isCompleted) {
        setState(() {
          _videoIsPlaying = false;
          _sliderVal = 0;
        });
        _videoController!.seekTo(Duration.zero);
      }
    }
  }

  Future<void> _playPauseVideo() async {
    if (_videoController == null) return;
    if (_videoController!.value.isPlaying) {
      await _videoController!.pause();
      setState(() {
        _videoIsPlaying = false;
      });
    } else {
      await _videoController!.play();
      setState(() {
        _videoIsPlaying = true;
      });
    }
  }

  void _onSliderChanged(double value) {
    if (_videoController != null && _videoController!.value.isInitialized) {
      _videoController!.seekTo(Duration(seconds: value.toInt()));
      _sliderNotifier.value = value;
    }
  }

  void _toggleControls() {
    _showControls = !_showControls;
    _controlsNotifier.value = _showControls;
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    _controlsNotifier.dispose();
    _sliderNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _isVideoInitialized && _videoController != null
              ? AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                )
              : const Center(
                  child: CircularProgressIndicator(color: Colors.white)),
          ValueListenableBuilder<bool>(
            valueListenable: _controlsNotifier,
            builder: (context, show, child) {
              if (!show) return const SizedBox.shrink();
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _videoIsPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: _isVideoLoading ? null : _playPauseVideo,
                      ),
                      Expanded(
                        child: ValueListenableBuilder<double>(
                          valueListenable: _sliderNotifier,
                          builder: (context, value, child) {
                            final max = _videoController
                                    ?.value.duration.inSeconds
                                    .toDouble() ??
                                1;
                            return Slider(
                              min: 0,
                              max: max > 0 ? max : 1,
                              value: value.clamp(0, max),
                              onChanged:
                                  _isVideoInitialized ? _onSliderChanged : null,
                              activeColor: Colors.white,
                              inactiveColor: Colors.grey,
                            );
                          },
                        ),
                      ),
                      Text(
                        _videoController != null &&
                                _videoController!.value.isInitialized
                            ? formatDuration(_videoController!.value.position,
                                _videoController!.value.duration)
                            : '--:--/--:--',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (_isVideoLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
        ],
      ),
    );
  }
}
