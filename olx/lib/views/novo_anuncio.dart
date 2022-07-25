import 'package:flutter/material.dart';
import 'package:olx/views/widgets/botao_customizado.dart';
import 'dart:io';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({Key? key}) : super(key: key);

  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  final _formKey = GlobalKey<FormState>();
  List<File> _listaImagens = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo anúncio"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  FormField<List>(
                    initialValue: _listaImagens,
                      builder: (state){
                        return Column(
                          children: [
                            Container(
                              height: 100,
                              child: ListView.builder(
                                  itemCount: _listaImagens.length + 1,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index){
                                  if(index == _listaImagens.length){
                                    return Padding(padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: GestureDetector(
                                        onTap: (){
                                          _selecionarImagemGaleria();
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey[400],
                                          radius: 50,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_a_photo,
                                                size: 40,
                                                color: Colors.grey[100],
                                              ),
                                              Text("Adicionar",
                                              style: TextStyle(
                                                color: Colors.grey[100]
                                              ),)
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  if(_listaImagens.length > 0){

                                  }
                                  return Container();
                              }),
                            ),
                            if(state.hasError)
                              Container(
                                child: Text("[${state.errorText}]", style: TextStyle(fontSize: 14, color: Colors.red),),
                              ),
                          ],
                        );
                      },
                    validator: (imagens){
                      if(imagens!.isEmpty){
                        return "Necessário selecionar uma imagem";
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Text("Estado"),
                      Text("Categoria")
                    ],
                  ),
                Text("Caixas de Texto"),
                BotaoCustomizado(texto: "Cadastrar anúncio", onPressed: (){
                  if(_formKey.currentState!.validate()){

                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selecionarImagemGaleria(){

  }
}
