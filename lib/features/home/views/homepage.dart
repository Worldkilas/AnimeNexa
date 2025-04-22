import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/constants/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';

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

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildStoryRow(),
          _buildTabBar(),
          Expanded(child: _buildPostList()),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          SvgPicture.asset(
            "lib/assets/icons/Logo.svg",
            color: AppColors.primary,
          ), // Replace with your logo asset
          Spacer(),
          CustomButton(
            onPressed: () {},
            text: 'Connect wallet',
          ),
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
    );
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

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: [
          Text('Trending',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(width: 16),
          Text('Following', style: TextStyle(color: Colors.grey, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildPostList() {
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return _buildPostCard(post);
      },
    );
  }

  Widget _buildPostCard(Map<String, String> post) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(post['image']!,
                  fit: BoxFit.cover, width: double.infinity, height: 200),
              Positioned(
                bottom: 8,
                left: 8,
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 12,
                        backgroundImage:
                            AssetImage('lib/assets/images/post.png')),
                    SizedBox(width: 6),
                    Text(post['author']!,
                        style: TextStyle(color: Colors.white)),
                    SizedBox(width: 8),
                    Text(post['time']!,
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(post['caption']!, style: TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Row(
              children: [
                Icon(Icons.favorite_border, size: 20),
                SizedBox(width: 4),
                Text(post['likes']!),
                Spacer(),
                Icon(Icons.comment_outlined, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
