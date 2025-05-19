import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostActionButton extends StatelessWidget {
  String? imagePath;
  Icon? icon;
  int? count;
  VoidCallback? onTap;
  PostActionButton({this.imagePath, this.icon, this.count, this.onTap, super.key})
      : assert(imagePath != null || icon != null,
            "Must assign either image path or icon");

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: imagePath != null
            ? SvgPicture.asset(
                imagePath!,
                width: 20,
                height: 20,
              )
            : icon,
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
