import 'dart:developer';
import 'dart:io';

import 'package:anime_nexa/features/home/widgets/post_card.dart';
import 'package:anime_nexa/features/home/widgets/post_media.dart';
import 'package:anime_nexa/features/post/viewmodel/post_vm.dart';
import 'package:anime_nexa/features/post/views/drafts_screen.dart';
import 'package:anime_nexa/features/post/views/gif_screen.dart';
import 'package:anime_nexa/features/post/widgets/options_bottom_sheet.dart';
import 'package:anime_nexa/features/post/widgets/privacy_options_bottom_sheet.dart';
import 'package:anime_nexa/features/post/widgets/schedule_bottom_sheet.dart';
import 'package:anime_nexa/models/mediaitem.dart';
import 'package:anime_nexa/models/post.dart';
import 'package:anime_nexa/providers/global_providers.dart';
import 'package:anime_nexa/shared/constants/app_theme.dart';
import 'package:anime_nexa/shared/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/utils.dart';
import 'package:giphy_flutter_sdk/dto/giphy_asset.dart';
import 'package:giphy_flutter_sdk/dto/giphy_media.dart';
import 'package:giphy_flutter_sdk/giphy_flutter_sdk.dart';
import 'package:giphy_flutter_sdk/giphy_media_view.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

// no need to hide, it's free😂
const giphyAPIKey = "LrjKIV019iAkmubcMpunGTW1tvLw57x1";

class CreatePost extends ConsumerStatefulWidget {
  const CreatePost({super.key});

  @override
  ConsumerState<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends ConsumerState<CreatePost> {
  String _selectedPrivacy = 'Public';
  List<MediaItem> _selectedFiles = [];
  DateTime _selectedDate = DateTime(2025, 2, 19);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 16, minute: 0);
  final TextEditingController _postController = TextEditingController();
  Post? postFromDraft;

  // Memoize widgets that don't need frequent rebuilds
  late final Widget _privacyDropdown = InkWell(
    onTap: () => _showPrivacyOptions(context),
    child: SvgPicture.asset(iconPathGen('dropdown')),
  );

  late final Widget _avatar = const CircleAvatar(
    radius: 18,
    backgroundColor: Colors.purple,
    child: Text(
      'M',
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
  );

  void _showScheduleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return ScheduleBottomSheet(
          selectedDate: _selectedDate,
          selectedTime: _selectedTime,
          onDateChanged: (DateTime newDate) {
            setState(() {
              _selectedDate = newDate;
            });
          },
          onTimeChanged: (TimeOfDay newTime) {
            setState(() {
              _selectedTime = newTime;
            });
          },
        );
      },
    );
  }

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result != null && result.files.isNotEmpty) {
      // for some weird file_picker i've to filter the files manually
      for (final file in result.files) {
        if (file.path!.endsWith('.jpg') ||
            file.path!.endsWith('.jpeg') ||
            file.path!.endsWith('.png') ||
            file.path!.endsWith('.mp4')) {
          final fileName = file.path!.split('/').last;

          bool isDuplicate = _selectedFiles.any((media) {
            final existingFileName = media.mediaPath!.split('/').last;
            return existingFileName == fileName;
          });

          if (isDuplicate) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('This file has already been selected'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
            continue;
          }

          if (file.path!.endsWith('.mp4')) {
            try {
              final thumbnail = await generateThumbnail(File(file.path!));
              setState(() {
                _selectedFiles.add(MediaItem(
                    type: MediaType.video,
                    mediaPath: file.path!,
                    thumbnailPath: thumbnail!.path));
              });
            } on Exception catch (e) {
              log(e.toString());
              utilitySnackBar(context, "An error occured");
            }
          } else {
            setState(() {
              _selectedFiles
                  .add(MediaItem(type: MediaType.image, mediaPath: file.path!));
            });
          }
        }
      }
    }
  }

  void _showPrivacyOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return PrivacyOptionsBottomSheet(
          selectedPrivacy: _selectedPrivacy,
          onPrivacyChanged: (String newPrivacy) {
            setState(() {
              _selectedPrivacy = newPrivacy;
            });
          },
        );
      },
    );
  }

  void _showOptionsBottomSheet(WidgetRef ref, BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return OptionsBottomSheet(
          onDraftSelected: () async {
            await _handlePostCreation(ref, context, isDraft: true).then((_) {
              Navigator.pop(context);
              Navigator.pop(context);
            });
          },
          onDeleteSelected: () async {
            if (context.mounted) {
              context.pop();
            }
          },
        );
      },
    );
  }

  Future<void> _handlePostCreation(WidgetRef ref, BuildContext context,
      {bool? isDraft}) async {
    if (_postController.text.isEmpty && _selectedFiles.isEmpty) return;

    final post = Post(
      pid: postFromDraft!.pid ?? Uuid().v4(),
      uid: ref.watch(firebaseAuthProvider).currentUser!.uid,
      text: _postController.text,
      media: _selectedFiles,
      createdAt: DateTime.now(),
      likes: [],
      comments: [],
      isDraft: isDraft ?? false,
    );

    try {
      _postController.clear();
      FocusScope.of(context).unfocus();
      await ref.read(postNotifierProvider.notifier).createPost(ref, post);
      context.pop();
    } catch (e, stk) {
      log(stk.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    GiphyFlutterSDK.configure(apiKey: giphyAPIKey);
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Widget _buildMediaPreview(MediaItem sfile) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (sfile.type == MediaType.gif) ...{
          GiphyMediaView(mediaId: sfile.mediaPath)
        } else ...{
          Container(
            height: 35.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: sfile.appwriteID != null
                    ? NetworkImage(sfile.thumbnailPath ?? sfile.mediaPath!)
                    : FileImage(File(
                        sfile.type == MediaType.video
                            ? sfile.thumbnailPath!
                            : sfile.mediaPath!,
                      )) as ImageProvider,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        },
        if (sfile.type == MediaType.video)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.5),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 20,
            ),
          ),
        if (sfile.type == MediaType.gif)
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.black.withValues(alpha: 0.3),
              ),
              child: Text(
                "GIF",
                style: AppTypography.textXSmall.copyWith(
                  color: Colors.grey[200],
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: Colors.black54,
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              setState(() {
                _selectedFiles.remove(sfile);
              });
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaCarousel() {
    if (_selectedFiles.isEmpty) return const SizedBox.shrink();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 35.h,
      ),
      child: CarouselView(
        itemSnapping: true,
        itemExtent: _selectedFiles.length > 1 ? 320 : 100.w,
        shrinkExtent: 200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enableSplash: false,
        children: _selectedFiles.map(_buildMediaPreview).toList(),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: pickFile,
            child: SvgPicture.asset(iconPathGen('image')),
          ),
          InkWell(
            onTap: () async {
              GiphyMedia? result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const GifScreen()));
              if (result != null && mounted) {
                setState(() {
                  _selectedFiles.add(
                      MediaItem(type: MediaType.gif, mediaPath: result.id));
                });
              }
            },
            child: SvgPicture.asset(iconPathGen('gif')),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCreating = ref.watch(isCreatingPostProvider);
    final isCreatingDraft = ref.watch(isCreatingPostDraftProvider);
    final isLoading = isCreating || isCreatingDraft;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didpop, __) {
        if (didpop) return;
        if (_postController.text.isNotEmpty) {
          _showOptionsBottomSheet(ref, context);
          context.pop();
        } else {
          context.pop();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close, size: 30),
                onPressed: () async {
                  if (_postController.text.isNotEmpty) {
                    _showOptionsBottomSheet(ref, context);
                  } else {
                    context.pop();
                  }
                },
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: ValueListenableBuilder(
                valueListenable: _postController,
                builder: (context, ctrl, _) {
                  return Consumer(
                    builder: (context, ref, _) {
                      return ref
                          .watch(postsDraftProvider(
                              FirebaseAuth.instance.currentUser!.uid))
                          .when(
                            data: (data) =>
                                _buildDraftButton(context, ref, ctrl, data),
                            error: (_, __) => _buildDraftText(context),
                            loading: () => _buildLoadingText(context),
                          );
                    },
                  );
                },
              ),
              centerTitle: true,
              actionsPadding: const EdgeInsets.only(right: 15),
              actions: [
                ValueListenableBuilder(
                  valueListenable: _postController,
                  builder: (context, value, _) {
                    final canPost =
                        value.text.isNotEmpty || _selectedFiles.isNotEmpty;

                    return InkWell(
                      onTap: isLoading || !canPost
                          ? null
                          : () => _handlePostCreation(ref, context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 7.5,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: !canPost
                              ? const Color(0xffaf80df)
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Post Now',
                          style: AppTypography.textSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            _avatar,
                            const SizedBox(width: 10),
                            Row(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedPrivacy,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: _privacyDropdown,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: _postController,
                              maxLines: null,
                              textCapitalization: TextCapitalization.sentences,
                              onTapOutside: (event) =>
                                  FocusScope.of(context).unfocus(),
                              style: AppTypography.textMedium.copyWith(
                                color: const Color(0xff555555),
                              ),
                              decoration: InputDecoration(
                                hintText: "What's on your mind?",
                                hintStyle: AppTypography.textMedium.copyWith(
                                  color: const Color(0xff555555),
                                ),
                                border: InputBorder.none,
                                fillColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildMediaCarousel(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildBottomActions(),
              ],
            ),
          ),
          if (isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildDraftButton(BuildContext context, WidgetRef ref,
      TextEditingValue ctrl, List<Post>? data) {
    return InkWell(
      onTap: () async {
        if (ctrl.text.isNotEmpty || data!.isNotEmpty) {
          if (data!.isEmpty) {
            _showOptionsBottomSheet(ref, context);
          } else {
            final result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const DraftsScreen()));
            if (result != null && mounted) {
              setState(() {
                _postController.clear();
                _selectedFiles.clear();
                postFromDraft = result;
                _postController.text = postFromDraft!.text!;
                _selectedFiles =
                    postFromDraft!.media!.map((e) => e.copyWith()).toList();
              });
            }
          }
        }
      },
      child: Text(
        data!.isEmpty ? 'Save as draft' : "Drafts",
        style: AppTypography.textSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context)
              .primaryColor
              .withValues(alpha: (ctrl.text.isEmpty && data.isEmpty) ? 0.5 : 1),
        ),
      ),
    );
  }

  Widget _buildDraftText(BuildContext context) {
    return Text(
      'Save as draft',
      style: AppTypography.textSmall.copyWith(
        fontWeight: FontWeight.w700,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildLoadingText(BuildContext context) {
    return Text(
      'Loading',
      style: AppTypography.textSmall.copyWith(
        fontWeight: FontWeight.w700,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
