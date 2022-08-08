import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/models/anuncio.dart';
import 'package:olx/views/widgets/botao_customizado.dart';
import 'package:olx/views/widgets/input_customizado.dart';
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
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _precoController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  BuildContext? _dialogContext;

  late Anuncio _anuncio;

  @override
  void initState() {
    _carregarItensDropDown();
    _anuncio = Anuncio();

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
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Image.file(File(
                                                          _listaImagens[index]
                                                              .path)),
                                                      TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              _listaImagens
                                                                  .removeAt(
                                                                      index);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          },
                                                          child: Text(
                                                            "Excluir",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ))
                                                    ],
                                                  ),
                                                ));
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: FileImage(
                                            File(_listaImagens[index].path)),
                                        child: Container(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.4),
                                          alignment: Alignment.center,
                                          child: Icon(Icons.delete,
                                              color: Colors.red),
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
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(8),
                            child: DropdownButtonFormField(
                              value: _itemSelecionadoEstado,
                              hint: Text("Estados"),
                              onSaved: (String? estado) {
                                _anuncio.estado = estado ?? "";
                              },
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                              items: _listaItensDropEstados,
                              validator: (String? value) {
                                return Validador()
                                    .add(Validar.OBRIGATORIO,
                                        msg: "Campo obrigatório")
                                    .valido(value);
                              },
                              onChanged: (String? value) {
                                setState(() {
                                  _itemSelecionadoEstado = value ?? "";
                                });
                              },
                            ))),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(8),
                            child: DropdownButtonFormField(
                              value: _itemSelecionadoCategoria,
                              hint: Text("Categorias"),
                              onSaved: (String? categoria) {
                                _anuncio.categoria = categoria ?? "";
                              },
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                              items: _listaItensDropCategorias,
                              validator: (String? value) {
                                return Validador()
                                    .add(Validar.OBRIGATORIO,
                                        msg: "Campo obrigatório")
                                    .valido(value);
                              },
                              onChanged: (String? value) {
                                setState(() {
                                  _itemSelecionadoCategoria = value ?? "";
                                });
                              },
                            ))),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
                  child: InputCustomizado(
                    controller: _tituloController,
                    hint: "Título",
                    onSaved: (String? titulo) {
                      _anuncio.titulo = titulo ?? "";
                    },
                    validator: (value) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 15.0,
                  ),
                  child: InputCustomizado(
                    controller: _precoController,
                    hint: "Preço",
                    type: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      RealInputFormatter(moeda: true)
                    ],
                    onSaved: (String? preco) {
                      _anuncio.preco = preco ?? "";
                    },
                    validator: (value) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 15.0,
                  ),
                  child: InputCustomizado(
                    controller: _telefoneController,
                    hint: "Telefone",
                    type: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                    onSaved: (String? telefone) {
                      _anuncio.telefone = telefone ?? "";
                    },
                    validator: (value) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: InputCustomizado(
                    controller: _descricaoController,
                    hint: "Descrição (200 caracteres)",
                    onSaved: (String? descricao) {
                      _anuncio.descricao = descricao ?? "";
                    },
                    validator: (value) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .maxLength(200, msg: "Máximo de 200 caracteres")
                          .valido(value);
                    },
                  ),
                ),
                BotaoCustomizado(
                    texto: "Cadastrar anúncio",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        //Salvar campos
                        _formKey.currentState?.save();

                        //Configura dialog context
                        _dialogContext = context;

                        //Salvar anuncio
                        _salvarAnuncio();
                      }
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
      setState(() {
        _listaImagens.add(imagemSelecionada);
      });
    }
  }

  _carregarItensDropDown() {
    _listaItensDropCategorias.add(DropdownMenuItem(
      child: Text("Automóvel"),
      value: "auto",
    ));
    _listaItensDropCategorias.add(DropdownMenuItem(
      child: Text("Imóvel"),
      value: "imovel",
    ));
    _listaItensDropCategorias.add(DropdownMenuItem(
      child: Text("Eletrônicos"),
      value: "eletro",
    ));

    _listaItensDropCategorias.add(DropdownMenuItem(
      child: Text("Moda"),
      value: "moda",
    ));
    _listaItensDropCategorias.add(DropdownMenuItem(
      child: Text("Esportes"),
      value: "esportes",
    ));

    for (var estado in Estados.listaEstadosSigla) {
      _listaItensDropEstados.add(DropdownMenuItem(
        child: Text(estado),
        value: estado,
      ));
    }
  }

  _abrirDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text("Salvando anúncio..."),
                )
              ],
            ),
          );
        });
  }

  _salvarAnuncio() async {
    _abrirDialog(_dialogContext!);

    //Upload imagens no Storage
    await _uploadImagens();
    //Salvar anuncio no Firestore
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;
    if (usuarioLogado != null) {
      String idUsuarioLogado = usuarioLogado.uid;

      FirebaseFirestore db = FirebaseFirestore.instance;
      db
          .collection("meus_anuncios")
          .doc(idUsuarioLogado)
          .collection("anuncios")
          .doc(_anuncio.id)
          .set(_anuncio.toMap())
          .then((_) {
        Navigator.pop(_dialogContext!);
        Navigator.pop(context);
      });
    } else {
      debugPrint("Usuário indisponível!");
    }
  }

  _uploadImagens() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    for (var imagem in _listaImagens) {
      Reference arquivo =
          pastaRaiz.child("meus_anuncios").child(_anuncio.id).child(nomeImagem);

      UploadTask uploadTask = arquivo.putFile(File(imagem.path));
      TaskSnapshot? taskSnapshot;
      await uploadTask.then((task) {
        taskSnapshot = task;
      });

      if (taskSnapshot != null) {
        String url = await taskSnapshot!.ref.getDownloadURL();
        _anuncio.fotos.add(url);
      }
    }
  }
}
