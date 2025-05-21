import 'package:anime_nexa/core/typedefs.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../post/models/post.dart';
import '../../post/repository/post_repository.dart';

part 'post_feed_view_model.g.dart';

@riverpod
class PostFeedViewModel extends _$PostFeedViewModel {
  @override
  AsyncValue<List<Post>> build() {
    _init();
    return AsyncValue.loading();
  }

  void _init() {
    final postRepo = ref.watch(postRepoProvider);
    postRepo.getPosts().listen(
      (posts) {
        posts.sort(
          (a, b) => (b!.createdAt ?? DateTime(0)).compareTo(
            a!.createdAt ?? DateTime(0),
          ),
        ); // recent first
        state = AsyncValue.data(posts);
      },
      onError: (e) => state = AsyncValue.error(e, StackTrace.current),
    );
  }

  FutureVoid toggleLike(Post post, String userId) async {
    final currentLikes = post.likes ?? [];
    final updatedLikes = currentLikes.contains(userId)
        ? currentLikes.where((id) => id != userId).toList()
        : [...currentLikes, userId];

    final updatedPost = post.copyWith(
      likes: updatedLikes,
    );
    await ref.read(postRepoProvider).updatePost(updatedPost);
  }
}
