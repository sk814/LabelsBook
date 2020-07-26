import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:labels_book/pages/signinPage.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import 'signinPage.dart';

class AddTaskScreen extends StatefulWidget {
  final currentUserId = googleUser.id;

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  bool asTabs = false;
  String selectedLocalUser;
  String selectedProduct;
  String selectedClient;

  DateTime selectedDate = DateTime.now().add(Duration(days: 7));

  TextEditingController order_from_controller = TextEditingController();

  TextEditingController note_controller = TextEditingController();

  TextEditingController delivery_controller = TextEditingController();

  TextEditingController user_controller = TextEditingController();

  TextEditingController role_controller = TextEditingController();

  TextEditingController product_controller = TextEditingController();

  final currentUserID = googleUser.id;

  final _delivery = FocusNode();

  final _note = FocusNode();

  final _roll = FocusNode();

  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem> localUserList = [];
  List<DropdownMenuItem> clientList = [];
  List<DropdownMenuItem> productsList = [];

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  FlutterToast flutterToast;

  @override
  void initState() {
    _getLocalUsers();
    _getProducts();
    _getClients();

    super.initState();

    flutterToast = FlutterToast(context);
  }

  @override
  Widget build(BuildContext context) {
//    String newTaskTitle;

    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    //Local USer
                    Card(
                      elevation: 9,
                      child: SearchableDropdown.single(
                        style: TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.lightBlueAccent,
                        ),
                        items: localUserList,
                        value: selectedLocalUser,
                        hint: "Sales Person",
                        searchHint: "If not found add",
                        onChanged: (value) {
                          setState(() {
                            selectedLocalUser = value;
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                    //Product
                    SizedBox(
                      height: 8.0,
                      width: 251.0,
                      child: Divider(color: Colors.lightBlueAccent),
                    ),
                    Card(
                      elevation: 9,
                      child: SearchableDropdown.single(
                        style: TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.lightBlueAccent,
                        ),
                        items: productsList,
                        value: selectedProduct,
                        hint: "Item",
                        searchHint: "If not found add",
                        onChanged: (value) {
                          setState(() {
                            selectedProduct = value;
                          });
                        },
                        isExpanded: true,
                      ),
                    ),

                    //Client
                    SizedBox(
                      height: 8.0,
                      width: 251.0,
                      child: Divider(color: Colors.lightBlueAccent),
                    ),

                    Card(
                      elevation: 9,
                      child: SearchableDropdown.single(
                        style: TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.lightBlueAccent,
                        ),
                        items: clientList,
                        value: selectedClient,
                        hint: "Client",
                        searchHint: "If not found add",
                        onChanged: (value) {
                          setState(() {
                            selectedClient = value;
                          });
                        },
                        isExpanded: true,
                      ),
                    ),

                    Container(
//                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        "${selectedDate.toLocal()}".split(' ')[0],
                        style: TextStyle(
                          fontFamily: 'Lemonanda',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    ButtonTheme(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minWidth: 350.0,
                      height: 26,
                      focusColor: Colors.teal,
                      buttonColor: Colors.lightBlueAccent,
                      child: RaisedButton(
                        onPressed: () => _selectDate(context),
                        padding: EdgeInsets.all(10.0),
                        focusNode: _delivery,
                        child: Column(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              color: Colors.white,
                              size: 17,
                            ),
                            Text(
                              "Delivery Date",
                              style: TextStyle(
                                fontFamily: 'Lemonanda',
                                fontSize: 15.0,
//                            fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 5.0,
                    ),
                    Card(
                      elevation: 9,
                      child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter total Role';
                            }
                            return null;
                          },
                          controller: role_controller,
                          decoration: InputDecoration(labelText: 'Total Role'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _roll,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_note);
                          }),
                    ),

                    SizedBox(
                      height: 5.0,
                    ),
//TO BE ADDED
                    Card(
                      elevation: 9,
                      child: TextFormField(
                        controller: note_controller,
                        decoration: InputDecoration(labelText: 'Any Note'),
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        focusNode: _note,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: ButtonTheme(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minWidth: 350.0,
                        height: 50,
                        focusColor: Colors.teal,
                        buttonColor: Colors.lightBlueAccent,
                        child: RaisedButton(
                          onPressed: () {
                            final form1 = _formKey.currentState;

                            if (form1.validate() &&
                                selectedClient != null &&
                                selectedProduct != null &&
                                selectedLocalUser != null) {
//                              addData();
                              addOrderFirestore();

                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              fontFamily: 'Lemonanda',
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addOrderFirestore() {
    String total = role_controller.text;
    String note = note_controller.text;
    DateTime deliverDate = selectedDate.toLocal();

    final _orderId = UniqueKey().toString() +
        new DateTime.now().millisecondsSinceEpoch.toString();

    ordersRef
        .document(widget.currentUserId)
        .collection("orders_details")
        .document(_orderId)
        .setData({
      'Added By': selectedLocalUser,
      'Product': selectedProduct,
      'Client': selectedClient,
      'Delivery Date': deliverDate,
      'Total Role': total,
      'Note': note,
      'Added Date': timestamp.toLocal(),
      'Completed': false,
    });
    //Toast Message
    _showToast();
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
          Icon(Icons.save_alt),
          SizedBox(
            width: 12.0,
          ),
          const Text("Order Saved!"),
        ],
      ),
    );

    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
  }

  Future<void> _getLocalUsers() async {
    await for (var snapshot in Firestore.instance
        .collection('internalUser/$currentUserID/added_user')
        .snapshots()) {
      for (var data_stored in snapshot.documents) {
        final localUser = data_stored.data['User'].toString();
        localUserList
            .add(DropdownMenuItem(child: Text(localUser), value: localUser));
      }
    }
  }

  Future<void> _getClients() async {
    await for (var snapshot in Firestore.instance
        .collection('client/$currentUserID/added_client')
        .snapshots()) {
      for (var data_stored in snapshot.documents) {
        final clients = data_stored.data['Client'].toString();
        clientList.add(DropdownMenuItem(child: Text(clients), value: clients));
      }
    }
  }

  Future<void> _getProducts() async {
    await for (var snapshot in Firestore.instance
        .collection('items/$currentUserID/added_items')
        .snapshots()) {
      for (var data_stored in snapshot.documents) {
        final item = data_stored.data['Item'].toString();
        productsList.add(DropdownMenuItem(child: Text(item), value: item));
      }
    }
  }
}
