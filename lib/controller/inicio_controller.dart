/// Autor: Brian Alexander Flores Lopez, Universidad de Almeria
/// Fecha: 1/06/23
/// Version 1.0
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import '../view/utils/utils.dart';

/// Clase que define el control del Inicio de Sesión
class InicioController {
  /// Función asíncrona que controla el inicio de sesión en la aplicación
  /// le pasamos por parámetro el email, la contraseña y el contexto
  Future<void> signIn(TextEditingController emailController, TextEditingController passwordController, context, formKey) async {
    final isValid = formKey.currentState!.validate(); /// Se comprueba si los datos son válidos
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator())); /// Indicador circular mientras se termina el proceso
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ); /// Función implementada en Firebase Authentication para iniciar sesión con email y contraseña, se le pasan las obtenidas en la vista
    } on FirebaseAuthException catch (e) { /// Si ocurre algún error, se genera el mensaje de error por defecto
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst); /// Se cambia el estado para redirigirnos a la ventana Envío Datos
  }
}
