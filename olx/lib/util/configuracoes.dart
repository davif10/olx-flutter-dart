import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Configuracoes{

  static List<DropdownMenuItem<String>> getCategorias(){

    List<DropdownMenuItem<String>> itensDrogCategorias = [];

    itensDrogCategorias.add(DropdownMenuItem(
      child: Text("Categoria", style: TextStyle(color: temaPadrao.primaryColor),),
      value: null,
    ));
    itensDrogCategorias.add(DropdownMenuItem(
      child: Text("Automóvel"),
      value: "auto",
    ));
    itensDrogCategorias.add(DropdownMenuItem(
      child: Text("Comida"),
      value: "comida",
    ));
    itensDrogCategorias.add(DropdownMenuItem(
      child: Text("Eletrônicos"),
      value: "eletro",
    ));

    itensDrogCategorias.add(DropdownMenuItem(
      child: Text("Moda"),
      value: "moda",
    ));
    itensDrogCategorias.add(DropdownMenuItem(
      child: Text("Esportes"),
      value: "esportes",
    ));

    return itensDrogCategorias;
  }

  static List<DropdownMenuItem<String>> getEstados(){

    List<DropdownMenuItem<String>> itensDrogRegiao = [];

    itensDrogRegiao.add(DropdownMenuItem(
      child: Text("Região", style: TextStyle(color: temaPadrao.primaryColor),),
      value: null,
    ));

    for (var estado in Estados.listaEstadosSigla) {
      itensDrogRegiao.add(DropdownMenuItem(
        child: Text(estado),
        value: estado,
      ));
    }

    return itensDrogRegiao;
  }

}