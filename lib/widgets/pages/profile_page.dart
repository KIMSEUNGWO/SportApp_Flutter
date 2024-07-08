import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/models/component.dart';
import 'package:flutter_sport/models/login_notifier.dart';
import 'package:flutter_sport/widgets/pages/language_settings.dart';
import 'package:flutter_sport/widgets/pages/login_page.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {


  @override
  Widget build(BuildContext context) {
    print('??');
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Icon(Icons.settings, size: 30,)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 회원정보 위젯
            Consumer(
              builder: (context, ref, child) {
                final isLogin = ref.watch(loginProvider);
                if (isLogin) {
                  return Container(
                    height: 180,
                    child: FutureBuilder(
                      future: ApiService.getProfile(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print('재렌더링?');
                          return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                              child: Row(
                                children: [
                                  Stack(
                                      children: [
                                        (snapshot.data!.image == null)
                                          ? EmptyProfileImage()
                                          : Container(
                                            width: 100, height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                            ),
                                            clipBehavior: Clip.hardEdge,

                                            child: Image.network('${ApiService.server}/images/profile/${snapshot.data!.image}', fit: BoxFit.fill,),
                                          ),
                                        Positioned(
                                          bottom: 0, right: 0,
                                          child: GestureDetector(
                                            onTap: () => print('asdf'),
                                            child: SvgPicture.asset('assets/icons/edit.svg', width: 30,),
                                          ),
                                        ),
                                      ]
                                  ),
                                  const SizedBox(width: 20,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('${snapshot.data!.name}',
                                            style: TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          (snapshot.data!.sex == 'M')
                                            ? Icon(Icons.male, color: Color(0xFF5278FF),)
                                            : Icon(Icons.female, color: Color(0xFFFF6666),)
                                        ],
                                      ),
                                      Text('${snapshot.data!.birth}',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
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
                                    count: snapshot.data!.groupCount,
                                    title: '내 모임',
                                  ),
                                  ExtraInfoWidget(
                                    count: snapshot.data!.inviteCount,
                                    title: '초대받은 모임',
                                  ),
                                  ExtraInfoWidget(
                                    count: snapshot.data!.likeCount,
                                    title: '좋아요한 모임',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                        } else {
                          return Center(child: const CircularProgressIndicator());
                        }
                      },
                    ),
                  );
                } else {
                  return Container(
                    height: 180,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                          child: Row(
                            children: [
                              EmptyProfileImage(),
                              const SizedBox(width: 20,),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(context: context, builder: (context) {
                                    return LoginPageWidget();
                                  },);
                                },
                                child: Row(
                                  children: [
                                    Text('로그인하러 가기',
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Icon(Icons.arrow_forward_ios, size: 18,)
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
                                count: 0,
                                title: '내 모임',
                              ),
                              ExtraInfoWidget(
                                count: 0,
                                title: '초대받은 모임',
                              ),
                              ExtraInfoWidget(
                                count: 0,
                                title: '초대받음 모임',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),

            // 구분 위젯
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 20,
              decoration: const BoxDecoration(color: Color(0xFFF1F1F5)),
            ),
            // 배너 위젯
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
                          // color: Color(0xFF89FF06),
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
            // 메뉴 위젯
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageSettingsWidget(),)),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.language,
                            size: 20,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            flex: 1,
                            child: Text('Language',
                              style: TextStyle(
                                fontSize: 16
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                            size: 15,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container EmptyProfileImage() {
    return Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Color(0xFFB1ACAC),
            ),
            clipBehavior: Clip.hardEdge,
            child: Icon(Icons.person, size: 100, color: Color(0xFF979696),),
          );
  }



  @override
  bool get wantKeepAlive => true;
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
          Text(title,),
        ],
      ),
    );
  }
}

