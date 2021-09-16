import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final TextEditingController _linkController = TextEditingController();

late Map<String, dynamic> ytDetails;
late String link;
bool validYt = false;

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        child: TextField(
                          controller: _linkController,
                          decoration: const InputDecoration(
                              labelText: "Link", border: OutlineInputBorder()),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        child: ElevatedButton(
                          child: Text("Validate"),
                          onPressed: validateUrl,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      validYt ? Text("Valid link") : Text("Inalid link")
                    ],
                  ),
                  Row(children: [
                    validYt
                        ? Container(
                            child: Column(children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 200,
                                child:
                                    Image.network(ytDetails['thumbnail_url']),
                              ),
                              Text(ytDetails['title']),
                              Text(ytDetails['author_name'])
                            ]),
                          )
                        : Container(
                            child: null,
                          ),
                  ])
                ],
              ))),
    );
  }

  Future<dynamic> validateUrl() async {
    setState(() {
      link = _linkController.text;
    });
    String embedUrl = "https://www.youtube.com/oembed?url=$link&format=json";
    var res = await http.get(Uri.parse(embedUrl));
    print("get youtube detail status code: " + res.statusCode.toString());
    try {
      if (res.statusCode == 200) {
        setState(() {
          validYt = true;
        });
        setState(() {
          ytDetails = jsonDecode(res.body);
        });
        print(ytDetails);
      } else {
        setState(() {
          validYt = false;
        });
      }
    } on FormatException catch (e) {
      print('invalid JSON' + e.toString());
      setState(() {
        validYt = false;
      });
    }
  }
}
