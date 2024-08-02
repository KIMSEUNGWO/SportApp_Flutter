
import 'package:flutter/material.dart';
import 'package:flutter_sport/models/club/authority.dart';
import 'package:flutter_sport/models/common/user_profile.dart';
import 'package:flutter_sport/models/response_user.dart';

import 'package:easy_localization/easy_localization.dart';

class UserSimpWidget extends StatelessWidget {

  final UserSimp user;
  final Authority? authority;

  const UserSimpWidget({super.key, required this.user, this.authority});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
          const SizedBox(width: 15,),
          if (authority != null && authority != Authority.USER)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              child: Text('authority',
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize
                ),
              ).tr(gender: authority!.lang),
            ),
        ],
      ),
    );
  }
}
