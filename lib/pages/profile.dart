import 'package:flutter/material.dart';
import 'package:labels_book/pages/signinPage.dart';

class Profile extends StatefulWidget {
  final String profileId;

  Profile({this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60.0,
                backgroundImage: NetworkImage(googleUser.photoUrl),
                backgroundColor: Colors.transparent,
              ),
              Text.rich(
                TextSpan(
                    style: TextStyle(
                      fontFamily: 'Lemonada',
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlueAccent,
                    ),
                    children: [
                      TextSpan(text: googleUser.displayName),
                    ]),
              ),

              SizedBox(
                height: 5.0,
                width: 180.0,
                child: Divider(color: Colors.lightBlueAccent),
              ),

              Card(
                  color: Colors.lightBlueAccent,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.perm_identity,
                      color: Colors.white,
                    ),
                    title: Text(
                      googleUser.id,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  )),
              Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  color: Colors.lightBlueAccent,
                  child: ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    title: Text(
                      googleUser.email,
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.white,
                      ),
                    ),
                  )),

              SizedBox(
                height: 20.0,
              ),

//              View Order
              ButtonTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                minWidth: 101.0,
                height: 20,
                focusColor: Colors.white,
                buttonColor: Colors.lightBlueAccent,
                child: RaisedButton(
                  onPressed: () => {
                    googleSignIn.signOut(),
                  },
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      const Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
