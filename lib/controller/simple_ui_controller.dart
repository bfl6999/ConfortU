import 'package:get/get.dart';
/// GetxController es una clase proporcionada por el paquete GetX, que es un framework de gestión de estado y navegación para Flutter
class SimpleUIController extends GetxController {
  RxBool isObscure = true.obs; /// Se crea una instancia booleana que permite rastrear cambios en ella con el valor de true

  isObscureActive() { /// Se usa para cambiar el valor de isObscure -> Se usa para ocultar o dar visibilidad a las contraseñas
    isObscure.value = !isObscure.value;
  }
}