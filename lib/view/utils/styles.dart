/// Archivo donde se definen tipos de letra y estilos usados en toda la aplicación
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle kLoginTitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.060,
      fontWeight: FontWeight.bold,
    );

TextStyle kLoginSubtitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.030,
    );
TextStyle kFormQuestions(Size size) => GoogleFonts.roboto(
      fontSize: size.width * 0.037,
      fontWeight: FontWeight.w400,
    );

TextStyle kLoginTermsAndPrivacyStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: 15, color: Colors.black54, height: 1.5);

TextStyle kHaveAnAccountStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: size.height * 0.022, color: Colors.blueGrey);

TextStyle kLoginOrSignUpTextStyle(
  Size size,
) =>
    GoogleFonts.ubuntu(
      fontSize: size.height * 0.022,
      fontWeight: FontWeight.w600,
      color: Colors.blueAccent,
      decoration: TextDecoration.underline,
    );
TextStyle kLoginOrSignUpTextStyleInterrogations(
    Size size,
    ) =>
    GoogleFonts.ubuntu(
      fontSize: size.height * 0.022,
      fontWeight: FontWeight.w600,
      color: Colors.blueAccent,
    );

TextStyle kTextFormFieldStyle() => const TextStyle(color: Colors.black);

TextStyle kTextFormFieldBackGround() =>
    const TextStyle(color: Colors.white, fontSize: 18);

