import 'package:anime_nexa/features/post/repository/i_post_repository.dart';
import 'package:anime_nexa/models/comment.dart';
import 'package:anime_nexa/models/post.dart';
import 'package:anime_nexa/models/reply.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../../../shared/constants/collections_paths.dart';

class PostRepository implements IPostRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  PostRepository(this._firestore, this._storage);

  @override
  Future<void> createPost(Post post) async {
    try {
      if (post.media!.isNotEmpty) {
        List<String> mediaUrls = [];

        for (String mediaPath in post.media!) {
          final storageRef = _storage.ref().child(
              'posts/${post.pid}/${DateTime.now().millisecondsSinceEpoch}_${mediaPath.split('/').last}');

          final file = File(mediaPath);
          await storageRef.putFile(file);
          final downloadUrl = await storageRef.getDownloadURL();
          mediaUrls.add(downloadUrl);
        }

        post.media = mediaUrls;
      }

      await _firestore
          .collection(CollectionsPaths.posts)
          .doc(post.pid)
          .set(post.toJson());
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  @override
  Future<void> deletePost(Post post) async {
    try {
      await _firestore.collection(CollectionsPaths.posts).doc(post.pid).delete();
      for (String mediaUrl in post.media!) {
        final storageRef = _storage.ref().child(mediaUrl);
        await storageRef.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  @override
  Future<Post> getPostById(String id) async {
    try {
      final doc = await _firestore
          .collection(CollectionsPaths.posts)
          .doc(id)
          .get();
      return Post.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get post by ID: $e');
    }
  }

  @override
  Stream<List<Post>> getPosts() {
    try {
      return _firestore
          .collection(CollectionsPaths.posts)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Post.fromJson(doc.data()))
              .toList());
    } catch (e) {
      throw Exception('Failed to get posts stream: $e');
    }
  }

  @override
  Future<void> likePost(String postId, String userId) async {
    try {
      await _firestore.collection(CollectionsPaths.posts).doc(postId).update({
        'likes': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  @override
  Future<void> updatePost(Post post) async {
    try {
      await _firestore
          .collection(CollectionsPaths.posts)
          .doc(post.pid)
          .update(post.toJson());
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  @override
  Future<void> commentOnPost(Comment comment) async {
    try {
      await _firestore
          .collection(CollectionsPaths.comments)
          .doc(comment.id)
          .set(comment.toJson());
    } catch (e) {
      throw Exception('Failed to comment on post: $e');
    }
  }

  @override
  Future<void> replyToComment(Reply reply) async {
    try {
      await _firestore
          .collection(CollectionsPaths.comments)
          .doc(reply.commentId)
          .collection(CollectionsPaths.replies)
          .doc(reply.id)
          .set(reply.toJson());
    } catch (e) {
      throw Exception('Failed to reply to comment: $e');
    }
  }

  @override
  Future<void> deleteComment(Comment comment) async {
    try {
      await _firestore
          .collection(CollectionsPaths.comments)
          .doc(comment.id)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  @override
  Future<void> deleteReply(Reply reply) async {
    try {
      await _firestore
          .collection(CollectionsPaths.comments)
          .doc(reply.commentId)
          .collection(CollectionsPaths.replies)
          .doc(reply.id)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete reply: $e');
    }
  }

  @override
  Future<Comment> getCommentById(String id) async {
    try {
      final snapshot = await _firestore
          .collection(CollectionsPaths.comments)
          .doc(id)
          .get();
      return Comment.fromJson(snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get comment by ID: $e');
    }
  }

  @override
  Future<List<Reply>> getReplies(String commentId) async {
    try {
      final snapshot = await _firestore
          .collection(CollectionsPaths.comments)
          .doc(commentId)
          .collection(CollectionsPaths.replies)
          .get();
      return snapshot.docs.map((doc) => Reply.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get replies: $e');
    }
  }
}
