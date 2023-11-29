import 'package:flutter/material.dart';
import 'package:flutter_application_2/firebase_options.dart';
import 'package:flutter_application_2/services/repository.dart';
import 'package:flutter_application_2/views/citas/registro.dart';
import 'package:flutter_application_2/views/cronograma/cronograma.dart';
import 'package:flutter_application_2/views/usuarios/login.dart';
import 'package:flutter_application_2/views/usuarios/splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'views/dashboard/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserRepository()),
      ],
      child: MaterialApp(
        title: 'AppCrecer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
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
        home: const SplashScreen(),
        routes: {
          '/dashboard': (BuildContext context) => Dashboard(),
          '/cronograma': (BuildContext context) => CronogramaScreen(),
          '/LoginPage': (BuildContext context) => const LoginPage(),
          '/registro': (BuildContext context) => const Registro(),
        },
      ),
    );
  }
}
