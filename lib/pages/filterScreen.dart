import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import 'ReportListPage.dart';
import 'newOrdersList.dart';

String sortValue;
String filterCompleted;
String filterItem;
String filterBy;
String filterClient;
String filterStatus;

Query snapshotQuery =
    Firestore.instance.collection('orders/$currentUserID/orders_details');

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<DropdownMenuItem> localUserList = [];
  List<DropdownMenuItem> clientList = [];
  List<DropdownMenuItem> productsList = [];

  @override
  void initState() {
    _getLocalUsers();
    _getProducts();
    _getClients();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 25.0, left: 30.0, right: 30.0, bottom: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: DropdownButton<String>(
                    value: sortValue,
                    hint: Text('Sort By'),
//                  icon: Icon(Icons.arrow_downward),
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.lightBlueAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        sortValue = newValue;
                        ReportListPage();
                      });
                    },
                    items: <String>[
                      'Newest',
                      'Oldest',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    isExpanded: false,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  child: DropdownButton<String>(
                    value: filterCompleted,
                    hint: Text('Completed'),
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.lightBlueAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(
                        () {
//                          View_Orders();
                          filterCompleted = newValue;
                        },
                      );
                    },
                    items: <String>[
                      'This Month',
                      'last Month',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    isExpanded: false,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  child: DropdownButton<String>(
                    value: filterStatus,
                    hint: Text('   Status'),
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.lightBlueAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        filterStatus = newValue;
                      });
                    },
                    items: <String>[
                      'Completed',
                      'Open',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
//                        isExpanded: true,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),

//                Text('Filters:'),

          Container(
            child: SearchableDropdown.single(
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.lightBlueAccent,
              ),
              items: localUserList,
              value: filterBy,
              hint: "Sales Person",
              searchHint: "If not found add",
              onChanged: (value) {
                setState(() {
                  filterBy = value;
                });
              },
              isExpanded: true,
            ),
          ),

          Container(
            child: SearchableDropdown.single(
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.lightBlueAccent,
              ),
              items: clientList,
              value: filterClient,
              hint: "Client",
              searchHint: "If not found add",
              onChanged: (value) {
                setState(() {
                  filterClient = value;
                });
              },
              isExpanded: true,
            ),
          ),

          Container(
            child: SearchableDropdown.single(
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.lightBlueAccent,
              ),
              items: productsList,
              value: filterItem,
              hint: "Item",
              searchHint: "If not found add",
              onChanged: (value) {
                setState(() {
                  filterItem = value;
                });
              },
              isExpanded: true,
            ),
          ),
          SizedBox(
            height: 10,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: ButtonTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              minWidth: 350.0,
              height: 40,
              focusColor: Colors.teal,
              buttonColor: Colors.lightBlueAccent,
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Apply',
                  style: TextStyle(
                    fontFamily: 'Lemonanda',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

//                Text('Sort By'),
        ],
      ),
    );
  }

  Query getSnapshotQuery() {
    if (filterStatus == 'Completed') {
      snapshotQuery = snapshotQuery.where("Completed", isEqualTo: true);
    }
    if (filterStatus == 'Open') {
      snapshotQuery = snapshotQuery.where("Completed", isEqualTo: false);
      return snapshotQuery;
    }
    if (filterBy != null) {
      snapshotQuery = snapshotQuery.where("Added By", isEqualTo: filterBy);
      return snapshotQuery;
    }
    if (filterClient != null) {
      snapshotQuery = snapshotQuery.where("Client", isEqualTo: filterClient);
      return snapshotQuery;
    }
    if (filterItem != null) {
      snapshotQuery = snapshotQuery.where("Product", isEqualTo: filterItem);
      return snapshotQuery;
    }
    if (sortValue == 'Newest') {
      snapshotQuery = snapshotQuery.orderBy('Added Date');
      return snapshotQuery;
    }
    if (sortValue == 'Oldest') {
      snapshotQuery = snapshotQuery.orderBy("Added Date", descending: true);
      return snapshotQuery;
    }
    return snapshotQuery;
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
