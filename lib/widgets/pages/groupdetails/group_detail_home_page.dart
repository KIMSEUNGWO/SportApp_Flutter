

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/club/club_service.dart';
import 'package:flutter_sport/common/alert.dart';
import 'package:flutter_sport/common/login_checker.dart';
import 'package:flutter_sport/models/club/authority.dart';
import 'package:flutter_sport/models/club/club_data.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_sport/models/user/club_member.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GroupDetailHomeWidget extends ConsumerStatefulWidget {

  final ClubDetail club;
  final Function() reloadClub;
  const GroupDetailHomeWidget({super.key, required this.club, required this.reloadClub});

  @override
  ConsumerState<GroupDetailHomeWidget> createState() => _GroupDetailHomeWidgetState();
}

class _GroupDetailHomeWidgetState extends ConsumerState<GroupDetailHomeWidget> with AutomaticKeepAliveClientMixin {

  bool joinBtnDisabled = false;

  bool login() {
    return LoginChecker.loginCheck(context, ref);
  }

  joinClub() async {
    joinDisabled(false);
    ResponseResult? result = await ClubService.joinClub(clubId: widget.club.id, context: context);
    if (result == null) return;
    if (result.resultCode == ResultCode.OK) {
      Alert.message(context: context, text: Text('가입이 완료되었습니다.'),
        onPressed: () {
          widget.reloadClub();
        }
      );
    } else if (result.resultCode == ResultCode.CLUB_JOIN_FULL) {
      Alert.message(context: context, text: Text('모임이 가득 찼습니다.'));
    } else if (result.resultCode == ResultCode.CLUB_ALREADY_JOINED) {
      Alert.message(context: context, text: Text('이미 참여 중인 모임입니다.'));
    } else if (result.resultCode == ResultCode.EXCEED_MAX_CLUB) {
      Alert.message(context: context, text: Text('참여할 수 있는 모임을 초과했습니다.'));
    }
  }

  joinDisabled(bool data) {
    setState(() {
      joinBtnDisabled = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Stack(
        children: [
          CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              CupertinoSliverRefreshControl(
                refreshTriggerPullDistance: 100.0,
                refreshIndicatorExtent: 80.0,
                onRefresh: () async {
                  // 위로 새로고침
                  await Future.delayed(const Duration(seconds: 1));
                  await widget.reloadClub();
                },
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: widget.club.image == null
                    ? BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                      )
                    : const BoxDecoration(),
                  width: double.infinity,
                  height: 200,
                  child: widget.club.image ?? Center(
                    child: SvgPicture.asset('assets/icons/emptyGroupImage.svg',
                    width: 40, height: 40, color: const Color(0xFF878181),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  constraints: BoxConstraints(
                    minHeight: 300
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.club.title,
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.displayLarge!.fontSize,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          height: 2
                        ),
                      ),
                      Row(
                        children: [
                          Tag(title: 'sportTitle'.tr(gender: widget.club.sport!.lang)),
                          const SizedBox(width: 10),
                          Tag(title: widget.club.region!.getLocaleName(EasyLocalization.of(context)!.locale),),
                          const SizedBox(width: 10),
                          Tag(title: 'person'.tr(args: [widget.club.personCount.toString()]),)
                        ],
                      ),
                      const SizedBox(height: 20,),
                      if (widget.club.intro != null)
                        Text(widget.club.intro!,
                          style: TextStyle(
                            fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500
                          ),
                        ), // 본문내용
                    ],
                  )
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  color: Theme.of(context).colorScheme.outline,
                  height: 30,
                ),
              ),

              ClubUserListWidget(clubId: widget.club.id,),

              const SliverToBoxAdapter(child: SizedBox(height: 100,),)
            ],
          ),
          if (widget.club.authority == null)
            (widget.club.personCount < widget.club.maxPerson)
              ? GestureDetector(
                onTap: joinBtnDisabled ? null : () {
                  bool hasLogin = login();
                  if (!hasLogin) {
                    return;
                  }
                  Alert.confirmMessageTemplate(
                    context: context,
                    onPressedText: '참여',
                    onPressed: () {
                      joinClub();
                    },
                    message: '이 모임에 참여하시나요?'
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.blue,
                        color: joinBtnDisabled
                          ? Colors.grey
                          : Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 55,
                      alignment: Alignment.center,
                      child: Text('참여하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 21,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),
          )
              : Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(2, 2),
                            color: Colors.grey,
                            blurRadius: 6
                        )
                      ],
                    ),
                    height: 55,
                    alignment: Alignment.center,
                    child: Text('마감',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 21,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
        ]
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Tag extends StatelessWidget {

  final String title;

  const Tag({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.secondaryContainer
      ),
      child: Text(title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}



class ClubUserListWidget extends StatefulWidget {

  final int clubId;

  const ClubUserListWidget({super.key, required this.clubId});

  @override
  State<ClubUserListWidget> createState() => _ClubUserListWidgetState();
}

class _ClubUserListWidgetState extends State<ClubUserListWidget> {

  List<ClubUser> _userList = [];


  _initClubUsers() async {
    _userList = await ClubService.getClubUsers(clubId: widget.clubId);
    setState(() {});
  }

  @override
  void initState() {
    _initClubUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Container(
            height: 1.5,
            decoration: BoxDecoration(
              // color: Color(0xFFE4DDDD),
                color: Theme.of(context).colorScheme.outline
            ),
          ),
          itemCount: _userList.length,
          itemBuilder: (context, index) {
            ClubUser clubUser = _userList[index];
            return ClubUserWidget(clubUser: clubUser);
          },
        ),
      ),
    );
  }
}

class ClubUserWidget extends StatelessWidget {

  final ClubUser clubUser;
  const ClubUserWidget({super.key, required this.clubUser,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40, height: 40,
            margin: const EdgeInsets.only(right: 10),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(100),
            ),
            child: clubUser.thumbnail ?? const Center(child: Icon(Icons.person, size: 30, color: const Color(0xFF878181),))
          ),
          const SizedBox(width: 5,),
          Expanded(
            child: Text(clubUser.nickname,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: Theme.of(context).textTheme.displayMedium!.fontSize
              ),
            ),
          ),
          const SizedBox(width: 15,),
          if (clubUser.authority != Authority.USER)
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
            ).tr(gender: clubUser.authority.lang),
          ),
        ],
      ),
    );
  }
}
