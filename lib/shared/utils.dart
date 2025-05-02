import 'dart:io';

import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

String imagePathGen(String name) {
  return 'lib/assets/images/$name.png';
}

String iconPathGen(String name) {
  return 'lib/assets/icons/$name.svg';
}

Future<XFile?> generateThumbnail(File videoFile) async {
  try {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoFile.path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 200,
    );
    return thumbnailPath;
  } catch (e) {
    print('Error generating thumbnail: $e');
    return null;
  }
}
