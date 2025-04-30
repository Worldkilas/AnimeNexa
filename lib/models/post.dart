import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? pid;
  String? uid;
  List<String>? media;
  String? text;
  DateTime? createdAt;
  List<String>? likes;
  List<String>? comments;

  Post({
    this.pid,
    this.uid,
    this.media,
    this.text,
    this.createdAt,
    this.likes,
    this.comments,
  });

  Map<String, dynamic> toJson() {
    return {
      'pid': pid,
      'uid': uid,
      'media': media,
      'text': text,
      'createdAt': createdAt,
      'likes': likes,
      'comments': comments,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      pid: json['pid'] as String?,
      uid: json['uid'] as String?,
      media:
          (json['media'] as List<dynamic>?)?.map((e) => e as String).toList(),
      text: json['text'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Post(pid: $pid, uid: $uid, media: $media, text: $text, createdAt: $createdAt, likes: $likes, comments: $comments)';
  }
}
