import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminBooking extends ChangeNotifier {
  final CollectionReference _bookingData =
      FirebaseFirestore.instance.collection("bookings");
  final CollectionReference _user =
      FirebaseFirestore.instance.collection("users");

  CollectionReference get bookingData => _bookingData;
  CollectionReference get user => _user;
}
