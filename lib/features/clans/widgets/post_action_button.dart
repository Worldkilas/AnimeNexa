import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostActionButton extends StatelessWidget {
  String? imagePath;
  int? count;
  PostActionButton({this.imagePath, this.count, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          imagePath!,
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 2),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xff888888),
          ),
        ),
      ],
    );
  }
}
