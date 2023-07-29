import 'package:flutter/material.dart';

class CreateGameProvider extends ChangeNotifier {
  int civil = 7, mafia = 2, doctor = 0, detective = 0, silencer = 0;

  void civilIncrement() {
    civil++;
    notifyListeners();
  }

  void civilDecrement() {
    if (civil > 0) {
      civil--;
    }
    notifyListeners();
  }

  void mafiaIncrement() {
    mafia++;
    notifyListeners();
  }

  void mafiaDecrement() {
    if (mafia > 0) {
      mafia--;
    }
    notifyListeners();
  }

  void doctorIncrement() {
    doctor++;
    notifyListeners();
  }

  void doctorDecrement() {
    if (doctor > 0) {
      doctor--;
    }
    notifyListeners();
  }

  void detectiveIncrement() {
    detective++;
    notifyListeners();
  }

  void detectiveDecrement() {
    if (detective > 0) {
      detective--;
    }
    notifyListeners();
  }

  void silencerIncrement() {
    silencer++;
    notifyListeners();
  }

  void silencerDecrement() {
    if (silencer > 0) {
      silencer--;
    }
    notifyListeners();
  }

  int timeCount = 30;

  void add10() {
    timeCount += 10;
    notifyListeners();
  }

  void add20() {
    timeCount += 20;
    notifyListeners();
  }

  void add30() {
    timeCount += 30;
    notifyListeners();
  }

  void remove10() {
    if (timeCount - 10 > 0) {
      timeCount -= 10;
    }
    notifyListeners();
  }

  void remove20() {
    if (timeCount - 20 > 0) {
      timeCount -= 20;
      notifyListeners();
    }
  }

  void remove30() {
    if (timeCount - 30 > 0) {
      timeCount -= 30;
    }
    notifyListeners();
  }

  int selectedContainerIndex = 1;

  void setCheckbox(int index) {
    selectedContainerIndex = index;
    notifyListeners();
  }
}
