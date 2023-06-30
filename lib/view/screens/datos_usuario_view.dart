/// Autor: Brian Alexander Flores Lopez, Universidad de Almeria
/// Fecha: 1/06/23
/// Version 1.0
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:confortu/controller/simple_ui_controller.dart';
import '../../controller/data_controller.dart';
import 'opinion_usuario_view.dart';
import '../../model/data_model.dart';
import 'package:intl/intl.dart';

/// La clase FormaDatos define el usuario y los datos iniciales que se necesitan saber del usuario
class FormaDatos extends StatefulWidget {
  const FormaDatos({Key? key}) : super(key: key);

  @override
  _FormaDatosState createState() => _FormaDatosState();
}

/// Máscara que da formato a la edad de los usuarios
var ageMask = MaskTextInputFormatter(mask: '##', filter: {"#": RegExp(r'[0-9]')});

/// Enumerador que define el sexo del usuario
enum Orientacion { hombre, mujer }

class _FormaDatosState extends State<FormaDatos> {
  /// Se definen las variables que se usan en la clase
  final edadController = TextEditingController(); /// se crea el controlador de edad para tener control sobre el campo del texto
  final UserController _userController = Get.put(UserController()); /// Inicialización del controlador de UserControl
  late Datos _user; /// Creamos la variable _user del objeto Datos
  late int variableAux = 0; /// variable auxiliar para definir el sexo del usuario
  late String
      horaRegistro; /// variable que registra la hora actual que se manda el registro a la base de datos

  @override
  void initState() { /// Se inicializa _user con datos predeterminados
    super.initState();
    _user = Datos(name: '', age: 0, ubicacion: '', sexo: '', fechaRegistro: '');
  }
  /// Método para validar los datos que creamos de la clase
  @override
  void dispose() { /// Método que libera los recursos cuando ya no son necesarios
    edadController.dispose();
    super.dispose();
  }
  String dropdownvalue = 'Nave'; /// Variable inicial que sale de fondo
  Orientacion? _ori = Orientacion.hombre; /// Variable inicial que se selecciona por defecto

  /// Lista de los elementos del menú dropdown
  var items = [
    'Nave',
    'Laboratorio 1',
    'Laboratorio 2',
    'Laboratorio 4',
    'Laboratorio 5',
    'Laboratorio 6',
    'Laboratorio 7',
    'Laboratorio 8',
    'Despacho 030',
    'Despacho 050',
    'Despacho 070',
    'Despacho 090',
    'Despacho 110',
    'Cocina',
    'Sala Juntas',
    'Despacho Director'
  ];

  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  @override
  /// Constructor principal que es la raíz de la ventana, sigue misma funcionolidad que las demás clases
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; /// Se define el tamaño y el tema de la vista
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar( /// Título de la appbar
        title: const Text("Datos Usuario CIESOL"),
      ),
      body: GestureDetector( /// Se usa para detectar los gestos del usuario en la pantalla
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) { /// Si el ancho de la pantalla es superior a 600 se llama al widget large, sino al small
                return _buildLargeScreen(size, simpleUIController, theme);
              } else {
                return _buildSmallScreen(size, simpleUIController, theme);
              }
            },
          )),
      ),
    );
  }
  /// Se construye este widget si el width es superior a 600 (pantallas grandes)
  Widget _buildLargeScreen(Size size, SimpleUIController simpleUIController,
      ThemeData theme) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: size.height * 0.40,
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/logoCiesolUAL.png',
              height: size.height * 0.35,
              width: size.width * 0.7,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.1),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, simpleUIController, theme),
        ),
      ],
    );
  }
  /// Se construye este widget si el width es inferior a 600 (pantallas pequeñas)
  Widget _buildSmallScreen(Size size, SimpleUIController simpleUIController,
      ThemeData theme) {
    return Center(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }
  /// Cuerpo principal de la pantalla
  Widget _buildMainBody(Size size, SimpleUIController simpleUIController,
      ThemeData theme) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            size.width > 600
                ? Container()
                : Container(
              height: size.height * 0.25,
              alignment: Alignment.topCenter,
              child: Icon(
                ///Icons.create_outlined,
                Icons.account_circle,
                size: size.height *0.25,
                color: Colors.blueAccent,
              ),
            ),

            SizedBox(
              height: size.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Column(children: [
                    /// Mirar si es por el container que no sale si falta
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: edadController,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [ageMask],
                        keyboardType: TextInputType.number,
                        ///autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: const TextStyle(fontSize: 20),
                        validator: (value) => value ==null ? '*' : null,
                        decoration: const InputDecoration(
                            hintText: "Edad", border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),

                    /// Columna donde se definen las 2 opciones a seleccionar del sexo
                    Column(
                      children: <Widget>[

                        ListTile(
                          title: const Align(
                            alignment: Alignment.centerLeft, // Cambiar a todos los Textos por igual
                            child: Text('Hombre'),
                          ),
                          leading: Radio<Orientacion>(
                            value: Orientacion.hombre,
                            visualDensity: VisualDensity.compact,
                            groupValue: _ori,
                            onChanged: (Orientacion? value) {
                              setState(() {
                                _ori = value;
                                if (_ori == null) {
                                  const Text("");
                                } else {
                                  variableAux = 0;
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        ListTile(
                          //title: const Text('Mujer'),
                          title: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Mujer'),
                          ),
                          leading: Radio<Orientacion>(
                            value: Orientacion.mujer,
                            visualDensity: const VisualDensity(
                              horizontal: -4.0,
                            ),
                            groupValue: _ori,
                            onChanged: (Orientacion? value) {
                              setState(() {
                                _ori = value;
                                if (_ori == null) {
                                  const Text("");
                                } else {
                                  variableAux = 1;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),

                    /// Botón de la lista despligable
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20.0, right: 20)),
                      value: dropdownvalue, /// Value inicicial que tendra por defecto
                      items: items.map((String items) {  /// El array con la lista de elementos
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: const TextStyle(fontSize: 22.0),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                        _user.ubicacion = dropdownvalue; /// Asignamos al objeto _user el valor de la ubicación seleccionada
                      },
                    ),
                    SizedBox(
                      height: size.height*0.03,
                    ),
                    /// Se usa el botón de envío de datos
                    sendData(theme),
                    SizedBox(
                      height: size.height * 0.02,
                    ),

                  ])),
          ],
        ),
    );
  }
  bool isDataFilled(){ /// Método para comprobar si los 2 campos están completos
    if(edadController.text.isEmpty || _user.ubicacion.isEmpty){
      return false;
    }
    return true;
  }
  /// Widget donde se define el botón de enviar datos
  Widget sendData(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
          icon: const Icon(Icons.arrow_forward_ios, size: 32),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
            //deepPurpleAccent
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), /// 15
              ),
            ),
          ),
          label: const Text(
            'Enviar datos', // Poner asi o con child Text?
            style: TextStyle(fontSize: 24),
          ),
          onPressed: () {
            if (isDataFilled()) {
              /// Se guarda la hora en la que se refistrán los datos: HH hora formato..min..seg
              horaRegistro = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
              _user.age = int.parse(edadController.text);
              _user.sexo = variableAux == 0 ? 'Hombre' : 'Mujer';
              _user.fechaRegistro = horaRegistro;
              _userController.createUserData(_user); /// Llamada al método del controlador pasándole los datos del usuario como parámetro
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FormularioUsuario()));
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.deepOrangeAccent,
                  content: Text('Por favor rellena y selecciona todos los campos.'),
                ),
              );
            }
          }
          ),
    );
  }
}

