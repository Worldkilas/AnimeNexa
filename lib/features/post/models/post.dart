// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:anime_nexa/models/mediaitem.dart';

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
      'likes': likes ?? [],
      'comments': comments ?? [],
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
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
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
      isDraft: isDraft ?? this.isDraft,
    );
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.pid == pid &&
        other.uid == uid &&
        listEquals(other.media, media) &&
        other.text == text &&
        other.createdAt == createdAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.comments, comments) &&
        other.isDraft == isDraft;
  }

  @override
  int get hashCode {
    return pid.hashCode ^
        uid.hashCode ^
        media.hashCode ^
        text.hashCode ^
        createdAt.hashCode ^
        likes.hashCode ^
        comments.hashCode ^
        isDraft.hashCode;
  }
}

final dummyPost = Post(
  pid: "post_123",
  uid: "user_456",
  media: [
    
  ],
  text: "This is a sample post for testing purposes.",
  createdAt: DateTime.now(),
  likes: ["user_789", "user_101"],
  comments: ["comment_123", "comment_456"],
  isDraft: false,
);
