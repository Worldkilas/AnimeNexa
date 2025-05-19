import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../../models/post.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/constants/app_typography.dart';
import '../../clans/widgets/post_card.dart';
import '../../post/viewmodel/post_vm.dart';
import '../view_models/post_feed_view_model.dart';
import '../widgets/home_popup_menu.dart';
import '../widgets/home_popup_menu.dart';

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
  // late ReownAppKitModal appkit;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postNotifierProvider);
    // final walletAsync = ref.watch(walletViewModelProvider);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: SvgPicture.asset(
            "lib/assets/icons/Logo.svg",
            color: AppColors.primary,
          ),
          actions: [
            // appkit.isConnected
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 11),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
                onPressed: () {},
                child: Text(
                  "Connect wallet",
                  style: AppTypography.textXSmall.copyWith(color: Colors.white),
                ),
              ),
            ),
            CustomPopupMenu(),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // _buildStoryRow(),
            // _buildTabBar(),
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     spacing: 20,
            //     children: [
            //       ...List.generate(5, (index) => TrendingPost()),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 20),
            ref.watch(postNotifierProvider).when(data: (posts) {
              return Column(
                children: [
                  ...posts.map((post) => PostCard(post: post)),
                ],
              );
            }, error: (e, _) {
              return Column(
                children: [
                  Text(e.toString()),
                  TextButton(onPressed: () {}, child: Text("Refresh")),
                ],
              );
            }, loading: () {
              return Center(child: CircularProgressIndicator());
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryRow() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: storyAvatars.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(storyAvatars[index]),
              ),
              SizedBox(
                width: 15,
              )
            ],
          );
        },
      ),
    );
  }
}

Widget _buildTabBar() {
  return Row(
    children: [
      Text('Trending',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      SizedBox(width: 16),
      Text('Following', style: TextStyle(color: Colors.grey, fontSize: 18)),
    ],
  );
}

class TrendingPost extends ConsumerWidget {
  const TrendingPost({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 270,
      width: 60.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(
            'lib/assets/images/1dcab71d5f3e9c3ad255c7fd25d6e26a57fbff13.png',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.2),
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.bookmark,
                    color: Colors.white,
                  ))
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
      ),
    );
  }
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
