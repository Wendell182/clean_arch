import 'package:flutter/material.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryCollor = Color.fromRGBO(136, 14, 79, 1);
    final primaryCollorDark = Color.fromRGBO(96, 0, 39, 1);
    final primaryCollorLight = Color.fromRGBO(188, 71, 123, 1);
    return MaterialApp(
      title: '4Dev',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryCollor,
        primaryColorDark: primaryCollorDark,
        primaryColorLight: primaryCollorLight,
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: primaryCollor),
        backgroundColor: Colors.white,
        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: primaryCollor),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryCollorLight),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryCollor),
          ),
          alignLabelWithHint: true,
        ),
        buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.light(primary: primaryCollor),
          buttonColor: primaryCollor,
          splashColor: primaryCollorLight,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}
