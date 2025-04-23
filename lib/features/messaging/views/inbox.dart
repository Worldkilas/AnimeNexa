import 'package:flutter/material.dart';

import '../groups_tab.dart';
import 'chat_tab.dart';

class InboxView extends StatelessWidget {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Messages',
            style: theme.textTheme.labelLarge,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                //TODO: Implement search functionality
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                //TODO: Implement more options functionality
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: theme.primaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: theme.primaryColor,
            tabs: [
              Tab(text: 'Chats'),
              Tab(text: 'Groups'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChatsTab(),
            GroupsTab(),
          ],
        ),
      ),
    );
  }
}
