import 'package:flutter/material.dart';

class SpecialCharactersProvider extends ChangeNotifier {
  String? specialCharacters;
  String? get item => specialCharacters;

  saveSpecialCharacters(String? specialCharacters) {
    this.specialCharacters = specialCharacters;
    notifyListeners();
  }

  clearSpecialCharacters() {
    specialCharacters = null;
    notifyListeners();
  }
}
