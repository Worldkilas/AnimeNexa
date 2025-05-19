import 'package:anime_nexa/features/home/widgets/post_card.dart';
import 'package:anime_nexa/features/post/viewmodel/post_vm.dart';
import 'package:anime_nexa/models/anime_nexa_user.dart';
import 'package:anime_nexa/providers/global_providers.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/constants/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  final String banner =
      'https://images.unsplash.com/photo-1607746882042-944635dfe10e';
  final String avatar = 'https://i.pravatar.cc/150?img=12';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: ref
              .watch(fetchUserDataProvider(
                  ref.watch(firebaseAuthProvider).currentUser!.uid))
              .when(
            data: (user) {
              return Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        height: 25.h,
                        width: double.infinity,
                        child: Image.network(
                          banner,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Avatar
                      Positioned(
                        left: 16,
                        bottom: -40,
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
                  SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: buildProfileHeader(context, user),
                  ),
                  // TabBar
                  Container(
                    color: Colors.white,
                    child: TabBar(
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
                  SizedBox(
                    height: 50.h, // Adjust height to fit content
                    child: TabBarView(
                      children: List.generate(4, (index) {
                        return index != 0
                            ? Center(
                                child: Text("Coming soon"),
                              )
                            : ref.watch(postNotifierProvider).when(
                                data: (posts) {
                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Column(
                                      children: [
                                        ...posts
                                            .map((post) => PostCard(post: post))
                                      ],
                                    ),
                                  ),
                                );
                              }, error: (e, _) {
                                return Text(e.toString());
                              }, loading: () {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              });
                      }),
                    ),
                  ),
                ],
              );
            },
            error: (e, __) {
              return Center(
                child: Text("Failed to fetch user data"),
              );
            },
            loading: () {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildProfileHeader(BuildContext context, AnimeNexaUser user) {
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
            onPressed: () async {
              context.push('/edit');
            },
          ),
        ),
        Text(
          user.username,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text("@${user.username}", style: TextStyle(color: Colors.grey)),
        SizedBox(height: 10),
        Text(
          user?.bio ?? '',
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(height: 14),
        Row(
          children: [
            Text("XP", style: TextStyle(fontWeight: FontWeight.bold)),
            Spacer(),
            Text("${user.xps}/10,000", style: TextStyle(color: Colors.grey)),
          ],
        ),
        SizedBox(height: 6),
        Stack(
          children: [
            LinearProgressIndicator(
              value: user.xps.toDouble(),
              backgroundColor: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
              minHeight: 10,
              valueColor: AlwaysStoppedAnimation(Colors.transparent),
            ),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return AppColors.gradientPrimary.createShader(bounds);
              },
              child: LinearProgressIndicator(
                value: user.xps.toDouble(),
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation(Colors.white),
                minHeight: 10,
                borderRadius: BorderRadius.circular(10),
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
