/// Autor: Brian Alexander Flores Lopez, Universidad de Almeria
/// Fecha: 1/06/23
/// Version 1.0
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/data_model.dart';
import 'package:confortu/view/utils/utils.dart';

/// Clase que define el control de usuario de envío de datos
/// Permite crear y actualizar datos de un usuario en Firestore
class UserController {
  /// Función asícrona que crea/actualiza el usuario y los datos en Firestore recibe como parametro user que contiene los datos del usuario
  /// Throws @showSnackBar si ocurre algún error
  String usuario = "";
  Future<void> createUserData(Datos user) async {
    final userAuth = FirebaseAuth.instance.currentUser!; /// Se obtiene el usuario actual con el que esta iniciada la sesión
    usuario = userAuth.email!; /// Se guarda el email del usuario en el modelo user
    user.name = usuario;
    final docUser = FirebaseFirestore.instance
        .collection('users').doc(usuario); /// Referencia al documento del usuario en la colección users
    ///CollectionReference ref = FirebaseFirestore.instance.collection('Users').doc(usuario).collection(usuario); /// Referencia a la subcolección del usuario en la colección users
    CollectionReference ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(usuario)
        .collection(usuario);
    try {
      QuerySnapshot colec = await ref.get(); /// Se obtienen los documentos de la subcolección
      if (colec.docs.isEmpty) { /// Si no hay ningún documento en la colección, el usuario no existe
        user.userId = docUser.id; /// Se asigna el ID del documento al modelo user
        final json = user.toJson(); /// Se convierte el modelo user a JSON
        await docUser.set(json); /// Se crea un nuevo documento con los datos del modelo user

      } else {   /// Si el usuario ya existe, se actualiza el documento con la nueva información
        user.userId = ref.id;
        final json = user.toJson();
        await docUser.update(json); /// Actualización de los datos con los nuevos
      }
    } catch (e) { /// Captura del error
      Utils.showSnackBar('Algo salió mal, comprueba la conexión a internet.'); /// Muestra un mensaje de error en caso de error
    }
  }
}
