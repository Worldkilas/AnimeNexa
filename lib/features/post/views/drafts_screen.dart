import 'dart:developer';

import 'package:anime_nexa/features/post/viewmodel/post_vm.dart';
import 'package:anime_nexa/models/mediaitem.dart';
import 'package:anime_nexa/providers/global_providers.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giphy_flutter_sdk/giphy_media_view.dart';

class DraftsScreen extends ConsumerWidget {
  const DraftsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Drafts",
          style: AppTypography.textLarge.copyWith(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: ref
          .watch(postsDraftProvider(
              ref.read(firebaseAuthProvider).currentUser!.uid))
          .when(
        data: (posts) {
          return ListView.separated(
            itemCount: posts!.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                minTileHeight: 80,
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                onTap: () {
                  Navigator.pop(context, post);
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
                                            ? 
                                                post.media![0].thumnailPath!
                                            : 
                                                post.media![0].mediaPath!,
                                      ),
                                    ),
                                  ),
                                ),
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
