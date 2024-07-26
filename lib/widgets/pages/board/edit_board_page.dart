

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sport/api/api_result.dart';
import 'package:flutter_sport/api/board/board_service.dart';
import 'package:flutter_sport/common/alert.dart';
import 'package:flutter_sport/common/image.dart';
import 'package:flutter_sport/models/board/board_detail.dart';
import 'package:flutter_sport/models/board/board_type.dart';
import 'package:flutter_sport/models/club/authority.dart';
import 'package:flutter_sport/models/upload_image.dart';
import 'package:flutter_sport/widgets/pages/common/image_detail_view.dart';

class EditBoardWidget extends StatefulWidget {

  final int clubId;
  final BoardDetail boardDetail;
  final Authority? authority;

  const EditBoardWidget({super.key, required this.clubId, required this.boardDetail, required this.authority});

  @override
  State<EditBoardWidget> createState() => _EditBoardWidgetState();
}

class _EditBoardWidgetState extends State<EditBoardWidget> {

  late TextEditingController _titleController;
  late TextEditingController _contentController;
  List<UploadImage> uploadImages = [];

  String? _titleErrorText;
  String? _contentErrorText;

  selectBoardType(BoardType boardType) => setState(() => this.boardType = boardType);
  _titleError(String text) => setState(() => _titleErrorText = text);
  _contentError(String text) => setState(() => _contentErrorText = text);

  late BoardType boardType;

  setBoardType(BoardType selectBoardType) {
    setState(() {
      boardType = selectBoardType;
    });
  }

  selectImages() async {
    List<UploadImage> images = await ImagePick().getMulti();
    uploadImages.addAll(images);
    setState(() {});
  }

  removeImage(int index) {
    setState(() {
      uploadImages.removeAt(index);
    });
  }

  _submit() async {
    if (!_valid()) return;

    ResponseResult result = await BoardService.createBoard(
      clubId: widget.clubId,
      images: uploadImages,
      boardType: boardType!,
      title: _titleController.text,
      content: _contentController.text,
    );

    print(result.resultCode);

    if (result.resultCode == ResultCode.OK) {
      Navigator.pop(context);
      Alert.message(
        context: context,
        text: Text('게시글이 수정되었습니다.'),
        onPressed: () {
        }
      );
    } else if (result.resultCode == ResultCode.CLUB_NOT_EXISTS) {
      Alert.message(
        context: context,
        text: Text('존재하지 않는 모임이니다,'),
        onPressed: () {
          Navigator.pop(context);
        }
      );
    } else if (result.resultCode == ResultCode.CLUB_NOT_OWNER) {
      Alert.message(
        context: context,
        text: Text('모임장만 공지사항을 등록할 수 있습니다.'),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } else if (result.resultCode == ResultCode.INVALID_DATA) {
      _valid();
    } else {
      Alert.message(context: context, text: Text('알 수 없는 오류가 발생했습니다.'));
    }
  }

  bool _valid() {
    return _authorityValid() && _categoryValid() && _titleValid() && _contentValid();
  }

  bool _authorityValid() {
    if (widget.authority == null) {
      Alert.message(
          context: context,
          text: Text('모임장만 공지사항을 등록할 수 있습니다.'),
          onPressed: () {
            Navigator.pop(context);
          }
      );
      return false;
    }
    return true;
  }
  bool _categoryValid() {
    if (boardType == null || boardType == BoardType.ALL) {
      Alert.message(
        context: context,
        text: Text('카테고리를 선택해주세요.'),
        onPressed: () {
          showBottomActionSheet(context, setBoardType, widget.authority!);
        }
      );
      return false;
    }
    if (boardType == BoardType.NOTICE && !widget.authority!.isOwner()) {
      Alert.message(
        context: context,
        text: Text('모임장만 공지사항을 등록할 수 있습니다.'),
        onPressed: () {
          Navigator.pop(context);
        }
      );
      return false;
    }
    return true;
  }
  bool _titleValid() {
    final title = _titleController.text;
    if (title.isEmpty) {
      _titleError('제목을 입력해주세요.');
      return false;
    } else if (title.length < 3) {
      _titleError('제목을 3자 이상 입력해주세요.');
      return false;
    } else if (title.length > 20) {
      _titleError('제목은 20자까지 가능합니다.');
      return false;
    }
    return true;
  }
  bool _contentValid() {
    final content = _contentController.text;
    if (content.length > 300) {
      _contentError('소개글은 300자 까지 가능합니다.');
      return false;
    }
    return true;
  }

  @override
  void initState() {
    if (widget.authority == null) {
      Navigator.pop(context);
      Alert.message(context: context, text: Text('잘못된 접근입니다.'));
    }
    _titleController = TextEditingController();
    _contentController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showBottomActionSheet(context, setBoardType, widget.authority!);
    });
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('글쓰기',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
            letterSpacing: 1
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              _submit();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              child: Text('등록',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.displayLarge!.fontSize,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.1
                ),
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

          return SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              selectImages();
                            },
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.outlineVariant,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add,
                                      size: 40,
                                      color: Theme.of(context).colorScheme.tertiary,
                                    ),
                                    const SizedBox(height: 5,),
                                    Text('눌러서 선택',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.tertiary,
                                        fontSize: Theme.of(context).textTheme.displaySmall!.fontSize
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) => const SizedBox(width: 10,),
                            itemCount: uploadImages.length,
                            itemBuilder: (context, index) {

                              UploadImage uploadImage = uploadImages[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) {
                                      return ImageDetailView(image: uploadImage.image);
                                    },
                                  ));
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context).colorScheme.outlineVariant,
                                          width: 1,
                                        ),
                                      ),
                                      child: uploadImage.image,
                                    ),

                                    Positioned(
                                      top: 10, right: 10,
                                      child: GestureDetector(
                                        onTap: () {
                                          removeImage(index);
                                        },
                                        child: Icon(Icons.cancel,),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    decoration: const BoxDecoration(),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15 + keyboardHeight),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.grid_view_rounded, size: 25,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(width: 5,),
                                Text('카테고리',
                                  style: TextStyle(
                                    fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),

                            GestureDetector(
                              onTap: () {
                                showBottomActionSheet(context, setBoardType, widget.authority!);
                              },
                              child: Container(
                                constraints: const BoxConstraints(minWidth: 150),
                                decoration: const BoxDecoration(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (boardType != null)
                                      Text('groupBoardMenus',
                                      style: TextStyle(
                                          fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).colorScheme.primary
                                      ),
                                    ).tr(gender: boardType!.lang),
                                    const SizedBox(width: 10,),
                                    const Icon(Icons.arrow_forward_ios, size: 20,)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 40,),
                        TextField(
                          controller: _titleController,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: Color(0xFFD9E7F6),
                                  width: 2
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Color(0xFFFA5252),
                                    width: 2
                                )
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: Color(0xFFFA5252),
                                  width: 2
                              ),
                            ),
                            hintText: '제목을 입력해주세요.',
                            errorText: _titleErrorText,
                            errorStyle: TextStyle(
                              color: Color(0xFFFA5252),
                            ),
                          ),
                          maxLength: 20,
                        ),
                        const SizedBox(height: 20,),
                        TextField(
                          controller: _contentController,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: Color(0xFFD9E7F6),
                                  width: 2
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Color(0xFFFA5252),
                                    width: 2
                                )
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: Color(0xFFFA5252),
                                  width: 2
                              ),
                            ),
                            hintText: '게시물 내용을 입력해주세요.',
                            errorText: _contentErrorText,
                            errorStyle: TextStyle(
                              color: Color(0xFFFA5252),
                            ),
                          ),
                          maxLines: 8,
                          maxLength: 200,
                        ),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void showBottomActionSheet(BuildContext context, Function(BoardType) setBoardType, Authority authority) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('cancel').tr(),
        ),
        actions: BoardType.getBoardMenus(authority).map((board) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setBoardType(board);
              Navigator.of(context).pop();
            },
            child: Text('groupBoardMenus',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ).tr(gender: board.lang),
          );
        }).toList(),
      );
    },
  );
}

