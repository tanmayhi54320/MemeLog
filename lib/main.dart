import 'package:blogapp/LoginPage.dart';
import 'package:blogapp/LoginRegisterPage.dart';
import 'package:blogapp/PhotoUpload.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //primaryColor: Colors.blueAccent,
      ),
      home: LoginPage(),
      //initialRoute: LoginPage.id,
      routes: {
        LoginPage.id:(context)=>HomePage(),
        HomePage.id:(context)=>PhotoUploads(),
      },
    );
  }
}

