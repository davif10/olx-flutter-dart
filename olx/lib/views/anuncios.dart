import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _carregarItensDropDown();
    _verificaUsuarioLogado();
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
                        setState((){
                          _itemSelecionadoEstado = estado;
                        });
                      },
                    ),
                  ),
                )),
                Container(color: Colors.grey[200], width: 2, height: 60,),
                Expanded(
                    child: DropdownButtonHideUnderline(
                      child: Center(
                        child: DropdownButton(
                          value: _itemSelecionadoCategoria,
                          items: _listaItensDropCategorias,
                          iconEnabledColor: Color(0xff9c27b0),
                          style: TextStyle(fontSize: 22, color: Colors.black),
                          onChanged: (String? categoria) {
                            setState((){
                              _itemSelecionadoCategoria = categoria;
                            });
                          },
                        ),
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
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
