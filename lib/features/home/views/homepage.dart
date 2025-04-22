import 'package:flutter/material.dart';

final List<String> storyAvatars =
    List.generate(10, (index) => 'https://i.pravatar.cc/150?img=$index');
final List<Map<String, String>> posts = [
  {
    'image': 'https://via.placeholder.com/400x300?text=Post1',
    'author': 'Dante',
    'caption': 'Itachi made the biggest sacrifice in history',
    'likes': '1292',
    'time': '5h ago',
  },
  {
    'image': 'https://via.placeholder.com/400x300?text=Post2',
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
          Image.asset("assets/logo.png",
              height: 30), // Replace with your logo asset
          Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: StadiumBorder(),
            ),
            child: Text("Connect Wallet"),
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
              backgroundImage: NetworkImage(storyAvatars[index]),
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
              Image.network(post['image']!,
                  fit: BoxFit.cover, width: double.infinity, height: 200),
              Positioned(
                bottom: 8,
                left: 8,
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 12,
                        backgroundImage:
                            NetworkImage('https://i.pravatar.cc/150?img=3')),
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
