import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  int currentIndex = 0;

 // int get currentIndex => _currentIndex;

  void changeIndex(int newIndex) {
    currentIndex = newIndex;
    notifyListeners();
  }
}