import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workoutlogger/pages/app_styles.dart';
import 'package:intl/intl.dart';

class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreen();
}

class _NoteReaderScreen extends State<NoteReaderScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.doc.id);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.red.shade400,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.doc["HareketIsim"],
              style: Appstyle.mainTitle,
            ),
            SizedBox(height: 4),
            Text(
              widget.doc["HareketTarifLink"],
              style: Appstyle.dateTitle,
            ),
          ],
        ),
      ),
    );
  }
}
