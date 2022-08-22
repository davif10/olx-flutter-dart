import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/anuncio.dart';
import 'package:olx/views/widgets/item_anuncio.dart';

class MeusAnuncios extends StatefulWidget {
  const MeusAnuncios({Key? key}) : super(key: key);

  @override
  State<MeusAnuncios> createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String? _idUsuarioLogado;

  @override
  void initState() {
    super.initState();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    var carregandoDados = Center(
      child: Column(
        children: [Text("Carregando anúncios"), CircularProgressIndicator()],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Meus anúncios"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text("Adicionar"),
        onPressed: () {
          Navigator.pushNamed(context, "/novo-anuncio");
        },
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return carregandoDados;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Erro ao carregar os dados!");
              }

              QuerySnapshot querySnapshot = snapshot.data;

              return ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (_, indice) {
                    List<DocumentSnapshot> anuncios = querySnapshot.docs.toList();
                    DocumentSnapshot documentSnapshot = anuncios[indice];
                    Anuncio anuncio = Anuncio.fromDocumentSnaphot(documentSnapshot);
                    return ItemAnuncio(
                      anuncio: anuncio,
                      onPressedRemover: (){
                        showDialog(context: context, builder: (context){
                          return AlertDialog(
                            title: Text("Confirmar"),
                            content: Text("Deseja realmente excluir o anúncio?"),
                            actions: [
                              TextButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.grey
                                  ),
                                  child: Text("Cancelar", style: TextStyle(color: Colors.white),)),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.red
                                  ),
                                  onPressed: (){
                                    _removerAnuncio(anuncio.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Remover", style: TextStyle(color: Colors.white),)),
                            ],
                          );
                        });
                      },
                    );
                  });
          }
        },
      ),
    );
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerAnuncios() async {
    await _recuperarDadosUsuarioLogado();

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("meus_anuncios")
        .doc(_idUsuarioLogado)
        .collection("anuncios")
        .snapshots();

    stream.listen((event) {
      _controller.add(event);
    });

    return stream;
  }

  _recuperarDadosUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;
    if (usuarioLogado != null) {
      _idUsuarioLogado = usuarioLogado.uid;
    }
  }

  _removerAnuncio(String idAnuncio){
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("meus_anuncios")
    .doc(_idUsuarioLogado)
    .collection("anuncios")
    .doc(idAnuncio)
        .delete().then((_) {
          db.collection("anuncios")
              .doc(idAnuncio)
              .delete();
    });
  }
}
