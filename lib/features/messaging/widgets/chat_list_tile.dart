import 'package:anime_nexa/shared/constants/app_theme.dart';
import 'package:flutter/material.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({super.key, this.trailing});
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // context.go('/messaging/chatView');
      },
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage('lib/assets/images/unnamed (14).png'),
      ),
      title: Text(
        'Jon Doe',
        style: appTheme.textTheme.labelMedium,
      ),
      subtitle: Text(
        'Hey',
        style: appTheme.textTheme.bodySmall,
      ),
      trailing: trailing,
    );
  }
}
