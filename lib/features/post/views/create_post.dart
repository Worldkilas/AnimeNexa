import 'dart:developer';
import 'dart:io';

import 'package:anime_nexa/features/clans/widgets/post_card.dart';
import 'package:anime_nexa/features/clans/widgets/post_media.dart';
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

final canPopProvider = StateProvider<bool>((ref) {
  return false;
});

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
          if (file.path!.endsWith('.mp4')) {
            final thumbnail = await generateThumbnail(File(file.path!));
            setState(() {
              _selectedFiles.add(MediaItem(
                  type: MediaType.video,
                  mediaPath: file.path!,
                  thumnailPath: thumbnail!.path));
            });
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
          onDraftSelected: () =>
              _handlePostCreation(ref, context, isDraft: true),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    GiphyFlutterSDK.configure(apiKey: giphyAPIKey);
  }

  Future<void> _handlePostCreation(WidgetRef ref, BuildContext context,
      {bool? isDraft}) async {
    if (_postController.text.isEmpty && _selectedFiles.isEmpty) return;

    final post = Post(
      pid: const Uuid().v4(),
      uid: ref.watch(firebaseAuthProvider).currentUser!.uid,
      text: _postController.text,
      media: _selectedFiles,
      createdAt: DateTime.now(),
      likes: [],
      comments: [],
      isDraft: isDraft ?? false,
    );

    try {
      ref.read(canPopProvider.notifier).state = true;
      ref.read(postNotifierProvider.notifier).createPost(context, ref, post);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: ref.watch(canPopProvider),
      onPopInvokedWithResult: (didpop, __) {
        if (_postController.text.isNotEmpty) {
          _showOptionsBottomSheet(ref, context);
        } else {
          ref.read(canPopProvider.notifier).state = true;
          context.pop();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close, size: 30),
            onPressed: () {
              _postController.text.isEmpty && _selectedFiles.isEmpty
                  ? context.pop()
                  : _showOptionsBottomSheet(ref, context);
            },
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Consumer(builder: (context, ref, _) {
            bool isLoading = ref.watch(isCreatingPostDraftProvider);
            return isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  )
                : ref
                    .watch(postsDraftProvider(
                        FirebaseAuth.instance.currentUser!.uid))
                    .when(data: (data) {
                    return InkWell(
                      onTap: () async {
                        if (data == null) {
                          if (_postController.text.isNotEmpty) {
                            _handlePostCreation(ref, context, isDraft: true);
                          }
                        } else {
                          final result = await Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return DraftsScreen();
                          }));
                          if (result != null) {
                            setState(() {
                              _postController.clear();
                              _selectedFiles.clear();
                              postFromDraft = result;
                              _postController.text = postFromDraft!.text!;
                              _selectedFiles = postFromDraft!.media!
                                  .map((e) => e.copyWith())
                                  .toList();
                            });
                          }
                        }
                      },
                      child: Text(
                        data == null ? 'Save as draft' : "Drafts",
                        style: AppTypography.textSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  }, error: (_, __) {
                    return Text(
                      'Save as draft',
                      style: AppTypography.textSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  }, loading: () {
                    return Text(
                      'Loading',
                      style: AppTypography.textSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  });
          }),
          centerTitle: true,
          actionsPadding: const EdgeInsets.only(right: 15),
          actions: [
            ValueListenableBuilder(
                valueListenable: _postController,
                builder: (context, value, _) {
                  final isCreating = ref.watch(isCreatingPostProvider);
                  final canPost =
                      value.text.isNotEmpty || _selectedFiles.isNotEmpty;

                  return InkWell(
                    onTap: isCreating || !canPost
                        ? null
                        : () => _handlePostCreation(ref, context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 7.5,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: !canPost
                            ? Color(0xffaf80df)
                            : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: isCreating
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            )
                          : Text(
                              'Post Now',
                              style: AppTypography.textSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                    ),
                  );
                }),
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
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.purple,
                          child: Text(
                            'M',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Row(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedPrivacy,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: InkWell(
                                onTap: () => _showPrivacyOptions(context),
                                child:
                                    SvgPicture.asset(iconPathGen('dropdown')),
                              ),
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
                        if (_selectedFiles.isNotEmpty)
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 35.h,
                            ),
                            child: CarouselView(
                              itemSnapping: true,
                              itemExtent:
                                  _selectedFiles.length > 1 ? 320 : 100.w,
                              shrinkExtent: 200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enableSplash: false,
                              children: _selectedFiles.map((sfile) {
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
                                                ? NetworkImage(getFileUrl(
                                                    sfile.thumnailPath ??
                                                        sfile.appwriteID!))
                                                : FileImage(File(
                                                    sfile.type ==
                                                            MediaType.video
                                                        ? sfile.thumnailPath!
                                                        : sfile.mediaPath!,
                                                  )),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                    },
                                    if (sfile.type == MediaType.video)
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black
                                              .withValues(alpha: 0.5),
                                        ),
                                        padding: EdgeInsets.all(8),
                                        child: Icon(
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.black
                                                .withValues(alpha: 0.3),
                                          ),
                                          child: Text(
                                            "GIF",
                                            style: AppTypography.textXSmall
                                                .copyWith(
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
                                          padding: const EdgeInsets.all(0),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedFiles.remove(sfile);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        const SizedBox(height: 16),
                        // Row(
                        //   children: [
                        //     SvgPicture.asset(iconPathGen('followers')),
                        //     const SizedBox(width: 10),
                        //     Text(
                        //       'Tag People',
                        //       style: AppTypography.textMedium.copyWith(
                        //         color: const Color(0xff555555),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      pickFile();
                    },
                    child: SvgPicture.asset(
                      iconPathGen('image'),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      GiphyMedia result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => GifScreen()));
                      if (result != null) {
                        setState(() {
                          _selectedFiles.add(MediaItem(
                              type: MediaType.gif, mediaPath: result.id));
                        });
                      }
                    },
                    child: SvgPicture.asset(
                      iconPathGen('gif'),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     _showScheduleBottomSheet(context);
                  //   },
                  //   child: SvgPicture.asset(
                  //     iconPathGen('history'),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }
}
