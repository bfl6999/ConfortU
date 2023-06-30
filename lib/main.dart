/// Autor: Brian Alexander Flores Lopez, Universidad de Almeria
/// Fecha: 1/06/23
/// Version 1.0
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:confortu/controller/auth.dart';
import 'package:confortu/view/screens/datos_usuario_view.dart';
import 'view/utils/utils.dart';

/// Punto de entrada de la aplicación Flutter
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

/// Clase principal que representa la aplicación Flutter

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /// Construye y retorna el widget raíz de la aplicación
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'ReconfortU',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

/// Página principal de la aplicación
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Algo ha salido mal'),
            );
          } else if (snapshot.hasData) {
            return const FormaDatos();
          } else {
            return const Auth();
          }
        }),
  );
}
