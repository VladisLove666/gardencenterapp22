import 'package:gardencenterapppp/models/user.dart' show User;
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  User? user;

  AuthProvider();

  void setUser(User? user) {
    this.user = user;
    notifyListeners();
  }
}