import 'package:cloud_firestore/cloud_firestore.dart';

class Reply {
  String? id;
  String? commentId;
  String? userId;
  String? text;
  DateTime? createdAt;
  List<String>? likes;
  String? parentReplyId; // null if it's a top-level reply to a comment
  List<String>? replies; // List of reply IDs if this is a parent reply

  Reply({
    this.id,
    this.commentId,
    this.userId,
    this.text,
    this.createdAt,
    this.likes,
    this.parentReplyId,
    this.replies,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commentId': commentId,
      'userId': userId,
      'text': text,
      'createdAt': createdAt,
      'likes': likes,
      'parentReplyId': parentReplyId,
      'replies': replies,
    };
  }

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json['id'] as String?,
      commentId: json['commentId'] as String?,
      userId: json['userId'] as String?,
      text: json['text'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      parentReplyId: json['parentReplyId'] as String?,
      replies:
          (json['replies'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }
}