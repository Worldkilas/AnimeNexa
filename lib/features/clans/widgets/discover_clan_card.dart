import 'dart:math';

import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DiscoverClanCard extends StatelessWidget {
  String? imgPath;
  String? name;
  DiscoverClanCard({this.imgPath, this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/discover/society');
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          spacing: 16,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imgPath!,
                height: 72,
                width: 72,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name!,
                  style: AppTypography.textMediumBold,
                ),
                Text(
                  "${Random().nextInt(10000) + 2000} Members",
                  style: AppTypography.textSmall.copyWith(
                    color: Color(0xff888888),
                  ),
                ),
                SizedBox(
                  height: 24,
                  width: 150,
                  child: Stack(
                      children: List.generate(5, (index) {
                    return Positioned(
                      left: index * 20.0,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 11,
                          backgroundImage: AssetImage(
                            imagePathGen('disover'),
                          ),
                        ),
                      ),
                    );
                  })),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
