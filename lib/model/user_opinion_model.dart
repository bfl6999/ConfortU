/// Autor: Brian Alexander Flores Lopez, Universidad de Almeria
/// Fecha: 1/06/23
/// Version 1.0
/// Clase Opinionea que define el modelado de las opiniones del usuario enviados a Firestore
class Opiniones{
  String idOpinion;
  late int opinion;
  late double ropa;
  late int actividad;

  Opiniones({
    this.idOpinion = '',
   required this.opinion,
   required this.ropa,
   required this.actividad,
});

  /// Convierte el objeto Datos a un mapa JSON
  Map<String, dynamic> toJson() => {
    'id' :idOpinion,
    'opinion' : opinion,
    'ropa' : ropa,
    'actividad' : actividad,
  };

}