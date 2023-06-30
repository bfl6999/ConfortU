/// Autor: Brian Alexander Flores Lopez, Universidad de Almeria
/// Fecha: 1/06/23
/// Version 1.0
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:confortu/controller/simple_ui_controller.dart';
import 'package:confortu/model/user_opinion_model.dart';
import '../../controller/opinion_controller.dart';
import '../utils/styles.dart';

/// La clase FormularioUsuario define las preguntas del cuestionario sobre el confort térmico de los usuarios
class FormularioUsuario extends StatefulWidget {
  const FormularioUsuario({Key? key}) : super(key: key);

  @override
  _FormularioUsuarioState createState() => _FormularioUsuarioState();
}

/// Se definen el tipo de datos del PMV, la ropa y la actividad
enum Pmv {
  one(1),
  two(2),
  three(3),
  zero(0),
  lessone(-1),
  lesstwo(-2),
  lessthree(-3);

  const Pmv(this.value);
  final int value;
}

int varAux = 0;

enum Ropa {
  corta,
  larga,
  abrigada;
}

enum Actividad {
  sedentaria,
  ligera,
  media;
}

/// Se dejan por defecto las variables que mas en la época serían las más probables
Actividad? _actividad = Actividad.ligera;
Ropa? _ropa = Ropa.corta;
Pmv? _ejemplo = Pmv.zero;

class _FormularioUsuarioState extends State<FormularioUsuario> {
  /// Se inicializa el controlador y se crea el objeto de Opiniones
  final OpinionController _opinionController = Get.put(OpinionController());
  late Opiniones _opiniones;
  late String horaRegistro;

  @override
  void initState() {
    /// Se inicializa el objeto Opiniones con valores por defecto
    super.initState();
    _opiniones = Opiniones(opinion: 0, ropa: 0.0, actividad: 0);
  }
  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  @override
  /// Constructor raiz de la pantalla de Opiniones
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuestionario Confort Térmico'),
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return _buildLargeScreen(size, simpleUIController, theme);
                } else {
                  return _buildSmallScreen(size, simpleUIController, theme);
                }
              },
            )),
      ),
    );
  }

  /// Se construye este widget si el width   es superior a 600 (pantallas grandes)
  Widget _buildLargeScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Column(
      children: [
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, simpleUIController, theme),
        ),
      ],
    );
  }

  /// Se construye este widget si el width es inferior a 600 (pantallas pequeñas)
  Widget _buildSmallScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }

  /// Widget que define el cuerpo principal de la aplicación
  Widget _buildMainBody(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
      children: [
        size.width > 600
            ? Container():
        Visibility(
          visible: true,
            child: Text(
              'Cuestionario sobre el confort térmico',
              style: kLoginTitleStyle(size),
            ),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Text(
          'Preguntas breves para conocer el grado de satisfacción de las personas '
          'con la sensación térmica. Seleccione las respuestas mas de acorde a su situación.',
          style: kFormQuestions(size),
        ),

        SizedBox(
          height: size.height * 0.03,
        ),

        Container(
          padding: const EdgeInsets.only(left: 15.0, top: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),

          /// Primera cuestión del formulario, se divide en 7 widgets de ListTile con radio buttoms
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
            Text(
              '1. ¿Se encuentra satisfecho con el ambiente térmico?',
              style: kFormQuestions(size), textAlign: TextAlign.start,
            ),
            ListTile(
              title: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Siento mucho calor'),
              ),
              contentPadding: const EdgeInsets.all(0),
              ///minLeadingWidth : 10,
              leading: Radio<Pmv>(
                value: Pmv.three,
                visualDensity: VisualDensity.compact,
                groupValue: _ejemplo,
                onChanged: (Pmv? value) {
                  setState(() {
                    _ejemplo = value;
                    if (_ejemplo != null) {
                      varAux = 3;
                    }
                  });
                },
              ),
            ),
            ListTile(
              title: const Align(
                alignment:
                Alignment.centerLeft,
                child: Text('Siento calor'),
              ),
              contentPadding: const EdgeInsets.all(0),
              leading: Radio<Pmv>(
                value: Pmv.two,
                visualDensity: VisualDensity.compact,
                groupValue: _ejemplo,
                onChanged: (Pmv? value) {
                  setState(() {
                    _ejemplo = value;
                    if (_ejemplo != null) {
                      varAux = 2;
                    }
                  });
                },
              ),
            ),
            ListTile(
              title: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Siento un poco de calor'),
              ),
              contentPadding: const EdgeInsets.all(0),
              leading: Radio<Pmv>(
                value: Pmv.one,
                visualDensity: VisualDensity.compact,
                groupValue: _ejemplo,
                onChanged: (Pmv? value) {
                  setState(() {
                    _ejemplo = value;
                    if (_ejemplo != null) {
                      varAux = 1;
                    }
                  });
                },
              ),
            ),
            ListTile(
              title: const Align(
                alignment: Alignment.centerLeft, // Cambiar a todos los Textos por igual
                child: Text('Conforme'),
              ),
              contentPadding: const EdgeInsets.all(0),
              leading: Radio<Pmv>(
                value: Pmv.zero,
                visualDensity: VisualDensity.compact,
                groupValue: _ejemplo,
                onChanged: (Pmv? value) {
                  setState(() {
                    _ejemplo = value;
                    if (_ejemplo != null) {
                      varAux = 0;
                    }
                  });
                },
              ),
            ),
            ListTile(
              title: const Align(
                alignment: Alignment.centerLeft, // Cambiar a todos los Textos por igual
                child: Text('Siento un poco de frío '),
              ),
              contentPadding: const EdgeInsets.all(0),
              leading: Radio<Pmv>(
                value: Pmv.lessone,
                visualDensity: VisualDensity.compact,
                groupValue: _ejemplo,
                onChanged: (Pmv? value) {
                  setState(() {
                    _ejemplo = value;
                    if (_ejemplo != null) {
                      varAux = -1;
                    }
                  });
                },
              ),
            ),
            ListTile(
              title: const Align(
                alignment: Alignment.centerLeft, // Cambiar a todos los Textos por igual
                child: Text('Siento frío'),
              ),
              contentPadding: const EdgeInsets.all(0),
              leading: Radio<Pmv>(
                value: Pmv.lesstwo,
                visualDensity: VisualDensity.compact,
                groupValue: _ejemplo,
                onChanged: (Pmv? value) {
                  setState(() {
                    _ejemplo = value;
                    if (_ejemplo != null) {
                      varAux = -2;
                    }
                  });
                },
              ),
            ),
            ListTile(
              title: const Align(
                alignment: Alignment.centerLeft, // Cambiar a todos los Textos por igual
                child: Text('Siento mucho frío'),
              ),
              contentPadding: const EdgeInsets.all(0),
              leading: Radio<Pmv>(
                value: Pmv.lessthree,
                visualDensity: VisualDensity.compact,
                groupValue: _ejemplo,
                onChanged: (Pmv? value) {
                  setState(() {
                    _ejemplo = value;
                    if (_ejemplo != null) {
                      varAux = -3;
                    }
                  });
                },
              ),
            ),
          ]),
        ),

        SizedBox(
          height: size.height * 0.05,
        ),

        /// Contenedor que define el tamaño de la segunda pregunta y a su vez divide cada widget en filas y columnas
        Container(
          height: size.height *0.70,
          ///width: size.width*0.95,
          padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '2. ¿Qué tipo de ropa diría lleva puesta ahora?',
                  style: kFormQuestions(size), textAlign: TextAlign.start,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Image.asset(
                                'assets/images/ropaLigeraMod.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                            ),
                            ListTile(
                              title: const Align(
                                alignment: Alignment.centerLeft, // Cambiar a todos los Textos por igual
                                child: Text('Ropa ligera corta'),
                              ),
                              leading: Radio<Ropa>(
                                value: Ropa.corta,
                                visualDensity: VisualDensity.compact,
                                groupValue: _ropa,
                                onChanged: (Ropa? value) {
                                  setState(() {
                                    _ropa = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                                child: Image.asset(
                                  'assets/images/ropaLargaMod.jpg',
                                  fit: BoxFit.contain,
                                ),
                            ),
                            ),
                             ListTile(
                              title: const Align(
                                alignment: Alignment.centerLeft, // Cambiar a todos los Textos por igual
                                child: Text('Ropa larga'),
                              ),
                              leading: Radio<Ropa>(
                                value: Ropa.larga,
                                visualDensity: VisualDensity.compact,
                                groupValue: _ropa,
                                onChanged: (Ropa? value) {
                                  setState(() {
                                    _ropa = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  //flex: 33,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/images/genteConRopaAbrigadaMod.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                             ListTile(
                              title: const Align(
                                alignment: Alignment.centerLeft, // Cambiar a todos los Textos por igual
                                child: Text('Ropa abrigada'),
                              ),
                              leading: Radio<Ropa>(
                                value: Ropa.abrigada,
                                visualDensity: VisualDensity.compact,
                                groupValue: _ropa,
                                onChanged: (Ropa? value) {
                                  setState(() {
                                    _ropa = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Visibility(
                                visible: false,
                                child: Expanded(
                                  child: Image.network(
                                    'https://i.pinimg.com/550x/d9/05/63/d90563d4c01efc682f74db9c815ff831.jpg',
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
        SizedBox(
          height: size.height * 0.05,
        ),

        /// Contenedor que define el tamaño de la tercera pregunta y a su vez divide cada widget en filas y columnas (igual que el anterior)
        Container(
          //height: MediaQuery.of(context).size.height*0.50,
          height: size.height * 0.72,
          width: size.width*0.95,
          padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                /// Se definen los bordes
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                /// Se define el sombreado de contenedor y el color
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                /// Se cambia la posición de la sombra
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            Text(
              '3. ¿Cuál es la actividad mas parecida que realiza?',
              style: kFormQuestions(size),textAlign: TextAlign.start,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Expanded(
              //flex: 33,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Image.asset(
                            'assets/images/actividadSedentariaMod.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        ),
                        ListTile(
                          title: const Align(
                            alignment: Alignment.centerLeft, // Cambiar a todos los Textos por igual
                            child: Text('Actividad sedentaria'),
                          ),
                          leading: Radio<Actividad>(
                            value: Actividad.sedentaria,
                            visualDensity: VisualDensity.compact,
                            groupValue: _actividad,
                            onChanged: (Actividad? value) {
                              setState(() {
                                _actividad = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Image.asset(
                            'assets/images/actividadLigeraMod.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        ),
                        ListTile(
                          title: const Align(
                            alignment: Alignment.centerLeft, // Cambiar a todos los Textos por igual
                            child: Text('Actividad ligera'),
                          ),
                          leading: Radio<Actividad>(
                            value: Actividad.ligera,
                            visualDensity: VisualDensity.compact,
                            groupValue: _actividad,
                            onChanged: (Actividad? value) {
                              setState(() {
                                _actividad = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              //flex: 33,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Image.asset(
                            'assets/images/actividadMediaMod.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        ),
                        ListTile(
                          title: const Align(
                            alignment: Alignment.centerLeft, // Cambiar a todos los Textos por igual
                            child: Text('Actividad media'),
                          ),
                          leading: Radio<Actividad>(
                            value: Actividad.media,
                            visualDensity: VisualDensity.compact,
                            groupValue: _actividad,
                            onChanged: (Actividad? value) {
                              setState(() {
                                _actividad = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Visibility(
                            visible: false,
                            child: Expanded(
                              child: Image.network(
                                'https://i.pinimg.com/550x/d9/05/63/d90563d4c01efc682f74db9c815ff831.jpg',
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),

        SizedBox(
          height: size.height * 0.03,
        ),

        /// Uso del botón de envío de datos
        sendData(theme),
        SizedBox(
          height: size.height * 0.02,
        ),

        /// Uso del botón de cerrar sesión
        closeSesion(theme, onCloseSession: () {
          Navigator.pop(context);
        }),
        SizedBox(
          height: size.height * 0.02,
        )
      ],
      ),
    );
  }

  /// Widget que define el botón de cerrar sesión
  Widget closeSesion(ThemeData theme, {VoidCallback? onCloseSession}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.redAccent),
            //deepPurpleAccent
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          icon: const Icon(Icons.arrow_back_ios, size: 32),
          //Icons.logout_outlined,
          label: const Text(
            'Cerrar Sesión',
            style: TextStyle(fontSize: 24),
          ),
          onPressed: () {
            /// Llamada a la función cerrar sesión del controlador de la página
            _opinionController.closeSession(onCloseSession, context);
          }),
    );
  }

  /// Widget que definde el botón de envíar datos
  Widget sendData(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
          icon: const Icon(Icons.arrow_forward_ios, size: 32),
          label: const Text(
            'Enviar respuestas',
            style: TextStyle(fontSize: 24),
          ),
          onPressed: () async {
            horaRegistro = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

            /// Definimos los valores del objeto Opiniones y llamamos al método del controlador para envíar los datos
            _opiniones.opinion = varAux;
            _opiniones.ropa =
                _opinionController.convertToClothe(_ropa.toString());
            _opiniones.actividad =
                _opinionController.convertToIntActivity(_actividad.toString());
            _opinionController.preSendOpinions(_opiniones, context, horaRegistro);
          }),
    );
  }
}
