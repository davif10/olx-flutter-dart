import 'package:flutter/material.dart';
import 'package:olx/views/widgets/botao_customizado.dart';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({Key? key}) : super(key: key);

  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  final _formKey = GlobalKey<FormState>();

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
                  // FormField(builder: builder),
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
}
