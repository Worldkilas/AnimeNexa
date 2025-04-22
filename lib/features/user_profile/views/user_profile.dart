import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/constants/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  final String banner =
      'https://images.unsplash.com/photo-1607746882042-944635dfe10e';
  final String avatar = 'https://i.pravatar.cc/150?img=12';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          // clipBehavior: Clip.none,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 25.h,
              // clipBehavior: Clip.none,
              pinned: true,

              elevation: 0,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                title: innerBoxIsScrolled ? Text('8 posts') : SizedBox.shrink(),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(banner, fit: BoxFit.cover),
                    Positioned(
                      left: 16,
                      bottom: -32,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 36,
                          backgroundImage: NetworkImage(avatar),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                child: buildProfileHeader(context),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Color(0xFF8E2DE2),
                  tabs: [
                    Tab(text: 'Posts'),
                    Tab(text: 'Shared'),
                    Tab(text: 'NFTs'),
                    Tab(text: 'Likes'),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: List.generate(4, (index) {
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: 2,
                itemBuilder: (context, i) => buildPostCard(),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget buildProfileHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: CustomButton(
            text: 'Edit profile',
            height: 30,
            width: 110,
            backgroundColor: Colors.white,
            textStyle: AppTypography.linkXSmall,
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            onPressed: () {},
          ),
        ),
        Text(
          "Mini_Kay",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text("@mini_kay", style: TextStyle(color: Colors.grey)),
        SizedBox(height: 10),
        Text(
          "Anime enthusiast, world-builder, and part-time dreamer. Leveling up one episode at a time.",
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(height: 14),
        Row(
          children: [
            Text("XP", style: TextStyle(fontWeight: FontWeight.bold)),
            Spacer(),
            Text("300/10,000", style: TextStyle(color: Colors.grey)),
          ],
        ),
        SizedBox(height: 6),
        Stack(
          children: [
            // Background of the progress bar
            LinearProgressIndicator(
              value: 0.03,
              backgroundColor: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
              minHeight: 10,
              valueColor: AlwaysStoppedAnimation(
                Colors.transparent,
              ), // Transparent to avoid interference
            ),
            // Gradient progress portion
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return AppColors.gradientPrimary.createShader(bounds);
              },
              child: LinearProgressIndicator(
                value: 0.4,
                backgroundColor: Colors.transparent, // Transparent background
                valueColor: AlwaysStoppedAnimation(
                  Colors.white,
                ),
                minHeight: 10, // White to show gradient
                borderRadius:
                    BorderRadius.circular(10), // Optional: rounded edges
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildPostCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1')),
          title: Text("Dante", style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("5h"),
          trailing: Icon(Icons.more_horiz),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'lib/assets/images/post.png',
            fit: BoxFit.cover,
            width: 100.w,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.arrow_upward, color: Colors.purple, size: 18),
              SizedBox(width: 4),
              Text("4"),
              SizedBox(width: 12),
              Icon(Icons.chat_bubble_outline, size: 18),
              SizedBox(width: 4),
              Text("6"),
              Spacer(),
              Icon(Icons.bookmark_border, size: 18),
              SizedBox(width: 12),
              Icon(Icons.send, size: 18),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            "An awesome growing community of anime lovers is what I am trying to create",
            style: TextStyle(color: Colors.black),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _TabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
}
