

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/models/alert.dart';
import 'package:flutter_sport/models/club/club_data.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GroupDetailHomeWidget extends StatefulWidget {

  final ClubDetail club;
  const GroupDetailHomeWidget({super.key, required this.club});

  @override
  State<GroupDetailHomeWidget> createState() => _GroupDetailHomeWidgetState();
}

class _GroupDetailHomeWidgetState extends State<GroupDetailHomeWidget> with AutomaticKeepAliveClientMixin {

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
                await Future.delayed(Duration(seconds: 2));
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
          GestureDetector(
            onTap: () {
              Alert.message(context: context, text: const Text('로그인이 필요합니다.'));

            },
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.blue,
                    color: Color(0xFF72A8E6),
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

