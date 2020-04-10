import 'package:flutter/material.dart';
import 'package:covid/ui/home_page.dart';

void main(){
  runApp(MaterialApp(

    theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black ,
        cardColor: Colors.red[800],
        scaffoldBackgroundColor: Colors.red[900],
        backgroundColor: Colors.white
    ),
    themeMode: ThemeMode.system,
    darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white70 ,
        cardColor: Colors.red[900],
        scaffoldBackgroundColor: Colors.black12,
        backgroundColor: Colors.white12
    ),

    home: Home(),
  ));
}

