import 'package:feszora/layout/app_theme.dart';
import 'package:feszora/page/signin.dart';
import 'package:feszora/page/welcom.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Feszora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // ignore: prefer_const_constructors
      home: WelcomePage(),
      routes: {
        '/login' : (context) => const LoginPage(),
      }
      
    );
  }
}


