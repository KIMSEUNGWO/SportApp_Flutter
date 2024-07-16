import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/common/local_storage.dart';
import 'package:flutter_sport/models/region_data.dart';
import 'package:flutter_sport/widgets/lists/small_list_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController _textController = TextEditingController();

  Set<String> recentlySearchWord = {};
  bool recentlySearchIsDisable = false;

  addWord(String word) {
    setState(() {
      recentlySearchWord = {word, ...recentlySearchWord};
    });
  }
  deleteWord(String word) {
    setState(() {
      recentlySearchWord.remove(word);
    });
  }
  deleteAllWord() {
    setState(() {
      recentlySearchWord = {};
      recentlySearchIsDisable = true;
    });
  }

  textClear() {
    _textController.clear();
    setState(() {
      recentlySearchIsDisable = false;
    });
  }

  initRecentlySearchWord() async {
    Set<String> words = Set.of(await LocalStorage.getRecentlySearchWords());
    setState(() => recentlySearchWord = words);
  }

  onTapRecentlyWord(String word) {
    _textController.text = word;
    onChange(word);
    onSubmit(word);
  }

  onSubmit(String word) {
    addWord(word); // 최근
    print('onSubmit $word' );// 검색어 추가
  }

  onChange(String word) {
    setState(() => recentlySearchIsDisable = word.isNotEmpty);
  }

  @override
  void initState() {
    initRecentlySearchWord();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    LocalStorage.saveByRecentlySearchWord(recentlySearchWord.toList());
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFE3E3E3),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  onSubmitted: (value) => onSubmit(value),
                  onChanged: (value) => onChange(value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'alert'.tr(gender: 'placeholder_groupSearch'),
                    hintStyle: TextStyle(
                      color: Color(0xFF908E9B),
                    ),
                  ),
                  autofocus: true,
                ),
              ),
              SizedBox(width: 10,),
              if (_textController.text.isNotEmpty)
                GestureDetector(
                  onTap: () => textClear(),
                  child: Icon(Icons.cancel,
                    color: Color(0xFF9F9B9B),
                    size: 25,
                  ),
                ),
                SizedBox(width: 10,),

              Icon(Icons.search,
                color: Color(0xFF9F9B9B),
                size: 30,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchCondition(),
          if (!recentlySearchIsDisable && recentlySearchWord.isNotEmpty)
            Container(
              constraints: BoxConstraints(
                minHeight: 220,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RecentlySearchWord(
                words : recentlySearchWord.toList(),
                addWord : addWord,
                deleteWord : deleteWord,
                deleteAllWord : deleteAllWord,
                onTap : onTapRecentlyWord,
              ),
            ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  SmallListWidget(
                    id: 1,
                    image: Image.asset('assets/groupImages/sample1.jpeg', fit: BoxFit.fill,),
                    title: '野球団野球団野球団野球団野球団野球団野球団野球団',
                    intro: '新人さんを待っています',
                    sportType: '야구',
                    region: Region.SHINJUKU,
                    personCount: 3,
                  ),
                  SmallListWidget(
                    id: 1,
                    image: Image.asset('assets/groupImages/sample1.jpeg', fit: BoxFit.fill,),
                    title: '野球団野球団野球団野球団野球団野球団野球団野球団',
                    intro: '新人さんを待っています',
                    sportType: '야구',
                    region: Region.ITABASHI,
                    personCount: 3,
                  ),
                  SmallListWidget(
                    id: 1,
                    image: Image.asset('assets/groupImages/sample1.jpeg', fit: BoxFit.fill,),
                    title: '野球団野球団野球団野球団野球団野球団野球団野球団',
                    intro: '新人さんを待っています',
                    sportType: '야구',
                    region: Region.CHIYODA,
                    personCount: 3,
                  ),
                  SmallListWidget(
                    id: 1,
                    image: Image.asset('assets/groupImages/sample1.jpeg', fit: BoxFit.fill,),
                    title: '野球団野球団野球団野球団野球団野球団野球団野球団',
                    intro: '新人さんを待っています',
                    sportType: '야구',
                    region: Region.ITABASHI,
                    personCount: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentlySearchWord extends StatefulWidget {

  final List<String> words;
  final Function(String word) addWord;
  final Function(String word) deleteWord;
  final Function() deleteAllWord;
  final Function(String word) onTap;

  const RecentlySearchWord({super.key, required this.words, required this.addWord, required this.deleteWord, required this.deleteAllWord, required this.onTap});



  @override
  State<RecentlySearchWord> createState() => _RecentlySearchWordState();
}

class _RecentlySearchWordState extends State<RecentlySearchWord> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('최근 검색어',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            GestureDetector(
              onTap: () => widget.deleteAllWord(),
              child: Text('전체 지우기',
                style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15,),
        GridView.builder(
          shrinkWrap: true, // chid 위젯의 크기를 정해주지 않아싿면 true로 지정해줘야한다.
          physics: NeverScrollableScrollPhysics(), // 스크롤 금지
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 30,
            mainAxisExtent: 30,
            mainAxisSpacing: 10

          ),
          itemCount: min(widget.words.length, 6),

          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onTap(widget.words[index]),
                    child: Text(widget.words[index],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                GestureDetector(
                  onTap: () {
                    widget.deleteWord(widget.words[index]);
                  },
                  child: Icon(Icons.close),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}


class SearchCondition extends StatelessWidget {
  const SearchCondition({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 20,),
            Container(
              margin: EdgeInsets.only(right: 7),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              decoration: BoxDecoration(
                  border: Border.all(
                    color : Color(0xFFACA5A5),
                  ),
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Text('야구',
                style: TextStyle(
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 7),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              decoration: BoxDecoration(
                  border: Border.all(
                    color : Color(0xFFACA5A5),
                  ),
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Text('시부야구',
                style: TextStyle(
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
            const SizedBox(width: 10,),
          ],
        ),
      ),
    );
  }
}
