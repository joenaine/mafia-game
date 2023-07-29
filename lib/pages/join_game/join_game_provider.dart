import 'package:flutter/material.dart';

class JoinGameProvider extends ChangeNotifier {
  int selectedContainerIndex = 1;

  void setCheckbox(int index) {
    selectedContainerIndex = index;
    notifyListeners();
  }
}
