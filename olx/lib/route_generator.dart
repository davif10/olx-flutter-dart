import 'package:flutter/material.dart';
import 'package:olx/views/anuncios.dart';
import 'package:olx/views/detalhes_anuncio.dart';
import 'package:olx/views/login.dart';
import 'package:olx/views/meus_anuncios.dart';
import 'package:olx/views/novo_anuncio.dart';

import 'models/anuncio.dart';

class RouteGenerator{
  static Route<dynamic>? generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case "/":
        return MaterialPageRoute(
            builder: (_) => Anuncios());
      case "/login":
        return MaterialPageRoute(
            builder: (_) => Login());
      case "/meus-anuncios":
        return MaterialPageRoute(
            builder: (_) => MeusAnuncios());
      case "/novo-anuncio":
        return MaterialPageRoute(
            builder: (_) => NovoAnuncio());
      case "/detalhes-anuncio":
        return MaterialPageRoute(
            builder: (_) => DetalhesAnuncio( anuncio: args as Anuncio?));
      default: _erroRota();
    }

  }

  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(
          title: Text("Tela não encontrada!"),
        ),
        body: Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}