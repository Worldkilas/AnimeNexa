// ignore_for_file: public_member_api_docs, sort_constructors_first
enum MediaType { image, video, gif }

class MediaItem {
  final MediaType type;
  final String? mediaPath;
  final String? thumbnailPath;
  final String? appwriteID;
  final String? thumbnailAppwriteID;

  MediaItem({
    required this.type,
    required this.mediaPath,
    this.thumbnailPath,
    this.appwriteID,
    this.thumbnailAppwriteID,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.name,
      'mediaPath': mediaPath,
      'thumbnailPath': thumbnailPath,
      'appwriteID': appwriteID,
      'thumbnailAppwriteID': thumbnailAppwriteID,
    };
  }

  factory MediaItem.fromMap(Map<String, dynamic> map) {
    return MediaItem(
      type: MediaType.values.firstWhere((item) => item.name == map['type']),
      mediaPath: map['mediaPath'],
      thumbnailPath: map['thumbnailPath'],
      appwriteID: map['appwriteID'],
      thumbnailAppwriteID: map['thumbnailAppwriteID'],
    );
  }

  MediaItem copyWith({
    MediaType? type,
    String? mediaPath,
    String? thumbnailPath,
    String? appwriteID,
    String? thumbnailAppwriteID,
  }) {
    return MediaItem(
      type: type ?? this.type,
      mediaPath: mediaPath ?? this.mediaPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      appwriteID: appwriteID ?? this.appwriteID,
      thumbnailAppwriteID: thumbnailAppwriteID ?? this.thumbnailAppwriteID,
    );
  }

  @override
  String toString() =>
      'MediaItem(type: $type, mediaPath: $mediaPath, thumnailPath: $thumbnailPath, appwriteID: $appwriteID, thumbnailAppwriteID: $thumbnailAppwriteID)';
}
