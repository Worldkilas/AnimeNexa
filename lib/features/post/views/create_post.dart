import 'dart:developer';
import 'dart:io';

import 'package:anime_nexa/features/post/widgets/options_bottom_sheet.dart';
import 'package:anime_nexa/features/post/widgets/privacy_options_bottom_sheet.dart';
import 'package:anime_nexa/features/post/widgets/schedule_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String _selectedPrivacy = 'Public';
  List<String> _selectedFiles = [];
  List<String> _selectedVids = []; // store selected video files
  DateTime _selectedDate = DateTime(2025, 2, 19);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 16, minute: 0);
  TextEditingController _postController = TextEditingController();

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
            _selectedVids.add(file.path!);
            // final thumbnail = await generateThumbnail(File(file.path!));
            // setState(() {
            //   _selectedFiles.add(thumbnail!);
            // });
          } else {
            setState(() {
              _selectedFiles.add(file.path!);
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

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return OptionsBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, size: 30),
          onPressed: () {
            _postController.text.isEmpty
                ? context.pop()
                : _showOptionsBottomSheet(context);
          },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: InkWell(
          onTap: () {
            context.pop();
          },
          child: Text(
            'Save as draft',
            style: AppTypography.textSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        centerTitle: true,
        actionsPadding: const EdgeInsets.only(right: 22),
        actions: [
          ValueListenableBuilder(
              valueListenable: _postController,
              builder: (context, value, _) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 7.5,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: value.text.isEmpty
                        ? Color(0xffaf80df)
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
                );
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Column(
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
                          child: SvgPicture.asset(iconPathGen('dropdown')),
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
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    style: AppTypography.textMedium.copyWith(
                      color: const Color(0xff555555),
                    ),
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      hintStyle: AppTypography.textMedium.copyWith(
                        color: const Color(0xff555555),
                      ),
                      border: InputBorder.none,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_selectedFiles.isNotEmpty)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 400,
                      ),
                      child: CarouselView(
                        itemExtent: _selectedFiles.length > 1 ? 320 : 100.w,
                        shrinkExtent: 200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enableSplash: false,
                        children: _selectedFiles.map((sfile) {
                          return Stack(
                            children: [
                              Container(
                                height: 33.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(File(sfile)),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(3),
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
            const Spacer(),
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
                    onTap: () {},
                    child: SvgPicture.asset(
                      iconPathGen('gif'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _showScheduleBottomSheet(context);
                    },
                    child: SvgPicture.asset(
                      iconPathGen('history'),
                    ),
                  ),
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
