import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/common/alert.dart';
import 'package:flutter_sport/common/navigator_helper.dart';
import 'package:flutter_sport/models/common/user_profile.dart';
import 'package:flutter_sport/notifiers/login_notifier.dart';
import 'package:flutter_sport/models/user/profile.dart';
import 'package:flutter_sport/widgets/pages/profile/language_settings.dart';
import 'package:flutter_sport/widgets/pages/profile/profile_edit_page.dart';
import 'package:flutter_sport/widgets/pages/profile/settings.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfilePage extends ConsumerStatefulWidget {

  final Function() themeLight;
  final Function() themeDark;

  const ProfilePage({super.key, required this.themeLight, required this.themeDark});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> with AutomaticKeepAliveClientMixin {

  bool hasLogin = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          GestureDetector(
            onTap: () {
              NavigatorHelper.push(context, SettingWidget(themeLight: widget.themeLight, themeDark: widget.themeDark));
            },
            child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Icon(Icons.settings, size: 30,)
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final profile = ref.watch(loginProvider);
                if (profile != null) {
                  return buildUserProfile(profile);
                } else {
                  return EmptyProfile(context);
                }
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 20,
              decoration: BoxDecoration(
                // color: Color(0xFFF1F1F5),
                color: Theme.of(context).colorScheme.outline
              ),
            ),
            Container(
              height: 70,
              margin: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF6663E8),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('함께하고 싶은 친구에게 공유해보세요.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ProfileBottomMenuWidget(
                    onTap: () => NavigatorHelper.push(context, const LanguageSettingsWidget()),
                    icon: Icons.language,
                    text: 'Language',
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      if (ref.watch(loginProvider) != null) {
                        return ProfileBottomMenuWidget(
                          onTap: () {
                            Alert.confirmMessageTemplate(
                              context: context,
                              onPressedText: '로그아웃',
                              onPressed: () {
                                ref.watch(loginProvider.notifier).logout();
                              },
                              message: '로그아웃 하시겠습니까?');
                          },
                          icon: Icons.logout,
                          text: '로그아웃',
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserProfile(UserProfile profile) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    NavigatorHelper.push(context, const ProfileEditPage());
                  },
                  child: Stack(
                      children: [
                        (profile.image == null)
                            ? EmptyProfileImage(context)
                            : Container(
                                width: 100, height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: profile.image
                              ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: SvgPicture.asset('assets/icons/edit.svg', width: 30,),
                        ),
                      ]
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('${profile.name}',
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              (profile.sex == 'M')
                                  ? Icon(Icons.male, color: Color(0xFF5278FF),)
                                  : Icon(Icons.female, color: Color(0xFFFF6666),)
                            ],
                          ),
                          Text('${profile.birth}',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      if (profile.intro != null)
                        Text('${profile.intro}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                ExtraInfoWidget(
                  count: profile.groupCount,
                  title: 'profile'.tr(gender: 'myGroup',),
                ),
                ExtraInfoWidget(
                  count: profile.inviteCount,
                  title: 'profile'.tr(gender: 'inviteGroup'),
                ),
                ExtraInfoWidget(
                  count: profile.likeCount,
                  title: 'profile'.tr(gender: 'favoriteGroup'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container EmptyProfile(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
      child: Row(
        children: [
          EmptyProfileImage(context),
          const SizedBox(width: 20,),
          GestureDetector(
            onTap: () {
              Alert.requireLogin(context);
            },
            child: Row(
              children: [
                Text('goToLogin',
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600
                  ),
                ).tr(),
                SizedBox(width: 5,),
                Icon(Icons.arrow_forward_ios, size: 18,)
              ],
            ),
          ),
        ],
      ),
    );
  }



  @override
  bool get wantKeepAlive => true;
}

Widget EmptyProfileImage(BuildContext context) {
  return userProfile(context, diameter: 100, image: null);
}


class ExtraInfoWidget extends StatelessWidget {

  final int count;
  final String title;

  const ExtraInfoWidget({super.key, required this.count, required this.title});


  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Text(count.toString(),  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
          Text(title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}


class ProfileBottomMenuWidget extends StatelessWidget {

  final GestureTapCallback onTap;
  final IconData icon;
  final String text;

  const ProfileBottomMenuWidget({super.key, required this.onTap, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.grey,),
            SizedBox(width: 20,),
            Expanded(
              flex: 1,
              child: Text(text, style: TextStyle(fontSize: 16),),
            ),
            Icon(Icons.arrow_forward_ios, size: 15, color: Colors.grey,)
          ],
        ),
      ),
    );
  }
}


