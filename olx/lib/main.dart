import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:olx/view/home.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xff9c27b0),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xff7b1fa2))
);
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp();
  } 
  runApp(MaterialApp(
    title: "OLX",
    home: Home(),
    theme: temaPadrao,
    debugShowCheckedModeBanner: false,
  ));
}
