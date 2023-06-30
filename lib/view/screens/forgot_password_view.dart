/// Autor: Brian Alexander Flores Lopez, Universidad de Almeria
/// Fecha: 1/06/23
/// Version 1.0
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:confortu/controller/simple_ui_controller.dart';
import 'package:confortu/controller/forgot_password_controller.dart';

import '../widgets/widgetLogoARMxUAL.dart';
import '../widgets/widgetLogoInicio.dart';


/// La clase ForgotPassword define la pantalla de recuperar contraseña en la aplicación
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  /// Se definen las variables necesarias para el uso de esta ventana
  final formKeyRestart = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final ForgetPassword _forgotController = ForgetPassword();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  SimpleUIController simpleUIController = Get.put(SimpleUIController());
  @override

  /// Sigue la metodología de las otras ventanas
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
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

  /// Se construye este widget si el width es superior a 600 (pantallas grandes)
  Widget _buildLargeScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: LogoInicio(size: size),
        ),
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

  /// Cuerpo principal de la pantalla
  Widget _buildMainBody(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      children: [
        size.width > 600
            ? Container()
            : Container(
                height: size.height * 0.25,
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Icon(
                  Icons.lock_reset_outlined,
                  size: size.height * 0.25,
                  color: Colors.blueAccent,
                ),
              ),
        SizedBox(
          height: size.height * 0.02,
        ),
        const Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        const Text(
          'Introduce tu correo electrónico y te enviaremos un enlace para que puedas cambiar tu contraseña.',
          style: TextStyle(
            fontSize: 14,
            decoration: TextDecoration.none,
            color: Colors.black54,
          ),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Form(
          key: formKeyRestart,
          child: TextFormField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.disabled,
            keyboardType: TextInputType.emailAddress,
            validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? 'Introduce un correo válido'
                    : null,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email_outlined), // <-- left icon
              hintText: 'correo',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        restartPassword(theme),
        SizedBox(
          height: size.height * 0.2,
        ),
        LogoUAL(size: size),
      ],
    );
  }

  /// Widget que define el botón Restablecer Contraseña
  Widget restartPassword(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          icon: const Icon(
            Icons.email_outlined,
            size: 32,
          ),
          label: const Text('Restablecer contraseña'),
          onPressed: () {
            _forgotController.verificarEmail(
                emailController, context, formKeyRestart);
          }),
    );
  }
}
