import 'dart:developer';

import 'package:anime_nexa/features/post/repository/i_post_repository.dart';
import 'package:anime_nexa/models/mediaitem.dart';
import 'package:anime_nexa/providers/global_providers.dart';
import 'package:anime_nexa/shared/utils.dart';
import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import '../../../shared/constants/collections_paths.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../models/reply.dart';

final postRepoProvider = Provider((ref) {
  return PostRepository(
    ref.watch(firebaseFirestoreProvider),
    ref.watch(appwriteStorageProvider),
  );
});

class PostRepository implements IPostRepository {
  final FirebaseFirestore _firestore;
  final Storage _storage;

  PostRepository(this._firestore, this._storage);

  @override
  Future<void> createPost(Post post) async {
    try {
      if (post.media != null && post.media!.isNotEmpty) {
        List<MediaItem> uploadedMedia = [];

        for (var mediaItem in post.media!) {
          if (mediaItem.mediaPath != null &&
              (mediaItem.type == MediaType.image ||
                  mediaItem.type == MediaType.video) &&
              mediaItem.appwriteID == null) {
            final file = File(mediaItem.mediaPath!);
            final fileName =
                '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

            // Upload main media file
            final result = await _storage.createFile(
              bucketId: dotenv.env['APPWRITE_BUCKET_ID']!,
              fileId: ID.unique(),
              file: InputFile.fromPath(
                path: file.path,
                filename: fileName,
              ),
            );

            String? thumbnailUrl;
            String? thumbnailAppwriteID;
            if (mediaItem.type == MediaType.video &&
                mediaItem.thumbnailPath != null) {
              final thumbnailFile = File(mediaItem.thumbnailPath!);
              final thumbnailFileName =
                  '${DateTime.now().millisecondsSinceEpoch}_thumbnail_${thumbnailFile.path.split('/').last}';

              final thumbnailResult = await _storage.createFile(
                bucketId: dotenv.env['APPWRITE_BUCKET_ID']!,
                fileId: ID.unique(),
                file: InputFile.fromPath(
                  path: thumbnailFile.path,
                  filename: thumbnailFileName,
                ),
              );

              thumbnailUrl = getFileUrl(thumbnailResult.$id);
              thumbnailAppwriteID = thumbnailResult.$id;
            }

            uploadedMedia.add(
              mediaItem.copyWith(
                appwriteID: result.$id,
                mediaPath: getFileUrl(result.$id),
                thumbnailPath: thumbnailUrl,
                thumbnailAppwriteID: thumbnailAppwriteID,
              ),
            );
          } else {
            uploadedMedia.add(mediaItem);
          }
        }

        // Update post with uploaded media information
        post = post.copyWith(media: uploadedMedia);
      }

      await _firestore
          .collection(CollectionsPaths.posts)
          .doc(post.pid)
          .set(post.toJson());
    } on (AppwriteException, FirebaseException, Exception) catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  @override
  Future<void> deletePost(Post post) async {
    try {
      if (post.media != null && post.media!.isNotEmpty) {
        for (var mediaItem in post.media!) {
          // Delete main media file
          if (mediaItem.appwriteID != null) {
            try {
              await _storage.deleteFile(
                bucketId: dotenv.env['APPWRITE_BUCKET_ID']!,
                fileId: mediaItem.appwriteID!,
              );
            } catch (e) {
              print('Error deleting media file: $e');
            }
          }

          // Delete thumbnail if it exists
          if (mediaItem.thumbnailAppwriteID != null) {
            try {
              await _storage.deleteFile(
                bucketId: dotenv.env['APPWRITE_BUCKET_ID']!,
                fileId: mediaItem.thumbnailAppwriteID!,
              );
            } catch (e) {
              print('Error deleting thumbnail file: $e');
            }
          }
        }
      }
      await _firestore
          .collection(CollectionsPaths.posts)
          .doc(post.pid)
          .delete();
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to delete post');
    }
  }

  @override
  Future<Post> getPostById(String id) async {
    try {
      final doc =
          await _firestore.collection(CollectionsPaths.posts).doc(id).get();
      return Post.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to get post by ID');
    }
  }

  @override
  Stream<List<Post>> getPosts() {
    try {
      return _firestore
          .collection(CollectionsPaths.posts)
          .where('isDraft', isEqualTo: false)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to get posts stream');
    }
  }

  Stream<List<Post>?> getPostsFromDrafts(String? uid) {
    try {
      return _firestore
          .collection(CollectionsPaths.posts)
          .where('uid', isEqualTo: uid)
          .where('isDraft', isEqualTo: true)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to get posts from draft');
    }
  }

  @override
  Future<void> likePost(Post post, String userId) async {
    try {
      await _firestore.collection(CollectionsPaths.posts).doc(post.pid).update({
        'likes': post.likes!.contains(userId)
            ? FieldValue.arrayRemove([userId])
            : FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to like post');
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
      log(e.toString());
      throw Exception('Failed to update post');
    }
  }

  @override
  Future<void> commentOnPost(Comment comment) async {
    try {
      await _firestore
          .collection(CollectionsPaths.comments)
          .doc(comment.id)
          .set(comment.toJson());
      await _firestore
          .collection(CollectionsPaths.posts)
          .doc(comment.postID)
          .update({
        'comments': FieldValue.arrayUnion([comment.id])
      });
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to comment on post');
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
      final snapshot =
          await _firestore.collection(CollectionsPaths.comments).doc(id).get();
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

  Stream<Post> getPostByID(String? id) {
    return _firestore
        .collection(CollectionsPaths.posts)
        .doc(id)
        .snapshots()
        .map((snap) => Post.fromJson(snap.data()!));
  }

  Stream<List<Comment>> fetchCommentsOnPost(String postID) {
    try {
      return _firestore
          .collection(CollectionsPaths.comments)
          .where('postID', isEqualTo: postID)
          .snapshots()
          .map((snap) =>
              snap.docs.map((doc) => Comment.fromJson(doc.data())).toList());
    } catch (e) {
      throw Exception('Failed to fetch comments');
    }
  }

  Stream<List<Post>> fetchPostsByUser(String? uid) {
    try {
      return _firestore
          .collection(CollectionsPaths.posts)
          .where('uid', isEqualTo: uid)
          .snapshots()
          .map((snap) =>
              snap.docs.map((doc) => Post.fromJson(doc.data())).toList());
    } catch (e) {
      throw Exception("Failed to fetch posts");
    }
  }
}
