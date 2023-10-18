
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
            Icon(Icons.ac_unit, size: 100, color: Colors.orange), // Placeholder icon, replace with your logo
            SizedBox(height: 40.0),
            FadeAnimatedTextKit(
              text: const ['CRECER'],
              textStyle: const TextStyle(
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
              child: const Text('Ingresar'),
            ),
          ],
        ),
      ),
    );
  }
}