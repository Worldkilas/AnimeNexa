import 'dart:developer';

import 'package:anime_nexa/features/post/repository/post_repository.dart';
import 'package:anime_nexa/models/comment.dart';
import 'package:anime_nexa/models/post.dart';
import 'package:anime_nexa/models/reply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final postNotifierProvider =
    StreamNotifierProvider<PostNotifier, List<Post>>(() {
  return PostNotifier();
});

final getPostByIDProvider = StreamProvider.family<Post, String>((ref, id) {
  return ref.read(postRepoProvider).getPostByID(id);
});

final postsDraftProvider =
    StreamProvider.family<List<Post>?, String>((ref, uid) {
  return ref.watch(postRepoProvider).getPostsFromDrafts(uid);
});

final isCreatingPostProvider = StateProvider<bool>((ref) => false);
final isCreatingPostDraftProvider = StateProvider<bool>((ref) => false);

void toggleCreatePostLoadingStatus(WidgetRef ref, bool state) {
  ref.read(isCreatingPostProvider.notifier).state = state;
}

void toggleCreatePostDraftLoadingStatus(WidgetRef ref, bool state) {
  ref.read(isCreatingPostDraftProvider.notifier).state = state;
}

// Standalone providers for side effects
final deletePostProvider = FutureProvider.family<void, Post>((ref, post) async {
  try {
    await ref.read(postRepoProvider).deletePost(post);
  } catch (e) {
    throw Exception('Failed to delete post: $e');
  }
});

final likePostProvider =
    FutureProvider.family<void, ({Post post, String userId})>(
  (ref, params) async {
    try {
      await ref.read(postRepoProvider).likePost(params.post, params.userId);
    } catch (e) {
      throw Exception('Failed to like post');
    }
  },
);

final commentOnPostProvider = FutureProvider.family<void, Comment>(
  (ref, comment) async {
    try {
      await ref.read(postRepoProvider).commentOnPost(comment);
    } catch (e) {
      throw Exception('Failed to comment on post');
    }
  },
);

final replyToCommentProvider = FutureProvider.family<void, Reply>(
  (ref, reply) async {
    try {
      await ref.read(postRepoProvider).replyToComment(reply);
    } catch (e) {
      throw Exception('Failed to reply to comment: $e');
    }
  },
);

final deleteCommentProvider = FutureProvider.family<void, Comment>(
  (ref, comment) async {
    try {
      await ref.read(postRepoProvider).deleteComment(comment);
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  },
);

final deleteReplyProvider = FutureProvider.family<void, Reply>(
  (ref, reply) async {
    try {
      await ref.read(postRepoProvider).deleteReply(reply);
    } catch (e) {
      throw Exception('Failed to delete reply: $e');
    }
  },
);

final getPostByIdProvider = FutureProvider.family<Post, String>(
  (ref, id) async {
    try {
      return await ref.read(postRepoProvider).getPostById(id);
    } catch (e) {
      throw Exception('Failed to get post by ID: $e');
    }
  },
);

final getCommentByIdProvider = FutureProvider.family<Comment, String>(
  (ref, id) async {
    try {
      return await ref.read(postRepoProvider).getCommentById(id);
    } catch (e) {
      throw Exception('Failed to get comment by ID: $e');
    }
  },
);

final getRepliesProvider = FutureProvider.family<List<Reply>, String>(
  (ref, commentId) async {
    try {
      return await ref.read(postRepoProvider).getReplies(commentId);
    } catch (e) {
      throw Exception('Failed to get replies: $e');
    }
  },
);

final fetchCommentsByPostProvider = StreamProvider.family<List<Comment>, String>((ref, postID) {
  return ref.watch(postRepoProvider).fetchCommentsOnPost(postID);
});

class PostNotifier extends StreamNotifier<List<Post>> {
  late PostRepository _repository;

  @override
  Stream<List<Post>> build() {
    _repository = ref.watch(postRepoProvider);
    return _repository.getPosts();
  }

  Future<void> createPost(WidgetRef ref, Post post) async {
    try {
      post.isDraft!
          ? toggleCreatePostDraftLoadingStatus(ref, true)
          : toggleCreatePostLoadingStatus(ref, true);
      await _repository.createPost(post);
      post.isDraft!
          ? toggleCreatePostDraftLoadingStatus(ref, false)
          : toggleCreatePostLoadingStatus(ref, false);
    } catch (e, stk) {
      state = AsyncError(e, stk);
      log(e.toString(), stackTrace: stk);
      toggleCreatePostLoadingStatus(ref, false);
      toggleCreatePostDraftLoadingStatus(ref, false);
      rethrow;
    }
  }
}
