import 'package:anime_nexa/features/clans/widgets/discover_clan_card.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/utils.dart';
import 'package:flutter/material.dart';

class SuggestedClans extends StatelessWidget {
  const SuggestedClans({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        forceMaterialTransparency: true,
        title: Text(
          "Suggested Clans",
          style: AppTypography.textLarge
              .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              ...List.generate(15, (_) {
                return DiscoverClanCard(
                  imgPath: imagePathGen('disover'),
                  name: "The Sakura Society",
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
