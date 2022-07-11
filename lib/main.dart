import '../graphs/customScroll.dart';
import 'package:flutter/material.dart';
import '../graphs/homePage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.lightGreen,
            titleTextStyle: TextStyle(
                color: Colors.white,
                fontFamily: 'Lato',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 30)),
        primaryColor: Colors.lightGreen,
        primarySwatch: Colors.amber,
        fontFamily: 'Lato',
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Colors.lightGreen,
            onPrimary: Colors.white,
            secondary: Colors.amber,
            onSecondary: Colors.black,
            error: Colors.red,
            onError: Colors.white,
            surface: Colors.amberAccent,
            onSurface: Colors.black,
            background: Colors.black,
            onBackground: Colors.white),
        textTheme: const TextTheme(
          labelMedium: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Lato',
            fontStyle: FontStyle.normal,
          ),
          headline1: TextStyle(
            fontSize: 72.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lato',
          ),
          headline6: TextStyle(
            fontSize: 25.0,
            fontStyle: FontStyle.normal,
            fontFamily: 'Lato',
          ),
          bodyText2: TextStyle(fontSize: 14.0),
        ),
      ).copyWith(),
      home: HomePage(),
    );
  }
}

