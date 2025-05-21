import 'package:flutter/material.dart';
import 'package:gianna_flutter/src/piatti.dart';
import 'package:gianna_flutter/src/products_screen.dart';
import './src/api_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/login_new.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'errStore',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        // '/home': (context) => ItemsScreen(),
        '/product': (context) {
          final piatto = ModalRoute.of(context)!.settings.arguments as Piatto;
          return PiattoScreen(piatto);
        },
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      // home: ItemsScreen(),
    );
  }
}


