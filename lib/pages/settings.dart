import 'package:encommentt/pages/main_activity.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

ElevatedButton logout(context) {
  return ElevatedButton(
    onPressed: () {
      googleSignIn.signOut();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MainActivity()));
    },
    child: Text("Logout"),
  );
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage(googleSignIn.currentUser!.photoUrl.toString()),
              ),
              SizedBox(width: 10),
              Text(
                googleSignIn.currentUser!.displayName.toString(),
              ),
              logout(context)
            ],
          )
        ],
      ),
    )));
  }
}
