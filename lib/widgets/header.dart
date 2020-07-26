import 'package:flutter/material.dart';

AppBar header(context,
    {bool isAppTitle = false, String titleText, removeBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? "Labels Book!" : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? "Lemonada" : "",
        fontSize: isAppTitle ? 40.0 : 22.0,
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).primaryColor,
  );
}
