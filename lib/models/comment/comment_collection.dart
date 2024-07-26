

import 'dart:collection';

import 'package:flutter_sport/models/comment/comment.dart';

class CommentCollection {

  int totalCount = 0;
  final Map<Comment, List<Comment>> _data;

  CommentCollection() : _data = LinkedHashMap();

  void addAll(List<Comment> comments) {
    if (comments.isEmpty) return;
    for (var comment in comments) {
      if (!isDistinct(comment)) {
        add(comment);
      }
    }
  }

  bool isDistinct(Comment compare) {
    if (_data.containsKey(compare)) return true;
    for (var replyList in _data.values) {
      for (var comment in replyList) {
        if (comment.commentId == compare.commentId) return true;
      }
    }
    return false;
  }

  void add(Comment comment) {
    if (comment.parentCommentId == null) {
      _data.putIfAbsent(comment, () => []);
      return;
    }

    for (Comment key in _data.keys) {
      if (key.commentId == comment.parentCommentId) {
        List<Comment> reply = _data[key]!;
        reply.add(comment);
        return;
      }
    }
  }

  int size() {
    int counter = _data.length;

    for (var o in _data.values) {
      counter += o.length;
    }
    return counter;
  }

  List<Comment> keys() {
    return _data.keys.toList();
  }

  List<Comment> get(Comment comment) {
    return _data[comment]!;
  }

  void clear() {
    _data.clear();
  }
}