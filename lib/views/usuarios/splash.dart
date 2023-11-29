import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_application_2/models/auth/usuario.dart';
import 'package:flutter_application_2/services/auth/auth_manager.dart';
import 'package:flutter_application_2/services/auth/auth_service.dart';
import 'package:flutter_application_2/services/repository.dart';
import 'package:flutter_application_2/views/dashboard/dashboard.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/image/logo_crecer.png',
              height: 100,
              width: 100,
            ), // Placeholder icon, replace with your logo
            SizedBox(
              height: 80,
              child: FadeAnimatedTextKit(
                text: const ['CRECER'],
                textStyle: const TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
                duration: Duration(milliseconds: 2000),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                onPrimary: Colors.purple,
              ),
              onPressed: () async {
                if (await AuthManager.isAuthenticated()) {
                  final user = await AuthManager.user();
                  final pass = await AuthManager.contrasena();
                  if (user == null || pass == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Valores no identificados uwu')));
                    return;
                  }
                  try {
                    if (user.isEmpty || pass.isEmpty) throw ('Campos vacíos');
                    final wa =
                        Provider.of<UserRepository>(context, listen: false);
                    final value = await AuthService().iniciarSesion(user, pass);
                    if (!(value['success'] ?? false))
                      throw ('Clave o contraseña incorrecta');
                    wa.usuario = Usuario.fromJson(value['usuario']);
                    //iniciar sesion
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Dashboard()));
                    return;
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
                Navigator.of(context).pushReplacementNamed('/LoginPage');
              },
              child: const Text('Ingresar'),
            ),
          ],
        ),
      ),
    );
  }
}
