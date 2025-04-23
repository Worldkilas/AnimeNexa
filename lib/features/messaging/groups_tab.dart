import 'package:flutter/material.dart';

class GroupsTab extends StatelessWidget {
  const GroupsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        //TODO: implement real messages
        return ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('lib/assets/images/unnamed (14).png'),
          ),
          title: Text(
            'Weeb Warriors',
            style: theme.textTheme.labelMedium,
          ),
          subtitle: Text(
            'Hey',
            style: theme.textTheme.bodySmall,
          ),
          trailing: Column(
            children: [
              Text('10:00 AM'),
              Container(
                width: 25,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColor,
                ),
                child: Center(
                  child: Text(
                    20.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
