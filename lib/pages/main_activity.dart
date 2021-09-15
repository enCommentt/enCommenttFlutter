import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encommentt/model/user.dart';
import 'package:encommentt/pages/add.dart';
import 'package:encommentt/pages/explore.dart';
import 'package:encommentt/pages/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = FirebaseFirestore.instance.collection('users');
final DateTime timestamp = DateTime.now();
User? currentUser;

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  bool isAuth = false;
  late PageController pageController;
  int pageIndex = 0;
  bool loading = true;

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
    setState(() {
      loading = false;
    });
    print("isAuth: " + isAuth.toString());
    print("loading: " + loading.toString());
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
    googleSignIn.signInSilently(suppressErrors: true).then((account) {
      handleSignIn(account!);
    }).catchError((err) {
      print('Error signing in: $err');
    });
    setState(() {
      loading = false;
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

  createUserInFirestore() async {
    final GoogleSignInAccount? user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user!.id).get();
    if (!doc.exists) {
      usersRef.doc(user.id).set({
        "id": user.id,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "timestamp": timestamp
      });
      doc = await usersRef.doc(user.id).get();
    }
    currentUser = User.fromDocument(doc);
    print(currentUser);
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
          AppSettings(),
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
            BottomNavigationBarItem(
                icon: Icon(Icons.explore), label: "Explore"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  size: 35.0,
                ),
                label: "Add"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ]),
    );
  }

  Container loadingUserScreen() {
    return Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 10.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Color(0xffbe0000)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (loading == false) {
      return loadingUserScreen();
    } else if (isAuth == true && loading == false) {
      return signedInUser();
    } else if (isAuth == false && loading == false) {
      return signedOutUser();
    } else {
      return loadingUserScreen();
    }
  }
}
