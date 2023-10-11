import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_application_2/pages/cronograma.dart';
import 'pages/dashboard.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
        accentColor: Colors.orange,
        textTheme: TextTheme(
          bodyText1: TextStyle(fontFamily: "Poppins"),
          bodyText2: TextStyle(fontFamily: "Poppins"),
          // ... Add other styles as needed
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/dashboard': (BuildContext context) => Dashboard(),
        '/cronograma': (BuildContext context) => Cronograma(),
        '/LoginPage': (BuildContext context) => LoginPage(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.ac_unit, size: 100, color: Colors.orange), // Placeholder icon, replace with your logo
            SizedBox(height: 40.0),
            FadeAnimatedTextKit(
              text: ['CRECER'],
              textStyle: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              duration: Duration(milliseconds: 2000),
            ),
            SizedBox(height: 60.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                onPrimary: Colors.purple,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/LoginPage');
              },
              child: Text('Ingresar'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  String mensaje = '';

  Future<void> login() async {
    final url = Uri.parse("http://192.168.43.65/app/login.php");
    /*try {
      final respuesta = await http.post(url, body: {
        "usuario": user.text,
        "contrasena": pass.text,
      });
      if (respuesta.statusCode == 200) {*/
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );
    /*
      } else {
        // Handle error response
        setState(() {
          mensaje = "Error al iniciar sesión. Intenta de nuevo.";
        });
      }
    } catch (e) {
      setState(() {
        mensaje = "Ocurrió un error. Verifica tu conexión y vuelve a intentarlo.";
      });
    }*/
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
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
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock, color: Colors.purple),
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
                if (mensaje.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      mensaje,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
