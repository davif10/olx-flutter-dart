import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/views/widgets/botao_customizado.dart';
import 'package:validadores/Validador.dart';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({Key? key}) : super(key: key);

  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  final _formKey = GlobalKey<FormState>();
  List<XFile> _listaImagens = [];
  List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  List<DropdownMenuItem<String>> _listaItensDropCategorias = [];

  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;

  @override
  void initState() {
    _carregarItensDropDown();
    super.initState();
  }

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
                  builder: (state) {
                    return Column(
                      children: [
                        Container(
                          height: 100,
                          child: ListView.builder(
                              itemCount: _listaImagens.length + 1,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                if (index == _listaImagens.length) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        _selecionarImagemGaleria();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[400],
                                        radius: 50,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_a_photo,
                                              size: 40,
                                              color: Colors.grey[100],
                                            ),
                                            Text(
                                              "Adicionar",
                                              style: TextStyle(
                                                  color: Colors.grey[100]),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (_listaImagens.length > 0) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(context: context, 
                                            builder: (context)=> Dialog(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.file(File(_listaImagens[index].path)),
                                                  TextButton(
                                                      onPressed: (){
                                                        setState((){
                                                          _listaImagens.removeAt(index);
                                                          Navigator.of(context).pop();
                                                        });
                                                      },
                                                      child: Text("Excluir", style: TextStyle(color: Colors.red),))
                                                ],
                                              ),
                                            ));
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: FileImage(File(_listaImagens[index].path)),
                                        child: Container(
                                          color: Color.fromRGBO(255,255,255,0.4),
                                          alignment: Alignment.center,
                                          child: Icon(Icons.delete, color:Colors.red),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              }),
                        ),
                        if (state.hasError)
                          Container(
                            child: Text(
                              "[${state.errorText}]",
                              style: TextStyle(fontSize: 14, color: Colors.red),
                            ),
                          ),
                      ],
                    );
                  },
                  validator: (imagens) {
                    if (imagens!.isEmpty) {
                      return "Necessário selecionar uma imagem";
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(child: Padding(
                      padding: EdgeInsets.all(8),
                      child: DropdownButtonFormField(
                        value: _itemSelecionadoEstado,
                        hint: Text("Estados"),
                        style: TextStyle(fontSize: 20,
                        color: Colors.black),
                        items: _listaItensDropEstados,
                        validator: (String? value){
                          return Validador().add(Validar.OBRIGATORIO, msg: "Campo obrigatório").valido(value);
                        },
                        onChanged: (String? value) {
                          setState((){
                            _itemSelecionadoEstado = value ?? "";
                          });
                        },
                      )
                    )),
                    Expanded(child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoCategoria,
                          hint: Text("Categorias"),
                          style: TextStyle(fontSize: 20,
                              color: Colors.black),
                          items: _listaItensDropCategorias,
                          validator: (String? value){
                            return Validador().add(Validar.OBRIGATORIO, msg: "Campo obrigatório").valido(value);
                          },
                          onChanged: (String? value) {
                            setState((){
                              _itemSelecionadoCategoria = value ?? "";
                            });
                          },
                        )
                    )),
                  ],
                ),
                Text("Caixas de Texto"),
                BotaoCustomizado(
                    texto: "Cadastrar anúncio",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {}
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selecionarImagemGaleria() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imagemSelecionada =
        await _picker.pickImage(source: ImageSource.gallery);
    if (imagemSelecionada != null) {
      setState((){
        _listaImagens.add(imagemSelecionada);
      });
    }
  }

  _carregarItensDropDown(){

    _listaItensDropCategorias.add(
      DropdownMenuItem(child: Text("Automóvel"), value: "auto",)
    );
    _listaItensDropCategorias.add(
        DropdownMenuItem(child: Text("Imóvel"), value: "imovel",)
    );
    _listaItensDropCategorias.add(
        DropdownMenuItem(child: Text("Eletrônicos"), value: "eletro",)
    );

    _listaItensDropCategorias.add(
        DropdownMenuItem(child: Text("Moda"), value: "moda",)
    );
    _listaItensDropCategorias.add(
        DropdownMenuItem(child: Text("Esportes"), value: "esportes",)
    );

    for(var estado in Estados.listaEstadosSigla){
      _listaItensDropEstados.add(
          DropdownMenuItem(child: Text(estado), value: estado,)
      );
    }
  }

}
