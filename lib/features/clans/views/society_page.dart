import 'package:anime_nexa/features/clans/widgets/post_card.dart';
import 'package:anime_nexa/features/clans/widgets/society_page_header.dart';
import 'package:anime_nexa/shared/constants/app_theme.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class SocietyPage extends StatefulWidget {
  const SocietyPage({super.key});

  @override
  State<SocietyPage> createState() => _SocietyPageState();
}

class _SocietyPageState extends State<SocietyPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 18.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imagePathGen('clanpost1')),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Icons stacked on top of the header image
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton.filled(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.5),
                            shape: const CircleBorder(),
                          ),
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Row(
                          children: [
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.5),
                                shape: const CircleBorder(),
                              ),
                              icon: const Icon(Icons.search),
                              onPressed: () {},
                            ),
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.5),
                                shape: const CircleBorder(),
                              ),
                              icon: const Icon(Icons.more_horiz),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SocietyPageHeader(),
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController, // Connect the TabController
                  tabs: const [
                    Tab(text: 'Posts'),
                    Tab(text: 'Events'),
                    Tab(text: 'Leaderboard'),
                  ],
                  labelColor: appTheme.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: appTheme.primaryColor,
                  labelStyle: AppTypography.textMediumBold,
                ),
              ),
            ],
          ),

          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController, // Connect the TabController
              children: [
                ListView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  children: [
                    // ClanPostCard(
                    //   imagePath: [
                    //     imagePathGen('clanpost1'),
                    //     imagePathGen('clanpost2'),
                    //     imagePathGen('clanpost3'),
                    //     imagePathGen('clanpost4'),
                    //   ],
                    //   clanName: "The Sakura Society",
                    //   posterName: "Mini_Key",
                    //   posterUsername: "mini_kay",
                    //   withinClan: true,
                    //   text:
                    //       "For fans of Studio Ghibli magic.\n#animefan #actionanime",
                    // ),
                    // Divider(),
                    // ClanPostCard(
                    //   text:
                    //       "Have y’all ever stopped watching anime at some point, like a break or something?",
                    //   posterName: "Big.Alpha",
                    //   posterUsername: "Alpha",
                    //   withinClan: true,
                    //   clanName: "The Sakura Society",
                    //   imagePath: [],
                    // ),
                    // Divider(),
                    // ClanPostCard(
                    //   text:
                    //       "Have y’all ever stopped watching anime at some point, like a break or something?",
                    //   posterName: "Big.Alpha",
                    //   posterUsername: "Alpha",
                    //   withinClan: true,
                    //   clanName: "The Sakura Society",
                    //   imagePath: [],
                    // ),
                  ],
                ),
                const Center(child: Text('Events Coming Soon')),
                const Center(child: Text('Leaderboard Coming Soon')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
