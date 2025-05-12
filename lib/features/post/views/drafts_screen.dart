import 'dart:developer';

import 'package:anime_nexa/features/post/viewmodel/post_vm.dart';
import 'package:anime_nexa/models/mediaitem.dart';
import 'package:anime_nexa/models/post.dart';
import 'package:anime_nexa/providers/global_providers.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giphy_flutter_sdk/giphy_media_view.dart';

class DraftsScreen extends ConsumerWidget {
  const DraftsScreen({super.key});

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, WidgetRef ref, Post post) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Draft'),
          content: Text('Are you sure you want to delete this draft?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await ref.read(postNotifierProvider.notifier).deletePost(post);
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showClearAllConfirmationDialog(
      BuildContext context, WidgetRef ref, List<Post> posts) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear All Drafts'),
          content: Text('Are you sure you want to delete all drafts?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                for (var post in posts) {
                  await ref
                      .read(postNotifierProvider.notifier)
                      .deletePost(post);
                }
              },
              child: Text(
                'Clear All',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Drafts",
          style: AppTypography.textLarge.copyWith(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final drafts = ref.watch(postsDraftProvider(
                  ref.read(firebaseAuthProvider).currentUser!.uid));
              return drafts.when(
                data: (posts) {
                  if (posts == null || posts.isEmpty) return SizedBox();
                  return TextButton(
                    onPressed: () =>
                        _showClearAllConfirmationDialog(context, ref, posts),
                    child: Text(
                      'Clear All',
                      style: AppTypography.textMedium.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  );
                },
                error: (_, __) => SizedBox(),
                loading: () => SizedBox(),
              );
            },
          ),
        ],
      ),
      body: ref
          .watch(postsDraftProvider(
              ref.read(firebaseAuthProvider).currentUser!.uid))
          .when(
        data: (posts) {
          if (posts == null || posts.isEmpty) {
            return Center(
              child: Text(
                'No drafts yet',
                style: AppTypography.textMedium,
              ),
            );
          }
          return ListView.separated(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                minTileHeight: 80,
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                onTap: () {
                  Navigator.pop(context, post);
                },
                onLongPress: () {
                  _showDeleteConfirmationDialog(context, ref, post);
                },
                title: Text(
                  post.text!,
                  style: AppTypography.textMedium,
                ),
                trailing: post.media!.isEmpty
                    ? SizedBox()
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          post.media![0].type == MediaType.gif
                              ? GiphyMediaView(
                                  mediaId: post.media![0].mediaPath,
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.black.withValues(alpha: 0.3),
                                        BlendMode.srcATop,
                                      ),
                                      image: NetworkImage(
                                        post.media![0].type == MediaType.video
                                            ? post.media![0].thumbnailPath!
                                            : post.media![0].mediaPath!,
                                      ),
                                    ),
                                  ),
                                ),
                          if (post.media!.length > 1)
                            Text(
                              "+${post.media!.length - 1} ",
                              style: AppTypography.linkSmall
                                  .copyWith(color: Colors.white),
                            )
                        ],
                      ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 0.3,
                color: Colors.grey[400],
              );
            },
          );
        },
        error: (e, _) {
          return Center(
            child: Text("Error"),
          );
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
