import 'package:flutter/widgets.dart';

class ViewProvider extends ChangeNotifier {
  bool viewAll = true;

  void changeView(){
    viewAll = !viewAll;
    notifyListeners();

  }
}