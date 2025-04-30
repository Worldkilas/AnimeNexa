import 'package:anime_nexa/models/reply.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? id;
  String? postId;
  String? userId;
  String? text;
  DateTime? createdAt;
  List<String>? likes;
  List<Reply>? replies;

  Comment({
    this.id,
    this.postId,
    this.userId,
    this.text,
    this.createdAt,
    this.likes,
    this.replies,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'text': text,
      'createdAt': createdAt,
      'likes': likes,
      'replies': replies,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String?,
      postId: json['postId'] as String?,
      userId: json['userId'] as String?,
      text: json['text'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      replies:
          (json['replies'] as List<dynamic>?)
              ?.map((e) => Reply.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}
