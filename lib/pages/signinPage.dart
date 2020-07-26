import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labels_book/pages/items.dart';
import 'package:labels_book/pages/profile.dart';
import 'package:labels_book/pages/view_orders.dart';

import 'newhome.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = Firestore.instance.collection('Users');
final ordersRef = Firestore.instance.collection('orders');
final itemRef = Firestore.instance.collection('items');
final clientRef = Firestore.instance.collection('client');
final internalUserRef = Firestore.instance.collection('internalUser');

final DateTime timestamp = DateTime.now();

final GoogleSignInAccount googleUser = googleSignIn.currentUser;

class SiginPage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<SiginPage> {
  bool isAuth = false;
  int pageIndex = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();

    //Detects when user signin
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignin(account);
    }, onError: (err) {});
    //Re-authenticate user if app is open
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignin(account);
    }).catchError((err) {});
  }

  handleSignin(GoogleSignInAccount account) {
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
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(microseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          NewHome(),
          Items(),
          View_Orders(),
          Profile(profileId: googleUser?.id),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: Colors.lightBlueAccent,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.save_alt),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
            ),
          ]),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 90.0,
              backgroundImage: AssetImage('images/prezotech_logo.png'),
              backgroundColor: Colors.transparent,
            ),
            const Text(
              'Labels Book!',
              style: TextStyle(
                fontFamily: 'Lemonada',
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
              ),
            ),
            SizedBox(
                height: 01.0,
                width: 201.0,
                child: Divider(color: Colors.lightBlueAccent)),
            const Text(
              'by PREZOTECH',
              style: TextStyle(
                fontFamily: 'Lemonada',
                fontSize: 16.0,
//                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
              ),
            ),
            SizedBox(
                height: 01.0,
                width: 75.0,
                child: Divider(color: Colors.lightBlueAccent)),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () => login(),
              child: Container(
                height: 70.0,
                width: 301.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.teal,
                  image: DecorationImage(
                    image: AssetImage('images/g_signin.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }

  createUserInFirestore() async {
    //1) check if User exits

    final DocumentSnapshot doc = await usersRef.document(googleUser.id).get();
    if (!doc.exists) {
      //2) User not exits
      final username = googleUser.displayName;
      //3) set user to firestore
      usersRef.document(googleUser.id).setData({
        "id": googleUser.id,
        "username": username,
        "photoUrl": googleUser.photoUrl,
        "email": googleUser.email,
        "displayName": googleUser.displayName,
        "timestamp": timestamp
      });
    }
  }
}
