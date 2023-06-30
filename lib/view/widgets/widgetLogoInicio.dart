import 'package:flutter/material.dart';


class LogoInicio extends StatelessWidget{

  late Size size;

  LogoInicio({required this.size});
  @override
  Widget build (BuildContext context){
    return Container(
      height: size.height * 0.25,
      padding: const EdgeInsets.only(top: 0.0),
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/logotipoUAL02.png',
        height: size.height * 0.25,
        width: size.width * 0.7,
      ),
    );

  }
}