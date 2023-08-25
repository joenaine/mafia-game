import 'package:flutter/material.dart';
import 'package:mafiagame/pages/room/model/character_model.dart';

class JoinGameProvider extends ChangeNotifier {
  int selectedContainerIndex = 1;
  CharacterModel? myCharacter;

  void setCheckbox(int index) {
    selectedContainerIndex = index;
    notifyListeners();
  }
}
