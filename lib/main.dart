import 'package:flutter/material.dart';
import 'package:flutter_application_2/views/cronograma/cronograma.dart';
import 'package:flutter_application_2/views/usuarios/login.dart';
import 'package:flutter_application_2/views/usuarios/splash.dart';
import 'views/dashboard/dashboard.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/cronograma': (BuildContext context) => CronogramaScreen(),
        '/LoginPage': (BuildContext context) => LoginPage(),
      },
    );
  }
}
