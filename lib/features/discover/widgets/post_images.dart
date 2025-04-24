import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class PostImages extends StatelessWidget {
  final List<String> images;

  const PostImages({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    Widget imageTile(
      String path,
    ) {
      return GestureDetector(
        //TODO: Navigate to image page
        child: Container(
          height: double.infinity,
          width: double.infinity,
          margin: EdgeInsets.all(1),
          decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 10,
                cornerSmoothing: 0.8,
              ),
            ),
            image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover),
          ),
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: () {
        if (images.length == 1) {
          return imageTile(images[0]);
        } else if (images.length == 2) {
          return Row(
            children: [
              Expanded(child: imageTile(images[0])),
              Expanded(child: imageTile(images[1])),
            ],
          );
        } else if (images.length == 3) {
          return Row(
            children: [
              Expanded(child: imageTile(images[0])),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.48,
                child: Column(
                  children: [
                    Expanded(child: imageTile(images[1])),
                    const SizedBox(height: 4),
                    Expanded(child: imageTile(images[2])),
                  ],
                ),
              ),
            ],
          );
        } else {
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.8,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  imageTile(
                    images[index],
                  ),
                  if (index == 3 && images.length > 4)
                    Container(
                      color: Colors.black.withOpacity(0.6),
                      alignment: Alignment.center,
                      child: Text(
                        '+${images.length - 4}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        }
      }(),
    );
  }
}
