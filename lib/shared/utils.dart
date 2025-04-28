import 'dart:io';

String imagePathGen(String name) {
  return 'lib/assets/images/$name.png';
}

String iconPathGen(String name) {
  return 'lib/assets/icons/$name.svg';
}

// Future<String?> generateThumbnail(File videoFile) async {
//   try {
//     final thumbnailPath = await VideoThumbnail.thumbnailFile(
//       video: videoFile.path,
//       thumbnailPath: '/tmp/thumbnails', 
//       imageFormat: ImageFormat.PNG,
//       maxHeight: 200,
//     );
//     return thumbnailPath;
//   } catch (e) {
//     print('Error generating thumbnail: $e');
//     return null;
//   }
// }