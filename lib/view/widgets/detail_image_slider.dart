import 'package:flutter/material.dart';

class MyDetailImageSlider extends StatelessWidget {
  final PageController controller;
  final Function(int) onChange;
  final List<String> images;

  const MyDetailImageSlider({
    super.key,
    required this.onChange,
    required this.images,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 260,
      child: PageView.builder(
        controller: controller,
        onPageChanged: onChange,
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(images[index], fit: BoxFit.contain),
          );
        },
      ),
    );
  }
}
