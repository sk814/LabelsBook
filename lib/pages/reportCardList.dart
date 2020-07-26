import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:labels_book/pages/signinPage.dart';

class ReportCardList extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;
  final int totalItem;

  const ReportCardList({Key key, this.snapshot, this.index, this.totalItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserID = googleUser.id;
    var docID = snapshot.documents[index].documentID;

    var snapshotData = snapshot.documents[index].data;
    var newDeliverDate = new DateTime.fromMillisecondsSinceEpoch(
        snapshotData['Delivery Date'].seconds * 1000);

    var newDeliverDate1 = new DateFormat("EE,MMM d,y").format(newDeliverDate);

    var addedOn = new DateTime.fromMillisecondsSinceEpoch(
        snapshotData['Added Date'].seconds * 1000);

    var addedOn1 = new DateFormat("EE,MMM d,y").format(addedOn);

    final addedBy = snapshotData['Added By'];
    final client = snapshotData['Client'];
    final doneCheck = snapshotData['Completed'];
    final completedCheck = doneCheck ? 'Completed' : 'Pending';
    final product = snapshotData['Product'];
    final total = snapshotData['Total Role'].toString();
    final note = snapshotData['Note'].toString();
    var exactDeliveryDateReceived = snapshotData['Delivery Date'].toDate();
    var currentDate = DateTime.now();

    var orderDetails =
        'ITEM:              $product\nCLIENT:          $client\nROLES:           $total\nSTATUS:        $completedCheck\nADDED ON:   $addedOn1';

    return Column(
      children: <Widget>[
        if (index == 0)
          Text(
            '$totalItem Total Orders',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.indigo,
            ),
          ),
        Container(
          height: 200,
          child: Card(
            elevation: 9,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'DELIVERY:     $newDeliverDate1',
                    style: doneCheck
                        ? TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 15.0,
                          )
                        : exactDeliveryDateReceived
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
                  trailing:
                      Icon(Icons.blur_circular, color: Colors.lightBlueAccent),
                  subtitle: Text(
                    orderDetails,
                    style: doneCheck
                        ? TextStyle(
//                      fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 15.0,
                          )
                        : TextStyle(
//                      fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15.0,
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
                                  print('THIS DELETED $docID');
                                },
                                child: const Text("DELETE"),
                                color: Colors.redAccent),
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("CANCEL"),
//                            color: Colors.lightBlueAccent
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
                      note.isNotEmpty ? "    NOTE:            $note\n" : "",
                      style: doneCheck
                          ? TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 15.0,
                            )
                          : TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'BY,  $addedBy  ',
                      style: doneCheck
                          ? TextStyle(
                              fontStyle: FontStyle.italic,
//                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 15.0,
                            )
                          : TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
