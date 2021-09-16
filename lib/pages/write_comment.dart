import 'package:encommentt/pages/add.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WriteComment extends StatefulWidget {
  WriteComment(String videoId);

  @override
  _WriteCommentState createState() => _WriteCommentState();
}

class _WriteCommentState extends State<WriteComment> {
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: videoId,
    flags: YoutubePlayerFlags(
      autoPlay: true,
      mute: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    )));
  }
}
