
import 'package:flutter/material.dart';
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
              Text(formatDate(date), style: const TextStyle(fontSize: 12, color: Color(0xFF797979)),)
            ],
          )
        ],
      ),
    );
  }

  String formatDate(String dateString) {
    final now = DateTime.now();
    final date = DateTime.parse(dateString);
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays == 1) {
      return '어제 ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else if (difference.inDays < 365) {
      return DateFormat('M월 dd일 HH:mm').format(date);
    } else {
      return DateFormat('yyyy년 MM월 dd일 HH:mm').format(date);
    }
  }
}
