// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'reply.dart';

class Comment {
  String? id;
  String? postID;
  String? userID;
  String? text;
  DateTime? createdAt;
  List<String>? likes;
  List<Reply>? replies;

  Comment({
    this.id,
    this.postID,
    this.userID,
    this.text,
    this.createdAt,
    this.likes,
    this.replies,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postID': postID,
      'userID': userID,
      'text': text,
      'createdAt': createdAt,
      'likes': likes,
      'replies': replies,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String?,
      postID: json['postID'] as String?,
      userID: json['userID'] as String?,
      text: json['text'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => Reply.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, postId: $postID, userId: $userID, text: $text, createdAt: $createdAt, likes: $likes, replies: $replies)';
  }
}

final dummyComment = Comment(
  id: "comment_123",
  postID: "post_456",
  userID: "user_789",
  text: "This is a dummy comment for testing.",
  createdAt: DateTime.now(),
  likes: ["user_101", "user_102"],
  replies: [],
);
