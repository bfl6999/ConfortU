import 'package:flutter/material.dart';


class LogoHorizontal extends StatelessWidget{

  late Size size;

  LogoHorizontal({required this.size});
  @override
  Widget build (BuildContext context){
    return Expanded(
      flex: 3,
      child: Image.asset(
        'assets/images/logoHorizontalUAL.png',
        height: size.height * 0.25,
        width: size.width * 0.7,
        fit: BoxFit.fill,
      ),
    );

  }
}