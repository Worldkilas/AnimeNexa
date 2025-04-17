import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

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
              const SizedBox(height: 10),
              Text(
                'Genre Interests',
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 10),
              const Text(
                'Select  Anime genres that interest you.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: availableGenres.map((genre) {
                  return ChoiceChip(
                    label: Text(genre),
                    selected: false, // Static for UI purposes
                    onSelected: (bool selected) {
                      // Selection logic (not implemented)
                    },
                    selectedColor: const Color(0xFF6A0DAD),
                    backgroundColor: Colors.grey[200],
                    labelStyle: const TextStyle(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Color(0xFF6A0DAD)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      context.go('/name');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF6A0DAD)),
                      foregroundColor: const Color(0xFF6A0DAD),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Next button logic (not implemented)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A0DAD),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Next'),
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
