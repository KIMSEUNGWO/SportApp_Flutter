

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class UserImageWidget extends StatelessWidget {
  const UserImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

Widget userProfile(BuildContext context, {required double diameter, required Image? image}) {
  return Container(
    width: diameter, height: diameter,
    clipBehavior: Clip.hardEdge,
    decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
            color: Color(0xFFD7D7D7),
            width: 0.1
        )
    ),
    child: image ??
        Center(child: Icon(Icons.person, size: diameter * 0.75, color: const Color(0xFFBCB7B7),)),
  );
}

Widget clubImage(BuildContext context, {
  required double width,
  required double height,
  required Image? image,
  double? circle,
  EdgeInsets? margin,
}) {
  final iconSize = (width + height) / 2 * 0.8;
  return Container(
      width: width, height: height,
      margin: margin,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(circle ?? 10),
      ),
      child: image ?? Center(
          child: SvgPicture.asset('assets/icons/emptyGroupImage.svg',
            width: iconSize, height: iconSize, color: const Color(0xFF878181),
          )
      )
  );
}
