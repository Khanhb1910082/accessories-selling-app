import 'package:flutter/material.dart';

class FavoriteManager extends ChangeNotifier {
  bool _isfavorite = false;

  get isFavorite => _isfavorite;
  void setFavorite(bool value) {
    _isfavorite = value;
    notifyListeners();
  }
}
