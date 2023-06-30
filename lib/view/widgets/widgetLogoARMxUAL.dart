import 'package:flutter/material.dart';

class LogoUAL extends StatelessWidget{

  late Size size;

  LogoUAL({required this.size});
  @override
  Widget build (BuildContext context){
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logoARM.png',
            height: size.height * 0.06,
            width: size.width * 0.2,
          ),

          Image.asset(
            'assets/images/logoCiesolUAL.png',
            height: size.height * 0.06,
            width: size.width * 0.2,
          ),
        ]
    );

  }
}