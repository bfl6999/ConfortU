/// Autor: Brian Alexander Flores Lopez, Universidad de Almeria
/// Fecha: 1/06/23
/// Version: 1.0
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../view/utils/utils.dart';

/// Clase que define la gestión de  restablecer la contraseña al usuario
class ForgetPassword{
  ///
  Future <void> verificarEmail(TextEditingController emailController, context, formKey) async{
    final isValid = formKey.currentState!.validate(); /// Se comprueba si los datos son válidos
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());

      Utils.showSnackBar('Se envío un correo para restablecer su contraseña');
      Navigator.of(context).popUntil((route) => route.isFirst);

    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}