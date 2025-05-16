import 'package:anime_nexa/features/home/widgets/post_card.dart';
import 'package:anime_nexa/features/post/viewmodel/post_vm.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/constants/app_colors.dart';
import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../auth/view_model/auth_view_model.dart';
import '../../wallet/wallet_view_model.dart';

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

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletViewModel = ref.read(walletViewModelProvider.notifier);
    final walletState = ref.watch(walletViewModelProvider);
    final displayText = walletState.address != null
        ? shortenWalletAddress(walletState.address!)
        : 'Connect wallet';
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: SvgPicture.asset(
            "lib/assets/icons/Logo.svg",
            color: AppColors.primary,
          ),
          actions: [
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
            IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {},
            ),
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
}

class TrendingPost extends StatelessWidget {
  const TrendingPost({super.key});

  @override
  Widget build(BuildContext context) {
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
          )
        ],
      ),
    );
  }
}
