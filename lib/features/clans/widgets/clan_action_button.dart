import 'package:flutter/material.dart';

class ClanActionButton extends StatelessWidget {
  VoidCallback? onPressed;
  IconData? icon;
  ClanActionButton({this.onPressed, this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Icon(
        icon,
        size: 18,
        color: Colors.black54,
      ),
    );
  }
}
