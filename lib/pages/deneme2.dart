import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workoutlogger/pages/app_styles.dart';

import '../widgets/event.dart';
import 'deneme.dart';

class Mynote extends StatefulWidget {
  const Mynote({Key? key}) : super(key: key);

  @override
  State<Mynote> createState() => _Mynote();
}

class _Mynote extends State<Mynote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Hareketler")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    print(snapshot.data!.docs);
                    snapshot.data!.docs
                        .map((note) => noteCard(() {
                              print(note["HareketIsim"]);
                              print(note.id);
                            }, note))
                        .toList();
                  }
                  return Text(
                    "No Notes",
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
