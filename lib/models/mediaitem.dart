// ignore_for_file: public_member_api_docs, sort_constructors_first
enum MediaType { image, video, gif }

class MediaItem {
  final MediaType type;
  final String? mediaPath;
  final String? thumnailPath;
  
  MediaItem({
    required this.type,
    required this.mediaPath,
    this.thumnailPath,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.name,
      'mediaPath': mediaPath,
      'thumnailPath': thumnailPath,
    };
  }

  factory MediaItem.fromMap(Map<String, dynamic> map) {
    return MediaItem(
      type: MediaType.values.firstWhere((item) => item.name == map['type']),
      mediaPath: map['media'],
      thumnailPath: map['thumbnailPath'],
    );
  }


  MediaItem copyWith({
    MediaType? type,
    String? mediaPath,
    String? thumnailPath,
  }) {
    return MediaItem(
      type: type ?? this.type,
      mediaPath: mediaPath ?? this.mediaPath,
      thumnailPath: thumnailPath ?? this.thumnailPath,
    );
  }

  @override
  String toString() => 'MediaItem(type: $type, mediaPath: $mediaPath, thumnailPath: $thumnailPath)';
}
