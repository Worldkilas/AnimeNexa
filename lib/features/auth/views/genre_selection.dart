import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/widgets/custom_button.dart';

class GenresScreen extends StatelessWidget {
  const GenresScreen({super.key});

  final List<String> availableGenres = const [
    'Action',
    'Adventure',
    'Shonen',
    'Spy',
    'Science',
    'Romance',
    'Technology',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset('lib/assets/icons/Logo.svg'),
              SizedBox(height: 2.5.h),
              Text(
                'Genre Interests',
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Select  Anime genres that interest you.',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 7.h),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: availableGenres.map((genre) {
                  return ChoiceChip(
                    label: Text(genre),
                    selected: false, // Static for UI purposes
                    onSelected: (bool selected) {
                      //TODO:  Selection logic (not implemented)
                    },
                    selectedColor: theme.primaryColor,
                    backgroundColor: Colors.grey[200],
                    labelStyle: theme.textTheme.displaySmall,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Color(0xFF6A0DAD)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  );
                }).toList(),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    text: 'Back',
                    backgroundColor: Colors.white,
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                      width: 1.5,
                    ),
                    textColor: Colors.black,
                    onPressed: () {
                      context.pop();
                    },
                    width: 140,
                  ),
                  CustomButton(
                    text: 'Next',
                    onPressed: () {
                      //TODO: Change to actual navigation
                      context.go('/home');
                    },
                    width: 140,
                  )
                ],
              ),
              SizedBox(height: 4.h)
            ],
          ),
        ),
      ),
    );
  }
}
