/// Autor: Brian Alexander Flores Lopez, Universidad de Almeria
/// Fecha: 1/06/23
/// Version 1.0
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:confortu/controller/registro_controller.dart';
import 'package:confortu/controller/simple_ui_controller.dart';
import 'package:confortu/model/usuario_registro_model.dart';
import 'package:confortu/view/widgets/logoHorizontalUAL.dart';
import '../utils/styles.dart';
import '../widgets/widgetLogoInicio.dart';
import '../widgets/widgetLogoARMxUAL.dart';

/// La clase Registro define los elementos que se muestrán en la interfaz de registro
class Registro extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const Registro({Key? key, required this.onClickedSignIn}) : super(key: key);

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  /// Se definen las variables usadas en la clase
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final RegistroController _controller = RegistroController();


  @override
  void dispose() { /// Método que libera los recursos cuando ya no son necesarios
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  @override
  /// Constructor principal que es la raíz de la ventana
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; /// Size del tamaño de la pantalla con el que se inicia la ventana
    var theme = Theme.of(context); /// Se continua el tema del contexto

    return GestureDetector( /// Se usa para detectar gestos del usuario en la pantalla
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) { /// Se define el máximo de width como 600 para el cambio de vistas de pantalla
                return _buildLargeScreen(size, simpleUIController, theme);
              } else {
                return _buildSmallScreen(size, simpleUIController, theme);
              }
            },
          )),
    );
  }

  /// Widget a construir para pantallas grandes
  Widget _buildLargeScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Column(
      children: [
        LogoHorizontal(size: size),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, simpleUIController, theme),
        ),
      ],
    );
  }

  /// Widget a construir para pantallas pequeñas
  Widget _buildSmallScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }

  /// Widget que define el cuerpo principal de la pantalla
  Widget _buildMainBody(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        size.width > 600
            ? Container()
            : LogoInicio(size: size),

        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Crear cuenta',
            style: kLoginTitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Regístrate',
            style: kLoginSubtitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
              key: formKey,
              child: Column(children: [
                /// Primer campo del correo
                TextFormField(
                  style: kTextFormFieldStyle(),
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Introduce un correo electrónico válido'
                          : null,

                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'correo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// Segundo campo de la contraseña
                Obx(
                  () => TextFormField(
                    style: kTextFormFieldStyle(),
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    obscureText: simpleUIController.isObscure.value,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value != null && value.length < 6
                        ? 'Contraseña mínima de 6 caracteres'
                        : null,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          simpleUIController.isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          simpleUIController.isObscureActive();
                        },
                      ),
                      hintText: 'Contraseña',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                /// Tercer campo de confirmar contraseña
                Obx(
                  () => TextFormField(
                    controller: confirmPasswordController,
                    textInputAction: TextInputAction.done,
                    obscureText: simpleUIController.isObscure.value,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                    passwordController.text != confirmPasswordController.text
                        ? 'Contraseñas no coinciden' : null,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          simpleUIController.isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          simpleUIController.isObscureActive();
                        },
                      ),
                      hintText: 'Confirmar Contraseña',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                const Text(
                  'Crear una cuenta significa que está de acuerdo con los términos de servicio y nuestra política de privacidad.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// SignUp Button
                signUpButton(theme),

                SizedBox(
                  height: size.height * 0.03,
                ),
                RichText( /// Uso de onClickedSignIn para cambiar de pantalla entre Inicio y Registro
                  text: TextSpan(
                    style: kHaveAnAccountStyle(size),
                    text: '¿Ya tienes una cuenta? ',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn,
                        text: 'Iniciar Sesión',
                        style: kLoginOrSignUpTextStyle(size),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                LogoUAL(size: size),

                SizedBox(
                  height: size.height * 0.02,
                ),

              ])),
        ),
      ],
      )
    );
  }

  /// SignUp Button
  Widget signUpButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: (){ /// Se guardan los datos del registro en el objeto usuarioModel
          final usuarioModel = UsuarioModel(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
          );
          _controller.signUp(usuarioModel, context, formKey); /// Se llama al signUp con el controlador de la clase registro_controller
        },
        child: Text('Registrarse',
        style: kTextFormFieldBackGround(),
        ),
      ),
    );
  }
}

