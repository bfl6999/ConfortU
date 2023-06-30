/// Autor: Brian Alexander Flores Lopez, Universidad de Almeria
/// Fecha: 1/06/23
/// Version 1.0
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/user_opinion_model.dart';
import '../view/utils/utils.dart';

/// Clase que define el control de envío de opiniones de los usuarios ya registrados
class OpinionController {
  String usuario = "";
  /// Función asíncrona que prepara y envía opiniones de usuarios ya registrados
  /// recibe como parámetros user de tipo Opiniones y el contexto de la app
  Future<void> preSendOpinions(Opiniones user, context, String horaRegistro) async {
    final userAuth = FirebaseAuth.instance.currentUser!; /// Se obtiene el usuario actual con el que esta iniciada la sesión
    usuario = userAuth.email!;
    DateTime? horaUltimoEnvioBdd;

    final collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(usuario)
        .collection(usuario);
    final querySnapshot = await collectionRef.get(); /// Se obtienen los docs de la colección

    if (querySnapshot.docs.isNotEmpty) { /// Si no está vacía se obtiene la última hora de envío
      final lastDocId = querySnapshot.docs.last.id;
      final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      horaUltimoEnvioBdd = dateFormat.parse(lastDocId);
    }
    /// Se guarda la hora en la que se registran los datos: HH hora formato..min..seg
    const duracionMinima = Duration(minutes: 30);
    final horaActual = DateTime.now();

    if (horaUltimoEnvioBdd == null ||
        (horaActual.difference(horaUltimoEnvioBdd) >= duracionMinima)) {
      /// Se permite el envío de datos
      showDialog(
        context: context,
        builder: (context) {
          /// Se construye un FutureBuilder para manejar la creación de las opiniones del usuario
          return FutureBuilder<bool>(
            future: createUser(user, usuario, horaRegistro),
            builder: (context, snapshot) {
              /// Se comprueba el estado actual del constructor
              if (snapshot.connectionState == ConnectionState.waiting) {
                /// Mientras se envía la respuesta se muestra el siguiente progresor
                return const AlertDialog(
                  title: Text('Enviando respuesta'),
                  content: Center(
                    heightFactor: 2.0,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blueGrey,
                    ),
                  ),
                );
              } else if (snapshot.hasError) { /// Si ocurre algún error, se muestra el dialogo:
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Hubo un error al enviar la opinión'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Aceptar'),
                    ),
                  ],
                );
              } else {
                /// Si la operación se envía correctamente -> Mensaje de éxito
                final success = snapshot.data;
                return AlertDialog(
                  title: Text(success! ? '¡Enviado!' : 'Error'),
                  content: Text(success
                      ? 'La opinión se envió correctamente'
                      : 'Hubo un error al enviar la opinión'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), /// Se quita el mensaje
                      child: const Text('Aceptar'),
                    ),
                  ],
                );
              }
            },
          );
        },
      );
    } else {
      final diferenciaHora = horaActual.difference(horaUltimoEnvioBdd);
      final minutosRestantes =
          duracionMinima.inMinutes - diferenciaHora.inMinutes;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Límite de respuesta alcanzado'),
          content: Text(
              'Debes esperar $minutosRestantes minutos, hasta poder envíar una nueva respuesta'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Aceptar'))
          ],
        ),
      );
    }
  }

  /// Función que se encarga de añadir las opiniones a la base de datos en Firestore
  /// devuelve true o false para comprobar si se envían los datos sin problemas
  Future<bool> createUser(
      Opiniones user, String usuario, String horaRegistro) async {
    /// Documento del usuario que se crea, con la hora actual como id
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(usuario)
        .collection(usuario)
        .doc(horaRegistro);

    CollectionReference ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(usuario)
        .collection(usuario);
    try {
      QuerySnapshot colec = await ref.get(); /// Se captura la colección en la query colec
      if (colec.docs.isEmpty) { /// Si la colección no tiene ningún documento
        /// Se crea el documento y se envia a la base de datos
        user.idOpinion = docUser.id;
        final json = user.toJson();
        await docUser.set(json);
      } else {
        /// Se añade en la misma coleccion en otro documento
        ///user.idOpinion = ref.id; /// Si usamos la referencia se agregan las sub al doc
        user.idOpinion = docUser.id;
        final json = user.toJson();
        await docUser.set(json, SetOptions(merge: true));
        await docUser.update(json);
      }
      return true;
    } catch (e) {
      Utils.showSnackBar('Algo salió mal, comprueba la conexión a internet.');
      return false;
    }
  }
  /// Método que se usa para cerrar sesión en la aplicación
  void closeSession(onCloseSession, context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [ /// Acciones para definir si se confirma el cierre de la aplicación
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pop(); /// Cierra el diálogo de confirmación
              if (onCloseSession != null) {
                onCloseSession();
              }
            },
            style: ButtonStyle(
              alignment: Alignment.center,
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.redAccent),
            ),
            child: const Text('Sí'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              },
            style: ButtonStyle(
              alignment: Alignment.center,
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor:
              MaterialStateProperty.all<Color>(Colors.blueGrey),
            ),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }
  /// Método de conversión a entero de las respuestas a la actividad
  int convertToIntActivity(String aux) {
    return (aux == "Actividad.sedentaria"
        ? 65
        : aux == "Actividad.ligera"
            ? 85
            : aux == "Actividad.media"
                ? 105
                : 85);
  }
  /// Método de conversión a double de las respuestas a la ropa
  double convertToClothe(String aux) {
    return (aux == "Ropa.corta"
        ? 0.36
        : aux == "Ropa.larga"
            ? 0.61
            : aux == "Ropa.abrigada"
                ? 1.30
                : 0.36);
  }
}
