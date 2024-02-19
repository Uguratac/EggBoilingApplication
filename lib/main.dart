import 'package:egg_application/constants/constans.dart';
import 'package:egg_application/pages/egg.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eggy',
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Constants.myColor),
      ),
      home: const MyHomePage(),
    );
  }
}
