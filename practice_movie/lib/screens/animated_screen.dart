import 'package:flutter/material.dart';

typedef ChildBuilder = Widget Function(int index, BuildContext context);
typedef OnPageChangeCallback = void Function(int index);

class AnimatedScreen extends StatelessWidget {
  final PageController pageController;
  final double pageValue;
  final ChildBuilder child;
  final int pageCount;
  final OnPageChangeCallback onPageChangeCallback;

  const AnimatedScreen({
    super.key,
    required this.pageController,
    required this.pageValue,
    required this.child,
    required this.pageCount,
    required this.onPageChangeCallback,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      onPageChanged: onPageChangeCallback,
      physics: const ClampingScrollPhysics(),
      controller: pageController,
      itemCount: pageCount,
      itemBuilder: (context, index) {
        if (index == pageValue.floor() + 1 || index == pageValue.floor() + 2) {
          return Transform.translate(
            offset: Offset(0, 100 * (index - pageValue)),
            child: child(index, context),
          );
        } else if (index == pageValue.floor() ||
            index == pageValue.floor() - 1) {
          return Transform.translate(
            offset: Offset(0, 100 * (pageValue - index)),
            child: child(index, context),
          );
        } else {
          return child(index, context);
        }
      },
    );
  }
}
