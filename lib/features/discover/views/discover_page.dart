import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        //TODO: Implement discover page
        body: TabBarView(
          children: List.generate(
            2,
            (index) {
              return PageView.builder(
                itemCount: 7,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'lib/assets/images/1dcab71d5f3e9c3ad255c7fd25d6e26a57fbff13.png',
                        fit: BoxFit.cover,
                      )
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
