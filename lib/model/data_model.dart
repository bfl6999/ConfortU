/// Autor: Brian Alexander Flores Lopez, Universidad de Almeria
/// Fecha: 1/06/23
/// Version 1.0
/// Clase Datos que define el modelado de los datos del usuario enviados a Firestore
class Datos {
  String userId;
  late String name;
  late int age;
  late String ubicacion;
  late String sexo;
  late String fechaRegistro;

  Datos({
    this.userId = '',
    required this.name,
    required this.age,
    required this.ubicacion,
    required this.sexo,
    required this.fechaRegistro,
  });
  /// Convierte el objeto Datos a un mapa JSON
  Map<String, dynamic> toJson() => {
    'id' : userId,
    'name' : name,
    'age' : age,
    'ubicacion' : ubicacion,
    'sexo' : sexo,
    'fechaRegistro' : fechaRegistro,
  };
}