import 'package:egg_application/egg.dart';
import 'package:flutter/material.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yumurta Haşlama Zamanlayıcısı',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
      ),
      home: const  MyHomePage(),
    );
  }
}