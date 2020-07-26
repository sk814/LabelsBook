import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:labels_book/pages/newOrdersList.dart';
import 'package:labels_book/pages/signinPage.dart';

class CustomCard extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;
  final int itemCount;

  const CustomCard({Key key, this.snapshot, this.index, this.itemCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserID = googleUser.id;

    var docID = snapshot.documents[index].documentID;

    var snapshotData = snapshot.documents[index].data;

    var exactDeliveryDateReceived = snapshotData['Delivery Date'].toDate();
    var currentDate = DateTime.now();

    var newDeliverDate = new DateTime.fromMillisecondsSinceEpoch(
        snapshotData['Delivery Date'].seconds * 1000);

    var newDeliverDate1 = new DateFormat("EE,MMM d,y").format(newDeliverDate);

    final addedBy = snapshotData['Added By'];
    final client = snapshotData['Client'];
    final product = snapshotData['Product'];
    final total = snapshotData['Total Role'].toString();
    final note = snapshotData['Note'].toString();

    var orderDetails =
        'ITEM:           $product\nCLIENT:       $client\nROLES:        $total';

    return Dismissible(
      background: stackBehindDismiss(),
      key: UniqueKey(),
      child: Column(
        children: <Widget>[
          if (index == 0)
            Text(
              '$itemCount Open Orders',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.indigo,
              ),
            ),
          Container(
            height: 175,
            child: Card(
              elevation: 9,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'DELIVERY:    $newDeliverDate1',
                      style: exactDeliveryDateReceived
                              .isBefore(currentDate.add(Duration(days: 2)))
                          ? TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 15.0,
                            )
                          : TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                    ),
                    trailing: Icon(Icons.arrow_back_ios,
                        color: Colors.lightBlueAccent),
                    subtitle: Text(
                      orderDetails,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text(
                                "Are you sure you wish to delete this order?"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop(true);
                                    await Firestore.instance
                                        .collection(
                                            'orders/$currentUserID/orders_details')
                                        .document(docID)
                                        .delete();
                                  },
                                  child: const Text("DELETE"),
                                  color: Colors.redAccent),
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("CANCEL"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        note.isNotEmpty ? "    Note:             $note\n" : "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'By,  $addedBy  ',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      onDismissed: (right) {
        //To delete
        isDone(docID);
        //To show a snackbar with the UNDO button
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Order Completed."),
          action: SnackBarAction(
              label: "UNDO",
              onPressed: () {
                //To undo deletion
                undoDeletion(docID);
              }),
        ));
      },
    );
  }

  void isDone(docID) async {
    await Firestore.instance
        .collection('orders/$currentUserID/orders_details')
        .document(docID)
        .updateData({"Completed": true});
  }

  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.lightBlueAccent,
      child: (Icon(
        Icons.done_outline,
        color: Colors.white,
      )),
    );
  }

  Future<void> undoDeletion(docID) async {
    await Firestore.instance
        .collection('orders/$currentUserID/orders_details')
        .document(docID)
        .updateData({"Completed": false});
  }
}
