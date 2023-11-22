import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static const String isLoggedInKey = 'isLoggedIn';
  static const String isContraInKey = 'isContrasenaIn';
  static const String isUserInKey = 'isUserIn';

  // Verifica si el usuario está autenticado
  static Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }

  static Future<String?> user() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(isUserInKey);
  }

  static Future<String?> contrasena() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(isContraInKey);
  }

  // Inicia sesión
  static Future<void> logIn(String usuario, String contrasena) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, true);
    await prefs.setString(
        isUserInKey, usuario); //guardo en mi preferences-  el user y contra
    await prefs.setString(isContraInKey, contrasena);
  }

  // Cierra sesión
  static Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, false);
  }
}
