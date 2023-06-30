/// Autor: Brian Alexander Flores Lopez, Universidad de Almeria
/// Fecha: 1/06/23
/// Version 1.0
import 'package:flutter/material.dart';
import 'package:confortu/view/screens/registro_screen.dart';

import '../view/screens/inicio_sesion_screen.dart';

/// Esta es una clase que se usa para adjuntar funcionalidades a las 2 clases de Inicio y Registro
/// dependiendo del contexto y la variable isLogin se muestra una ventana u otra

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  _AuthState createState() => _AuthState();
}

/// Estado del widget de autenticación
class _AuthState extends State<Auth> {
  bool isLogin = true; /// variable booleana que sive para determinar en que ventana se encuentra el constructor

  /// Método de construcción del widget que renderiza el widget de inicio o registro dependiendo de la variable isLogin
  @override
  Widget build(BuildContext context) => isLogin
      ? Inicio(onClickedSignUp: toggle)
      : Registro(onClickedSignIn: toggle);

  /// Función que invierte el valor de isLogin y actualiza el estado del widget
  void toggle() => setState(() => isLogin = !isLogin);
}
