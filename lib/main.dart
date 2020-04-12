import 'package:covid/ui/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:covid/ui/home_page.dart';

void main(){
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/detail': (context) => Detail(),
    },
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

