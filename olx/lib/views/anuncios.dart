import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/views/widgets/item_anuncio.dart';

import '../models/anuncio.dart';
import '../util/configuracoes.dart';

class Anuncios extends StatefulWidget {
  const Anuncios({Key? key}) : super(key: key);

  @override
  State<Anuncios> createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  List<String> itensMenu = [];
  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;
  late List<DropdownMenuItem<String>> _listaItensDropCategorias;
  late List<DropdownMenuItem<String>> _listaItensDropEstados;
  final _controller = StreamController<QuerySnapshot>.broadcast();

  @override
  void initState() {
    super.initState();
    _carregarItensDropDown();
    _verificaUsuarioLogado();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OLX"),
        elevation: 0,
        actions: [
          PopupMenuButton(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context) {
                return itensMenu.map((item) {
                  return PopupMenuItem(value: item, child: Text(item));
                }).toList();
              })
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: DropdownButtonHideUnderline(
                  child: Center(
                    child: DropdownButton(
                      value: _itemSelecionadoEstado,
                      items: _listaItensDropEstados,
                      style: TextStyle(fontSize: 22, color: Colors.black),
                      iconEnabledColor: Color(0xff9c27b0),
                      onChanged: (String? estado) {
                        setState(() {
                          _itemSelecionadoEstado = estado;
                          _filtrarAnuncios();
                        });
                      },
                    ),
                  ),
                )),
                Container(
                  color: Colors.grey[200],
                  width: 2,
                  height: 60,
                ),
                Expanded(
                    child: DropdownButtonHideUnderline(
                  child: Center(
                    child: DropdownButton(
                      value: _itemSelecionadoCategoria,
                      items: _listaItensDropCategorias,
                      iconEnabledColor: Color(0xff9c27b0),
                      style: TextStyle(fontSize: 22, color: Colors.black),
                      onChanged: (String? categoria) {
                        setState(() {
                          _itemSelecionadoCategoria = categoria;
                          _filtrarAnuncios();
                        });
                      },
                    ),
                  ),
                ))
              ],
            ),
            StreamBuilder(
              stream: _controller.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                  case ConnectionState.done:
                    QuerySnapshot? querySnapshot =
                        snapshot.data as QuerySnapshot?;
                    if (querySnapshot == null ||
                        querySnapshot.docs.length == 0) {
                      return Container(
                        padding: EdgeInsets.all(25),
                        child: Text(
                          "Nenhum anúncio! :(",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    }

                    return Expanded(
                        child: ListView.builder(
                            itemCount: querySnapshot.docs.length,
                            itemBuilder: (_, indice) {
                              List<DocumentSnapshot> anuncios =
                                  querySnapshot.docs.toList();
                              DocumentSnapshot documentSnapshot =
                                  anuncios[indice];
                              Anuncio anuncio =
                                  Anuncio.fromDocumentSnaphot(documentSnapshot);

                              return ItemAnuncio(
                                anuncio: anuncio,
                                onTapItem: () {},
                              );
                            }));
                }
              },
            )
          ],
        ),
      ),
    );
  }

  _adicionarListenerAnuncios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db.collection("anuncios").snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _filtrarAnuncios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = db.collection("anuncios");

    if(_itemSelecionadoEstado != null){
      query = query.where("estado", isEqualTo: _itemSelecionadoEstado);
    }

    if(_itemSelecionadoCategoria != null){
      query = query.where("categoria", isEqualTo: _itemSelecionadoCategoria);
    }


    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _carregarItensDropDown() {
    _listaItensDropCategorias = Configuracoes.getCategorias();
    _listaItensDropEstados = Configuracoes.getEstados();
  }

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Meus anúncios":
        Navigator.pushNamed(context, "/meus-anuncios");
        break;
      case "Entrar / Cadastrar":
        Navigator.pushNamed(context, "/login");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }
  }

  Future _verificaUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    if (usuarioLogado == null) {
      itensMenu = ["Entrar / Cadastrar"];
    } else {
      itensMenu = ["Meus anúncios", "Deslogar"];
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushNamed(context, "/login");
  }
}
