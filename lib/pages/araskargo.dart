import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ArasKargo extends StatefulWidget {
  const ArasKargo({Key? key}) : super(key: key);

  @override
  State<ArasKargo> createState() => _ArasKargoState();
}

class _ArasKargoState extends State<ArasKargo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Hareketler").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Center(
                child: Container(
                  child: Text("Aras Karh   " + document["HareketIsim"]),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
