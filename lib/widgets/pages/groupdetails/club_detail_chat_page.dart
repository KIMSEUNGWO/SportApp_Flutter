import 'package:flutter/material.dart';
import 'package:flutter_sport/models/club/club_data.dart';

class ClubDetailChatWidget extends StatelessWidget {

  final ClubDetail club;

  const ClubDetailChatWidget({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    return Text('채팅페이지');
  }
}
