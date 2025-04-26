import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/constants/app_theme.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          spacing: 8,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('lib/assets/images/unnamed (14).png'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jon Doe',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  'Online',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: appTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
