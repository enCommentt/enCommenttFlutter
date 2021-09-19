import 'package:encommentt/pages/add.dart';
import 'package:encommentt/pages/main_activity.dart';
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
      mute: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              ytDetails['title'],
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        googleSignIn.currentUser!.photoUrl.toString()),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width - 75,
                      child: TextField(
                        decoration: InputDecoration(
                            labelText: "Add a public comment",
                            border: InputBorder.none),
                      ))
                ],
              ))
        ])));
  }
}
