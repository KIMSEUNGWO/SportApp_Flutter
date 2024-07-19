
import 'package:flutter/material.dart';

class ImageDetailView extends StatelessWidget {

  final Image image;

  const ImageDetailView({super.key, required this.image});

  Image convert() {
    return Image(image: image.image, fit: BoxFit.contain,);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: convert(),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, size: 30,),
              ),
            ),
          ]
        ),
      ),
    );
  }
}

class SwipeablePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  SwipeablePageRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // 애니메이션을 위한 커스텀 트랜지션
      final begin = Offset(0.0, 1.0);
      final end = Offset.zero;
      final curve = Curves.easeInOut;
      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      final slideTransition = SlideTransition(position: offsetAnimation, child: child);

      return slideTransition;
    },
  );
}

