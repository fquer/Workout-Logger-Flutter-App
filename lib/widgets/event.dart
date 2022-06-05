import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/app_styles.dart';

class Event {
  final String title;
  final String set;
  final String rep;
  final String weight;
  final String id;
  Event(
      {required this.title,
      required this.set,
      required this.rep,
      required this.weight,
      required this.id});

  String toString() => this.title;
}
