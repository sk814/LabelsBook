import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:labels_book/pages/newOrdersList.dart';
import 'package:labels_book/pages/signinPage.dart';
import 'package:labels_book/pages/add_task_screen.dart';
import 'add_task_screen.dart';

int openOrder;

class NewHome extends StatefulWidget {
  @override
  _NewHomeState createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  get msg => null;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.getToken().then((token) {
      usersRef
          .document(currentUserID)
          .updateData({"androidNotificationToken": token});
      return null;
    });

    fbm.configure(
      onMessage: (Map<String, dynamic> msg) async {
        return;
      },
      onLaunch: (Map<String, dynamic> msg) async {
        return;
      },
      onResume: (Map<String, dynamic> msg) async {
        return;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: FloatingActionButton(
          backgroundColor: Colors.lightBlueAccent,
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                        child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddTaskScreen(),
                    )));
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 18.0, left: 10.0, right: 10.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Labels Book!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Lemonada",
                      ),
                    ),
                    SizedBox(
                      width: 31,
                    ),
                    CircleAvatar(
                      radius: 47.0,
                      backgroundImage: AssetImage('images/logo_5.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: NewOrdersList(),
            ),
          ),
        ],
      ),
    );
  }
}
