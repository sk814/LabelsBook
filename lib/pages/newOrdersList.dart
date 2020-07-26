import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:labels_book/pages/signinPage.dart';

import 'customCard.dart';

final currentUserID = googleUser.id;

class NewOrdersList extends StatefulWidget {
  @override
  _NewOrdersListState createState() => _NewOrdersListState();
}

class _NewOrdersListState extends State<NewOrdersList> {
  int openItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('orders/$currentUserID/orders_details')
              .where("Completed", isEqualTo: false)
              .orderBy('Delivery Date')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, int index) {
                  openItems = snapshot.data.documents.length;
                  return CustomCard(
                      snapshot: snapshot.data,
                      index: index,
                      itemCount: snapshot.data.documents.length);
                });
          }),
    );
  }
}
