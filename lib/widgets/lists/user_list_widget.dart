
import 'package:flutter/material.dart';
import 'package:flutter_sport/models/common/user_profile.dart';
import 'package:flutter_sport/models/response_user.dart';

class UserSimpWidget extends StatelessWidget {

  final UserSimp user;

  const UserSimpWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          userProfile(context, diameter: 40, image: user.thumbnailUser),
          const SizedBox(width: 15,),
          Expanded(
            child: Text(user.nickname,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: Theme.of(context).textTheme.displayMedium!.fontSize
              ),
            ),
          ),
        ],
      ),
    );
  }
}
