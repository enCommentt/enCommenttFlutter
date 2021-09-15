import 'package:flutter/material.dart';

AppBar header(context) {
  return AppBar(
    leading: Image.asset("assets/icons/header_icon.png"),
    title: Text(
      "enCommentt",
      style: TextStyle(
        color: Colors.white,
        fontFamily: "Poppins",
      ),
    ),
    backgroundColor: Theme.of(context).accentColor,
  );
}
