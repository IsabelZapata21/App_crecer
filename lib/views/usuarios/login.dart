import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/auth/usuario.dart';
import 'package:flutter_application_2/services/auth/auth_service.dart';
import 'package:flutter_application_2/services/repository.dart';
import 'package:flutter_application_2/views/dashboard/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/services/auth/auth_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool obscurePassword = true; // Variable para controlar la visibilidad de la contraseña

  Future<void> login() async {
    try {
      // Validar campos vacíos
      if (user.text.isEmpty || pass.text.isEmpty) {
        throw ('Campos vacíos. Por favor, completa todos los campos.');
      }

      final wa = Provider.of<UserRepository>(context, listen: false);
      final value = await AuthService().iniciarSesion(user.text, pass.text);

      // Validar éxito en la respuesta
      if (!(value['success'] ?? false)) {
        throw ('Clave o contraseña incorrecta. Por favor, verifica tus credenciales.');
      }

      wa.usuario = Usuario.fromJson(value['usuario']);
      // Iniciar sesión
      await AuthManager.logIn(user.text, pass.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } catch (e) {
      // Mostrar error en un AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error de inicio de sesión'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.account_circle, size: 100, color: Colors.purple), // Logo o ícono
                SizedBox(height: 20.0),
                Text(
                  'Inicia sesión',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: user,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      labelText: 'Usuario',
                      prefixIcon: Icon(Icons.person, color: Colors.purple),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: pass,
                    obscureText: obscurePassword, // Controla si la contraseña está oculta o no
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock, color: Colors.purple),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.purple,
                        ),
                        onPressed: () {
                          // Cambia la visibilidad de la contraseña al presionar el botón del ojo
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    onPrimary: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  child: const Text('Ingresar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
