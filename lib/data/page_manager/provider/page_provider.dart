import 'package:flutter/cupertino.dart';

class PageManagerProvider with ChangeNotifier {
  int _selectedIndex = 2;
  int get selectedIndex =>_selectedIndex;
  changeTab(int index){
    _selectedIndex = index;
    notifyListeners();
  }
}