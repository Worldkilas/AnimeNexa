import 'package:anime_nexa/features/clans/widgets/post_action_button.dart';
import 'package:anime_nexa/features/home/widgets/comment_card.dart';
import 'package:anime_nexa/features/home/widgets/post_card.dart';
import 'package:anime_nexa/features/home/widgets/post_media.dart';
import 'package:anime_nexa/features/post/viewmodel/post_vm.dart';
import 'package:anime_nexa/models/comment.dart';
import 'package:anime_nexa/models/post.dart';
import 'package:anime_nexa/providers/global_providers.dart';
import 'package:anime_nexa/shared/constants/app_theme.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/utils.dart';
import 'package:anime_nexa/shared/utils/utils.dart';
import 'package:anime_nexa/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uuid/uuid.dart';

class PostDetail extends ConsumerStatefulWidget {
  final String postId;

  const PostDetail({super.key, required this.postId});

  @override
  ConsumerState<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends ConsumerState<PostDetail> {
  TextEditingController commentCtrl = TextEditingController();
  bool commentIsLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Post',
          style: AppTypography.textMediumBold,
        ),
      ),
      body: ref.watch(getPostByIDProvider(widget.postId)).when(
        data: (post) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    PostCard(post: post),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Comments",
                                style: AppTypography.textMediumBold.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ref
                              .watch(fetchCommentsByPostProvider(widget.postId))
                              .when(data: (comments) {
                            return Column(
                              children: [
                                ...comments.map(
                                    (comment) => CommentCard(comment: comment))
                              ],
                            );
                          }, error: (e, stk) {
                            return Center(
                              child: Text(e.toString()),
                            );
                          }, loading: () {
                            return Skeletonizer(
                                child: Column(
                                    children: List.generate(4, (_) {
                              return CommentCard(comment: dummyComment);
                            })));
                          })
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    controller: commentCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: "Add a comment",
                      hintStyle: AppTypography.textSmall,
                      suffixIcon: InkWell(
                        onTap: () async {
                          final temp = commentCtrl.text.trim();
                          try {
                            setState(() {
                              commentIsLoading = true;
                            });
                            await ref.read(commentOnPostProvider(
                              Comment(
                                id: Uuid().v4(),
                                postID: widget.postId,
                                userID: ref
                                    .read(firebaseAuthProvider)
                                    .currentUser!
                                    .uid,
                                text: temp,
                                createdAt: DateTime.now(),
                                likes: [],
                                replies: [],
                              ),
                            ).future);
                            setState(() {
                              commentIsLoading = false;
                            });
                            commentCtrl.clear();
                            FocusScope.of(context).unfocus();
                          } catch (e) {
                            setState(() {
                              commentIsLoading = false;
                            });
                            utilitySnackBar(context, e.toString());
                          }
                        },
                        child: commentIsLoading
                            ? SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(),
                              )
                            : Icon(Icons.send),
                      ),
                    ),
                    style: AppTypography.textSmall,
                    cursorHeight: 20,
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${error.toString()}'),
                TextButton(
                  onPressed: () {
                    ref.invalidate(postNotifierProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
