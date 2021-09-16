import 'package:encommentt/pages/add.dart';
import 'package:flutter/material.dart';

class WriteComment extends StatefulWidget {
  WriteComment(String videoId);

  @override
  _WriteCommentState createState() => _WriteCommentState();
}

class _WriteCommentState extends State<WriteComment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Text(videoId)),
    );
  }
}
