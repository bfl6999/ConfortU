/// Autor: Brian Alexander Flores Lopez, Universidad de Almeria
/// Fecha: 1/06/23
/// Version 1.0
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confortu/model/usuario_registro_model.dart';
import '../main.dart';
import '../view/utils/utils.dart';

/// Clase que define el control del Inicio de Sesión
class RegistroController {
  /// Función asíncrona que controla el registro de usuario en la aplicación
  /// le pasamos por los datos del usuario modelado, el contexto y la llave del formulario
  Future<void> signUp(UsuarioModel usuarioModel, context, formKey) async {
    final isValid = formKey.currentState!.validate(); /// Se comprueba si los datos son válidos
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false, /// Se desactiva la barrera modal debajo de las rutas
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try { /// Se crea el usuario con el correo y la contraseña obtenidos de usuarioModel
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: usuarioModel.email.trim(),
        password: usuarioModel.password.trim(),
      );
      /// Registro exitoso
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message); /// Manejo del error del registro
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst); /// Nos redirige a FormaFormulario
  }
}
