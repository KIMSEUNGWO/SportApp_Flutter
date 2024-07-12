
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/api/api_service.dart';
import 'package:flutter_sport/models/alert.dart';
import 'package:intl/intl.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notifiers/login_notifier.dart';


class RegisterWidget extends ConsumerStatefulWidget {
  const RegisterWidget({super.key});

  @override
  ConsumerState<RegisterWidget> createState() => _RegisterWidgetState();

}

class _RegisterWidgetState extends ConsumerState<RegisterWidget> {

  int introCurrentCount = 0;
  int introMaxCount = 30;

  int nicknameMin = 2;
  int nicknameCurrentLength = 0;
  int nicknameMax = 8;
  String sex = 'M';
  DateTime _selectedDate = DateTime(2000, 1, 1);
  DateTime? _confirmDate = DateTime(2000, 1, 1);

  bool isLoading = false;
  bool? isDistinct;
  bool isValidNicknameLength = true;


  late TextEditingController _textNicknameController;
  late TextEditingController _textIntroController;
  late TextEditingController _dateController;

  validLengthText(String text) {
    if (text.length > introMaxCount) {
      text = text.substring(0, introMaxCount);
      _textIntroController.text = text;
    }

    setState(() {
      introCurrentCount = text.length;
    });
  }

  bool validNicknameLength(String text) {
    if (text.length > nicknameMax) {
      text = text.substring(0, nicknameMax);
      _textNicknameController.text = text;
    }
    bool valid = text.length >= nicknameMin && text.length <= nicknameMax;
    setState(() {
      isValidNicknameLength = valid;
    });
    return valid;
  }

  changeSex(String change) {
    setState(() {
      sex = change;
    });
  }

  distinctNickname() {
    if (isLoading) return;

    setState(() => isLoading = true);
    tryDistinctNickname();
    setState(() => isLoading = false);

  }

  tryDistinctNickname() async {
    isDistinct = await ApiService.isDistinctNickname(_textNicknameController.text);
    setState(() {

    });
  }

  Future<void> _selectDate(BuildContext context) async {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true, // showCupertinoDialog 영역 외에 눌렀을 때 닫게 해줌
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment
              .bottomCenter, //특정 위젯이 어디에 정렬을 해야되는지 모르면 height값줘도 최대한에 사이즈를 먹음
          child: Container(
            color: Colors.white,
            height: 300,
            child: Column(
              children: [
                CupertinoButton(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('완료'),
                  ),
                  onPressed: () {
                    _confirmDate = _selectedDate;
                    _dateController.text = DateFormat('yyyy-MM-dd').format(_confirmDate!);
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date, //CupertinoDatePickerMode에서 일시, 시간 등 고름
                    initialDateTime: _selectedDate,
                    maximumYear: DateTime.now().year - 16,
                    onDateTimeChanged: (DateTime date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _textNicknameController = TextEditingController();
    _textIntroController = TextEditingController();
    _dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(_selectedDate));
    super.initState();
  }

  @override
  void dispose() {
    _textNicknameController.dispose();
    _textIntroController.dispose();
    _dateController.dispose();
    registerClear();
    super.dispose();
  }

  registerClear() async {
    await ApiService.registerClear();
  }

  submit(BuildContext context) async {
    bool isValidNickname = validNicknameLength(_textNicknameController.text);
    if (!isValidNickname) {
      Alert.message(context: context, text: Text('닉네임을 다시 작성해주세요.'), onPressed: () {},);
      _textNicknameController.text = '';
      return;
    }
    await tryDistinctNickname();
    if (isDistinct != null && isDistinct!) {
      Alert.message(context: context, text: Text('누군가 닉네임을 가로챘어요. 다시 설정해주세요.'), onPressed: () {} );
      return;
    }
    if (sex != 'M' && sex != 'F') {
      Alert.message(context: context, text: Text('성별을 다시 선택해주세요.'), onPressed: (){});
      setState(() => sex = 'M');
      return;
    }

    if (_confirmDate == null) {
      Alert.message(context: context, text: Text('생년월일을 선택해주세요.'), onPressed: (){});
      return;
    }
    final response = await ref.watch(loginProvider.notifier).register(
        nickname: _textNicknameController.text,
        intro: _textIntroController.text,
        sex: sex,
        birth: DateFormat('yyyy-MM-dd').format(_confirmDate!)
    );

    if (response) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        actions: [
          GestureDetector(
            onTap: () => submit(context),
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text('완료',
                style: TextStyle(
                  fontSize: 19,
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Text('닉네임',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textNicknameController,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                    onChanged: (text) {
                      setState(() {
                        isDistinct = null;
                        validNicknameLength(text);
                      });
                    },
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFE4E2E2), width: 1.5),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFE4E2E2), width: 1.5),
                        ),
                        hintText: '사용할 닉네임을 적어주세요.'
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => distinctNickname(),
                  child: Container(
                    width: 100,
                    height: 50,
                    margin: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      color: !isLoading ? Color(0xFF72A8E6) : Colors.grey,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text('중복확인',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
            if (!isValidNicknameLength)
              Text('닉네임은 2~8자만 가능합니다.',
                style: TextStyle(
                    color: Color(0xFFFF4F4F)
                ),
              ),

            if (isDistinct != null)
              Text(isDistinct! ? '중복된 닉네임 입니다.' : '사용 가능한 닉네임 입니다.',
                style: TextStyle(
                  color: isDistinct! ? Color(0xFFFF4F4F) : Color(0xFF2EA637)
                ),
              ),
            SizedBox(height: 20,),
            Text('자기소개',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextFormField(
              controller: _textIntroController,

              keyboardType: TextInputType.multiline,
              onChanged: (text) => validLengthText(text),
              maxLines: null,
              style: const TextStyle(fontSize: 17),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE4E2E2), width: 1.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE4E2E2), width: 1.5),
                ),
                hintText: '자기소개를 적어주세요.',
                counterText: '$introCurrentCount / $introMaxCount',
                counterStyle: const TextStyle(fontSize: 14),
              ),
            ),

            SizedBox(
              height: 10,
            ),

            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('성별',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // color: Color(0xFFE9F1FA),
                        color: Color(0xFFE6E6E6),
                      ),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () => changeSex('F'),
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: (sex == 'F') ? myBoxDecoration : youBoxDecoration ,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                child: Center(
                                  child: Text('여자',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: (sex == 'F') ? myTextColor : youTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () => changeSex('M'),
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: (sex == 'M') ? myBoxDecoration : youBoxDecoration,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                child: Center(child: Text('남자',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: (sex == 'M') ? myTextColor : youTextColor,
                                  ),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 15,),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('생년월일',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 15,),
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // color: Color(0xFFE9F1FA),
                          color: Color(0xFFE6E6E6),
                        ),
                        child: TextField(
                          controller: _dateController,
                          readOnly: true,
                          style: TextStyle(
                            color: Color(0xFF3E3E3E),
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFFFFF).withOpacity(0)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFFFFF).withOpacity(0)),
                            ),
                          ),
                          onTap: () => _selectDate(context),
                        ),
                      )
                    ],
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }

  BoxDecoration myBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    // color: Color(0xFFD2E7FE),
    color: Color(0xFFFFFFFF),
  );
  BoxDecoration youBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
  );

  // Color myTextColor = Color(0xFF3E3E3E);
  // Color youTextColor = Color(0xFF7E7E7E);
  Color myTextColor = Color(0xFF000000);
  Color youTextColor = Color(0xFF959595);
}
