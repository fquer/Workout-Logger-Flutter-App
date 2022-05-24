import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/app_styles.dart';

class Event {
  final String title;
  Event({required this.title});

  String toString() => this.title;
}

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc) {
  return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doc["HareketIsim"],
              style: Appstyle.mainTitle,
            ),
            SizedBox(height: 4),
            Text(
              doc["HareketTarifLink"],
              style: Appstyle.mainContent,
            ),
          ],
        ),
      ));
}
