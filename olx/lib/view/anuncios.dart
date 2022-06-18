import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Anuncios extends StatefulWidget {
  const Anuncios({Key? key}) : super(key: key);

  @override
  State<Anuncios> createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  List<String> itensMenu = [];

  @override
  void initState() {
    super.initState();
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
              itemBuilder: (context){
              return itensMenu.map((item) {
                return PopupMenuItem(
                    value: item,
                    child: Text(item)
                );
              }).toList();
          })
        ],
      ),
      body: Container(
        child: Text("Anuncios"),
      ),
    );
  }

  _escolhaMenuItem(String itemEscolhido){
    switch(itemEscolhido){
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

  Future _verificaUsuarioLogado() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    if(usuarioLogado == null){
      itensMenu = [
          "Entrar / Cadastrar"
      ];
    }else{
      itensMenu = [
        "Meus anúncios",
        "Deslogar"
      ];
    }
  }
  
  _deslogarUsuario() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushNamed(context, "/login");
  }
}
