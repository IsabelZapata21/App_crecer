import 'package:flutter/material.dart';
import 'package:flutter_application_2/views/citas/registro.dart';
import 'package:flutter_application_2/views/cronograma/cronograma.dart';
import 'package:flutter_application_2/views/usuarios/login.dart';
import 'package:flutter_application_2/views/usuarios/splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'views/dashboard/dashboard.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
        colorScheme: ColorScheme.light(primary: Colors.purple),
        textTheme: TextTheme(
          bodyText1: TextStyle(fontFamily: "Poppins"),
          bodyText2: TextStyle(fontFamily: "Poppins"),
          // ... Add other styles as needed
        ),
      ),
      locale: const Locale('es'),
      supportedLocales: const <Locale>[
        Locale.fromSubtags(languageCode: 'en'),
        Locale.fromSubtags(languageCode: 'es'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/dashboard': (BuildContext context) => Dashboard(),
        '/cronograma': (BuildContext context) => CronogramaScreen(),
        '/LoginPage': (BuildContext context) => LoginPage(),
        '/registro': (BuildContext context) => const Registro(),
      },
    );
  }
}
