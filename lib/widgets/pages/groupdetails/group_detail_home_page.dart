

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/group/club_service.dart';
import 'package:flutter_sport/common/alert.dart';
import 'package:flutter_sport/common/login_checker.dart';
import 'package:flutter_sport/models/club/authority.dart';
import 'package:flutter_sport/models/club/club_data.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GroupDetailHomeWidget extends ConsumerStatefulWidget {

  final ClubDetail club;
  final Function() reloadClub;
  const GroupDetailHomeWidget({super.key, required this.club, required this.reloadClub});

  @override
  ConsumerState<GroupDetailHomeWidget> createState() => _GroupDetailHomeWidgetState();
}

class _GroupDetailHomeWidgetState extends ConsumerState<GroupDetailHomeWidget> with AutomaticKeepAliveClientMixin {

  late ClubDetail club;
  bool joinBtnDisabled = false;

  bool login() {
    return LoginChecker.loginCheck(context, ref);
  }

  joinClub() async {
    joinDisabled(false);
    ResponseResult result = await ClubService.joinClub(clubId: club.id);
    if (result.resultCode == ResultCode.OK) {
      widget.reloadClub();
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
  void initState() {
    club = widget.club;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverRefreshControl(
              refreshTriggerPullDistance: 100.0,
              refreshIndicatorExtent: 80.0,
              onRefresh: () async {
                // 위로 새로고침
                await widget.reloadClub();
              },
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: widget.club.image == null ? const BoxDecoration(color: Color(0xFFF1F1F5)) : const BoxDecoration(),
                width: double.infinity,
                height: 200,
                child: widget.club.image ?? Center(
                  child: SvgPicture.asset('assets/icons/emptyGroupImage.svg',
                  width: 40, height: 40, color: Color(0xFF878181),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.club.title,
                      style: TextStyle(
                        fontSize: 21,
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
                      Text(widget.club.intro!, style: TextStyle(fontSize: 14),), // 본문내용
                  ],
                )
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 100,),)
          ],
        ),
          if (club.authority == null)
            (club.personCount < club.maxPerson)
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
                  Navigator.pop(context);
                  joinClub();
                },
                message: Text('이 모임에 참여하시나요?')
              );
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.blue,
                    color: joinBtnDisabled ? Colors.grey : Color(0xFF72A8E6),
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
        color: Color(0xFFDFDFDF),
      ),
      child: Text(title,
        style: TextStyle(
          color: Color(0xFF605B5B),
          fontSize: 12
        ),
      ),
    );
  }
}

