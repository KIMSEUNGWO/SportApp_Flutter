
import 'package:flutter/material.dart';
import 'package:flutter_sport/common/dateformat.dart';
import 'package:intl/intl.dart';

class NotificationWidget extends StatelessWidget {

  final String id, thumb, title, date;

  const NotificationWidget({super.key, required this.id, required this.thumb, required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
            ),
            child: Image.network(
              thumb, headers: const {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",},
              width: 60, height: 60,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
              Text('13분전', style: const TextStyle(fontSize: 12, color: Color(0xFF797979)),)
            ],
          )
        ],
      ),
    );
  }

}
