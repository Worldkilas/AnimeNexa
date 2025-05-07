import 'dart:developer';

import 'package:anime_nexa/features/post/repository/post_repository.dart';
import 'package:anime_nexa/models/comment.dart';
import 'package:anime_nexa/models/post.dart';
import 'package:anime_nexa/models/reply.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postNotifierProvider =
    StreamNotifierProvider<PostNotifier, List<Post>>(() {
  return PostNotifier();
});

final isCreatingPostProvider = StateProvider<bool>((ref) => false);

void toggleCreatePostLoadingStatus(WidgetRef ref, bool state) {
  ref.read(isCreatingPostProvider.notifier).state = state;
}

class PostNotifier extends StreamNotifier<List<Post>> {
  late final PostRepository _repository;

  @override
  Stream<List<Post>> build() {
    _repository = ref.watch(postRepoProvider);
    return _repository.getPosts();
  }

  Future<void> createPost(WidgetRef ref, Post post) async {
    try {
      toggleCreatePostLoadingStatus(ref, true);
      await _repository.createPost(post);
      toggleCreatePostLoadingStatus(ref, false);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      log(e.toString(), stackTrace: StackTrace.current);
      toggleCreatePostLoadingStatus(ref, false);
    }
  }

  Future<void> deletePost(Post post) async {
    try {
      await _repository.deletePost(post);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> likePost(String postId, String userId) async {
    try {
      await _repository.likePost(postId, userId);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> commentOnPost(Comment comment) async {
    try {
      await _repository.commentOnPost(comment);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> replyToComment(Reply reply) async {
    try {
      await _repository.replyToComment(reply);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> deleteComment(Comment comment) async {
    try {
      await _repository.deleteComment(comment);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> deleteReply(Reply reply) async {
    try {
      await _repository.deleteReply(reply);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<Post> getPostById(String id) async {
    try {
      return await _repository.getPostById(id);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<Comment> getCommentById(String id) async {
    try {
      return await _repository.getCommentById(id);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<List<Reply>> getReplies(String commentId) async {
    try {
      return await _repository.getReplies(commentId);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}
