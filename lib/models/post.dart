import 'package:anime_nexa/models/mediaitem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? pid;
  String? uid;
  List<MediaItem>? media;
  String? text;
  DateTime? createdAt;
  List<String>? likes;
  List<String>? comments;
  bool? isDraft;

  Post({
    this.pid,
    this.uid,
    this.media,
    this.text,
    this.createdAt,
    this.likes,
    this.comments,
    this.isDraft = false,
  });

  factory Post.draft({
    String? pid,
    String? uid,
    List<MediaItem>? media,
    String? text,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? comments,
  }) =>
      Post(
        uid: uid,
        pid: pid,
        media: media,
        text: text,
        createdAt: createdAt,
        likes: likes,
        comments: comments,
        isDraft: true,
      );

  Map<String, dynamic> toJson() {
    return {
      'pid': pid,
      'uid': uid,
      'media': media!.map((media) => media.toMap()).toList(),
      'text': text,
      'createdAt': createdAt,
      'likes': likes,
      'comments': comments,
      'isDraft': isDraft,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      pid: json['pid'] as String?,
      uid: json['uid'] as String?,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => MediaItem.fromMap(e))
          .toList(),
      text: json['text'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isDraft: json['isDraft'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Post(pid: $pid, uid: $uid, media: $media, text: $text, createdAt: $createdAt, likes: $likes, comments: $comments, isDraft: $isDraft)';
  }

  Post copyWith({
    String? pid,
    String? uid,
    List<MediaItem>? media,
    String? text,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? comments,
    bool? isDraft,
  }) {
    return Post(
      pid: pid ?? this.pid,
      uid: uid ?? this.uid,
      media: media ?? this.media,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isDraft: isDraft,
    );
  }
}
