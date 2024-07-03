
import 'package:flutter/material.dart';
import 'package:flutter_sport/widgets/pages/search_page.dart';

class SoccerPage extends StatelessWidget {
  const SoccerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('풋볼'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.search, size: 30,),
              onPressed: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage(),))
              },
            ),
          )
        ],
      ),
      body: Container(
        child: Text('asdfasdf'),
      ),
    );
  }
}
