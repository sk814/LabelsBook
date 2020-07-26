import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:labels_book/pages/signinPage.dart';
import 'package:labels_book/widgets/header.dart';

class Items extends StatefulWidget {
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  String item;
  String client;
  String user;
  final currentUserId = googleUser.id;

  TextEditingController itemController = TextEditingController();
  TextEditingController clientController = TextEditingController();
  TextEditingController userController = TextEditingController();

  FlutterToast flutterToast;

  @override
  void initState() {
    super.initState();

    flutterToast = FlutterToast(context);
  }

  itemSubmit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      SnackBar snackbar = SnackBar(content: Text("Item $item added!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
      Timer(Duration(seconds: 2), () {
        itemRef
            .document(currentUserId)
            .collection("added_items")
            .document(item)
            .setData({
          'Item': item,
          'Added Date': timestamp,
        });
      });
      _showToast();
    }
    itemController.clear();
  }

  clientSubmit() async {
    final form2 = _formKey2.currentState;
    if (form2.validate()) {
      form2.save();

      SnackBar snackbar = SnackBar(content: Text("Client $client added!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
      Timer(Duration(seconds: 2), () {
        clientRef
            .document(currentUserId)
            .collection("added_client")
            .document(client)
            .setData({
          'Client': client,
          'Added Date': timestamp,
        });
      });
      _showToast();
    }
    clientController.clear();
  }

  userSubmit() async {
    final form3 = _formKey3.currentState;
    if (form3.validate()) {
      form3.save();

      SnackBar snackbar = SnackBar(content: Text("User $user added!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
      Timer(Duration(seconds: 2), () {
        internalUserRef
            .document(currentUserId)
            .collection("added_user")
            .document(user)
            .setData({
          'User': user,
          'Added Date': timestamp,
        });
      });
      _showToast();
    }
    userController.clear();
  }

  @override
  Widget build(BuildContext parentContext) {
    return addItems();
  }

  addItems() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(
        context,
        titleText: "Add Item/Client/User",
        removeBackButton: true,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            elevation: 9,
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      child: Form(
                        key: _formKey,
                        autovalidate: true,
                        child: TextFormField(
                          controller: itemController,
                          validator: (val) {
                            if (val.trim().length < 4 || val.isEmpty) {
                              return "Item name too short";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (val) => item = val,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Item Name",
                            labelStyle: TextStyle(fontSize: 15.0),
                            hintText: "Must be at least 4 characters",
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: itemSubmit,
                    child: Card(
                      child: Container(
                        height: 50.0,
                        width: 340.0,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        child: Center(
                          child: Text(
                            "Add Item",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                    width: 180.0,
                    child: Divider(color: Colors.lightBlueAccent),
                  ),
                  //Client
                ],
              ),
            ),
          ),
          Card(
            elevation: 9,
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      child: Form(
                        key: _formKey2,
                        autovalidate: true,
                        child: TextFormField(
                          controller: clientController,
                          validator: (val) {
                            if (val.trim().length < 2 || val.isEmpty) {
                              return "Client name too short";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (val) => client = val,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Client Name",
                            labelStyle: TextStyle(fontSize: 15.0),
                            hintText: "Must be at least 2 characters",
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: clientSubmit,
                    child: Container(
                      height: 50.0,
                      width: 340.0,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: Center(
                        child: const Text(
                          "Add Client",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                    width: 180.0,
                    child: Divider(color: Colors.lightBlueAccent),
                  ),
                  //Client
                ],
              ),
            ),
          ),
          Card(
            elevation: 9,
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      child: Form(
                        key: _formKey3,
                        autovalidate: true,
                        child: TextFormField(
                          controller: userController,
                          validator: (val) {
                            if (val.trim().length < 2 || val.isEmpty) {
                              return "User name too short";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (val) => user = val,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "User Name",
                            labelStyle: TextStyle(fontSize: 15.0),
                            hintText: "Must be at least 2 characters",
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: userSubmit,
                    child: Container(
                      height: 50.0,
                      width: 340.0,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: Center(
                        child: const Text(
                          "Add User",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                    width: 180.0,
                    child: Divider(color: Colors.lightBlueAccent),
                  ),

                  //Client
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.orange.shade100,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_done),
          SizedBox(
            width: 12.0,
          ),
          const Text(
            "Saved.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: 17.0,
            ),
          ),
        ],
      ),
    );

    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 3),
    );
  }
}
