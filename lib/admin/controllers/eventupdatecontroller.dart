import 'package:flutter/material.dart';

import '../../const/cities.dart';

class EventUpdateController extends ChangeNotifier {
  String? selectedDate;

  chooseDate(BuildContext context) async {
    DateTime? store = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2001),
        lastDate: DateTime(2050));

    if (store != null) {
      selectedDate = "${Consts().month[store.month]} ${store.day}";
      notifyListeners();
    }
  }
}
