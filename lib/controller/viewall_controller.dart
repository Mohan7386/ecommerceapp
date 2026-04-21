import 'package:flutter/widgets.dart';

class ViewProvider extends ChangeNotifier {
  bool viewAll = false;

  void changeView(){
    viewAll = !viewAll;
    notifyListeners();

  }
}