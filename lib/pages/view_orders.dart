import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'ReportListPage.dart';
import 'filterScreen.dart';

class View_Orders extends StatefulWidget {
  @override
  View_OrdersState createState() => View_OrdersState();
}

class View_OrdersState extends State<View_Orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.filter_list),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                      child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: FilterScreen(),
                  )));
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 31.0, left: 10.0, right: 10.0, bottom: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      child: Icon(
                        Icons.list,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Lemonada",
                      ),
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
              child: ReportListPage(),
//              color: Colors.lightBlueAccent,
            ),
          ),
        ],
      ),
    );
  }
}

//ssDNqB48XnmWQEnF3CgC
