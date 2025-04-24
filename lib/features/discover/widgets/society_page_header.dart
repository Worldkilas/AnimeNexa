import 'package:anime_nexa/features/discover/widgets/clan_action_button.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class SocietyPageHeader extends StatelessWidget {
  const SocietyPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffCCE5FF),
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The Sakura Society',
                  style: AppTypography.textLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(
                      width: 90,
                      height: 24,
                      child: Stack(
                        children: List.generate(5, (index) {
                          return Positioned(
                            left: index * 15.0,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: [
                                  Colors.orange[200],
                                  Colors.blue[200],
                                  Colors.green[200],
                                  Colors.purple[200],
                                  Colors.yellow[200],
                                ][index],
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '513k Members',
                      style: AppTypography.textSmall.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Where blooming fans gather.',
                  style: AppTypography.textSmall.copyWith(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              ClanActionButton(
                onPressed: () {},
                icon: Icons.message,
              ),
              SizedBox(width: 8),
              ClanActionButton(
                onPressed: () {},
                icon: Icons.upload,
              ),
              SizedBox(width: 8),
              CustomButton(
                text: "Join",
                onPressed: () {},
                width: 42,
                height: 28,
                padding: EdgeInsets.all(0),
                textStyle: AppTypography.textSmall.copyWith(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
