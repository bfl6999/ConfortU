/// Autor: Brian Alexander Flores Lopez, Universidad de Almeria
/// Fecha: 1/06/23
/// Version 1.0
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Get dart
import 'package:confortu/controller/simple_ui_controller.dart';
import 'package:confortu/view/widgets/widgetLogoInicio.dart';
import 'package:confortu/view/widgets/widgetLogoARMxUAL.dart';
import '../widgets/logoHorizontalUAL.dart';
import '../utils/styles.dart';
import 'forgot_password_view.dart';
import 'package:confortu/controller/inicio_controller.dart';

/// La clase Inicio define los elementos que se muestrán en la interfaz de inicio
class Inicio extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const Inicio({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  _Inicio createState() => _Inicio();
}

class _Inicio extends State<Inicio> {
  /// Se definen las variables usadas en la clase
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final InicioController _controller = InicioController();

  @override
  void dispose() {
    /// Método que libera los recursos cuando ya no son necesarios
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  @override

  /// Constructor principal que es la raíz de la ventana
  Widget build(BuildContext context) {
    /// Se define el size de la pantalla y el tema del contexto
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return GestureDetector(
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
    );
  }

  /// Construye un widget para las pantallas de mas de 600
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

  /// Contruye un widget para las pantallas pequeñas
  Widget _buildSmallScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }
  /// Widget que define el cuerpo principal de la vista
  Widget _buildMainBody(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        size.width > 600
            ? Container()
            : LogoInicio(size: size),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 0.0),
          child: Text(
            'Inicio de Sesión',
            style: kLoginTitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Bienvenido/a',
            style: kLoginSubtitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
              key: formKey,
              child: Column(children: [
                /// Primer campo del correo electrónico
                TextFormField(
                  controller: emailController,
                  style: kTextFormFieldStyle(),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Introduce un correo electrónico válido'
                          : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: 'ejemplomail@gmail.com',
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

                /// LLamada al botón SignIn
                signInButton(theme),
                SizedBox(
                  height: size.height * 0.03,
                ),
                const Text(
                  'Todos los términos de servicio y política de privacidad se guían por la Universidad de Almería.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// Personalización del texto de Registro
                RichText(
                  text: TextSpan(
                    style: kHaveAnAccountStyle(size),
                    text: '¿No tienes una cuenta?  ',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                        text: 'Regístrate',
                        style: kLoginOrSignUpTextStyle(size),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),

                /// Se usa para detectar si el usuario toca la pantalla y te envía  a la pantalla de Recuperar contraseña
                GestureDetector(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '¿',
                          style: kLoginOrSignUpTextStyleInterrogations(size),
                        ),
                        TextSpan(
                          text: 'Te has olvidado la contraseña',
                          style: kLoginOrSignUpTextStyle(size),
                        ),
                        TextSpan(
                          text: '?',
                          style: kLoginOrSignUpTextStyleInterrogations(size),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ForgotPassword())),
                ),

                SizedBox(
                  height: size.height * 0.02,
                ),
              ])),
        ),

        LogoUAL(size: size),

        SizedBox(
          height: size.height * 0.02,
        ),
      ],
    )

    );
  }

  /// Se define el botón de signIn
  Widget signInButton(ThemeData theme) {
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
        onPressed: () {
          /// Llamada al método signIn del controlador del inicio de sesión
          _controller.signIn(
              emailController, passwordController, context, formKey);
        },
        child: Text(
          'Iniciar Sesión',
          style: kTextFormFieldBackGround(),
        ),
      ),
    );
  }
}
