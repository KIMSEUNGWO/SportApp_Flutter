

import 'package:flutter/material.dart';


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
