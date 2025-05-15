import 'package:anime_nexa/features/wallet/wallet_view_model.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:sizer/sizer.dart';

import '../../../models/post.dart';
import '../../../providers/global_providers.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/utils/utils.dart';
import '../../auth/view_model/auth_view_model.dart';
import '../../clans/widgets/post_card.dart';
import '../../post/viewmodel/post_vm.dart';
import '../view_models/post_feed_view_model.dart'
    show postFeedViewModelProvider;

final List<String> storyAvatars =
    List.generate(10, (index) => 'lib/assets/images/post.png');
final List<Map<String, String>> posts = [
  {
    'image': 'lib/assets/images/post.png',
    'author': 'Dante',
    'caption': 'Itachi made the biggest sacrifice in history',
    'likes': '1292',
    'time': '5h ago',
  },
  {
    'image': 'lib/assets/images/post.png',
    'author': 'Dante',
    'caption': 'Another cool post about anime',
    'likes': '892',
    'time': '1h ago',
  },
];

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postNotifierProvider);
    final walletAsync = ref.watch(walletViewModelProvider);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: SvgPicture.asset(
            "lib/assets/icons/Logo.svg",
            color: AppColors.primary,
          ),
          actions: [
            walletAsync.when(
              data: (pubKey) => pubKey == null
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 9, horizontal: 11),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                        onPressed: () async {
                          final vmNotifier =
                              ref.read(walletViewModelProvider.notifier);
                          final state = ref.read(walletViewModelProvider);
                          if (state is AsyncData) {
                            await vmNotifier.connect();
                          } else {
                            debugPrint('🟩 WalletViewModel not yet ready');
                          }
                        },
                        child: Text(
                          "Connect wallet",
                          style: AppTypography.textXSmall
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    )
                  : Text(
                      shortenWalletAddress(pubKey),
                    ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(
                'Error: $e',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {},
            ),
          ]),
      body: postsAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return Center(
              child: Text(
                'No posts available',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(post: post);
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

Widget _buildStoryRow() {
  return SizedBox(
    height: 80,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 8),
      itemCount: storyAvatars.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(storyAvatars[index]),
          ),
        );
      },
    ),
  );
}

// Widget _buildTabBar() {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//     child: Row(
//       children: [
//         Text('Trending',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//         SizedBox(width: 16),
//         Text('Following', style: TextStyle(color: Colors.grey, fontSize: 18)),
//       ],
//     ),
//   );
// }

Widget _buildPostList(WidgetRef ref) {
  final postsAsync = ref.watch(postFeedViewModelProvider);
  final user = ref.watch(authViewModelProvider.notifier).user;

  return postsAsync.when(
    data: (posts) => ListView.builder(
      padding: EdgeInsets.all(22),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return _buildPostCard(ref, post, user?.userId);
      },
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (err, _) => Center(
      child: Text('Error: $err'),
    ),
  );
}

Widget _buildPostCard(WidgetRef ref, Post post, String? currentUserId) {
  final isLiked = post.likes?.contains(currentUserId) ?? false;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(
              'lib/assets/images/post.png',
            ),
          ),
          SizedBox(width: 6),
          Text(post.uid!, style: AppTypography.textMedium),
          SizedBox(width: 8),
          Text(timeAgo(post.createdAt!), style: AppTypography.textMedium),
        ],
      ),
      SizedBox(height: 1.h),
      if (post.media?.isNotEmpty ?? false)
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            post.media![1].mediaPath!,
            fit: BoxFit.cover,
            height: 264,
          ),
        ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(post.text ?? '', style: TextStyle(fontSize: 16)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
        child: Row(
          children: [
            IconButton(
              onPressed: currentUserId != null
                  ? () {
                      ref
                          .read(postFeedViewModelProvider.notifier)
                          .toggleLike(post, currentUserId);
                    }
                  : null,
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: isLiked ? Colors.red : Colors.black,
              ),
            ),
            SizedBox(width: 4),
            Text('${post.likes?.length ?? 0}'),
            Spacer(),
            Icon(Icons.comment, size: 20),
          ],
        ),
      ),
    ],
  );
}

// class TrendingPosts extends StatelessWidget {
//   const TrendingPosts({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       height: 270,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset(
//             'lib/assets/images/1dcab71d5f3e9c3ad255c7fd25d6e26a57fbff13.png',
//             fit: BoxFit.cover,
//           )
//         ],
//       ),
//     );
//   }
// }
