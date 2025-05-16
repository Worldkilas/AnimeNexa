import 'package:anime_nexa/features/home/widgets/post_card.dart';
import 'package:anime_nexa/features/clans/widgets/discover_clan_card.dart';
import 'package:anime_nexa/shared/constants/app_theme.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExploreClans extends StatelessWidget {
  const ExploreClans({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        elevation: 0,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              SearchBar(
                elevation: WidgetStatePropertyAll(0),
                constraints: BoxConstraints(
                  maxHeight: 50,
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: const Icon(
                    Icons.search,
                    size: 20,
                  ),
                ),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                ),
                textStyle: WidgetStatePropertyAll(
                  AppTypography.textSmall.copyWith(
                    color: Colors.black,
                  ),
                ),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                hintText: "Search",
                hintStyle: WidgetStatePropertyAll(
                  AppTypography.textSmall.copyWith(
                    color: const Color(0xff888888),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // ClanPostCard(
              //   imagePath: [
              //     imagePathGen('clanpost1'),
              //     imagePathGen('clanpost2'),
              //     imagePathGen('clanpost3'),
              //     imagePathGen('clanpost3'),
              //   ],
              //   clanName: "The Sakura Society",
              //   posterName: "Sakura Haruno",
              //   posterUsername: "@sakura_haruno",
              //   text:
              //       "For fans of Studio Ghibli magic.\n#animefan #actionanime",
              //   withinClan: false,
              // ),
              const SizedBox(height: 38),
              Row(
                children: [
                  Text(
                    "Discover New Clans",
                    style: AppTypography.textMediumBold.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...List.generate(3, (_) {
                return DiscoverClanCard(
                  imgPath: imagePathGen('disover'),
                  name: "The Sakura Society",
                );
              }),
              const SizedBox(height: 12),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      context.go('/discover/suggested');
                    },
                    child: Text(
                      "Show more",
                      style: AppTypography.textMedium.copyWith(
                        color: appTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
