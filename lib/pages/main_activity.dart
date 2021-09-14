import 'package:encommentt/pages/add.dart';
import 'package:encommentt/pages/explore.dart';
import 'package:encommentt/pages/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  bool isAuth = false;
  late PageController pageController;
  int pageIndex = 0;

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      print(account);
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  login() {
    googleSignIn.signIn();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account!);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account!);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Scaffold signedOutUser() {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.png"),
                Text(
                  "enCommentt",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      fontSize: 30),
                ),
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Comment on YouTube videos with disabled comments on the Internet",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: "Poppins"),
                    )),
                Container(
                  padding: EdgeInsets.only(top: 60),
                  child: ElevatedButton(
                    onPressed: () {
                      print("Sign in");
                      login();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xffbe0000))),
                    child: Text(
                      "Sign in",
                      style: TextStyle(fontFamily: "Poppins"),
                    ),
                  ),
                )
              ],
            )));
  }

  Scaffold signedInUser() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Explore(),
          Add(),
          Settings(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.explore)),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                size: 35.0,
              ),
            ),
            BottomNavigationBarItem(icon: Icon(Icons.settings)),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isAuth) {
      return signedInUser();
    } else {
      return signedOutUser();
    }
  }
}
