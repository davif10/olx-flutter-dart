import 'package:cloud_firestore/cloud_firestore.dart';

class Anuncio{
  late String _id;
  late String _estado;
  late String _categoria;
  late String _titulo;
  late String _preco;
  late String _telefone;
  late String _descricao;
  late List<String> _fotos;

  Anuncio(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference anuncios = db.collection("meus_anuncios");
    this.id = anuncios.doc().id;
    _fotos = [];
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get estado => _estado;

  List<String> get fotos => _fotos;

  set fotos(List<String> value) {
    _fotos = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get preco => _preco;

  set preco(String value) {
    _preco = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
  }

  set estado(String value) {
    _estado = value;
  }
}