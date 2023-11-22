import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/auth/usuario.dart';
import 'package:flutter_application_2/services/auth/auth_service.dart';

class UserRepository with ChangeNotifier {
  final service = AuthService();
  Usuario? usuario;
}