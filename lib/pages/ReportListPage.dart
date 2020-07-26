import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:labels_book/pages/reportCardList.dart';

import 'filterScreen.dart';

class ReportListPage extends StatefulWidget {
  @override
  ReportListPageState createState() => ReportListPageState();
}

class ReportListPageState extends State<ReportListPage> {
  @override
  void initState() {
    snapshotQuery = getSnapshotQuery();
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    snapshotQuery =
//        Firestore.instance.collection('orders/$currentUserID/orders_details');
    return Scaffold(
      body: StreamBuilder(
          stream:
              snapshotQuery.orderBy('Added Date', descending: true).snapshots(),
//          = Firestore.instance.snapshots(),
//              .collection('orders/$currentUserID/orders_details')
//              // ignore: unrelated_type_equality_checks
////              .where(filterCompleted == 'Completed' ? ('Completed', '==', false) : '*')
////              .where(1 == 1 ? {'Completed', '==': false} : 'sdsd')
//              .where(1 == 1 ? 'sdsd' : 'sdsd')
//

//              .orderBy('Delivery Date')
//              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, int index) {
                  return ReportCardList(
                    snapshot: snapshot.data,
                    index: index,
                    totalItem: snapshot.data.documents.length,
                  );
//                  return Text(snapshot.data.documents[index]['Product']);
                });
          }),
    );
  }

  Query getSnapshotQuery() {
//    snapshotQuery =
//        Firestore.instance.collection('orders/$currentUserID/orders_details');
//    if (filterStatus == 'Completed') {
//      snapshotQuery = snapshotQuery.where("Completed", isEqualTo: true);
//    }
//    if (filterStatus == 'Open') {
//      snapshotQuery = snapshotQuery.where("Completed", isEqualTo: false);
//      return snapshotQuery;
//    }
////    if (filterStatus == 'Open') {
////      snapshotQuery = snapshotQuery.where("Completed", isEqualTo: true);
////    }
//    if (filterBy != null) {
//      snapshotQuery = snapshotQuery.where("Added By", isEqualTo: filterBy);
//      return snapshotQuery;
//    }
//    if (filterClient != null) {
//      snapshotQuery = snapshotQuery.where("Client", isEqualTo: filterClient);
//      return snapshotQuery;
//    }
//    if (filterItem != null) {
//      snapshotQuery = snapshotQuery.where("Product", isEqualTo: filterItem);
//      return snapshotQuery;
//    }
//    if (sortValue == 'Newest') {
//      snapshotQuery = snapshotQuery.orderBy('Added Date');
//      return snapshotQuery;
//    }
//    if (sortValue == 'Oldest') {
//      snapshotQuery = snapshotQuery.orderBy("Added Date", descending: true);
//      return snapshotQuery;
//    }
    return snapshotQuery;
  }
}
