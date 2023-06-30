import 'package:flutter/material.dart';

/// Clase que proporciona métodos útiles para la aplicación

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();   /// Llave global para acceder al estado de ScaffoldMessenger

  /// Muestra una snackbar con el texto especificado
  static showSnackBar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.red);

    /// Antes de mostrar una nueva notificación, se borra cualquiera ya existente
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
