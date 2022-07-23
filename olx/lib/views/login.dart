import 'package:flutter/material.dart';
import 'package:olx/models/usuario.dart';
import 'package:olx/views/input_customizado.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _cadastrar = false;
  TextEditingController _controllerEmail =
      TextEditingController(text: "teste@teste.com");
  TextEditingController _controllerSenha =
      TextEditingController(text: "12345678");

  String _mensagemErro = "";
  String _textoBotao = "Entrar";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 32),
                    child: Image.asset(
                      "images/logo.png",
                      width: 200,
                      height: 150,
                    )),
                InputCustomizado(
                  controller: _controllerEmail,
                  hint: "E-mail",
                  autofocus: true,
                  type: TextInputType.emailAddress,
                ),
                InputCustomizado(
                  controller: _controllerSenha,
                  hint: "Senha",
                  obscure: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Logar"),
                    Switch(
                      value: _cadastrar,
                      onChanged: (bool valor) {
                        setState(() {
                          _cadastrar = valor;
                          if(_cadastrar){
                            _textoBotao = "Cadastrar";
                          }else{
                            _textoBotao = "Entrar";
                          }
                        });
                      },
                    ),
                    Text("Cadastrar"),
                  ],
                ),
                TextButton(
                    onPressed: () => _validarCampos(),
                    style: TextButton.styleFrom(
                        backgroundColor: Color(0xff9c27b0),
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
                    child: Text(
                      _textoBotao,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length > 6) {

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        if(_cadastrar){
          _cadastrarUsuario(usuario);
        }else{
          _logarUsuario(usuario);
        }
      } else {
        setState(() {
          _mensagemErro = "Preencha a senha! Digite mais de 6 caracteres.";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha um e-mail válido";
      });
    }
  }
  _cadastrarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha).then((value) {
      Navigator.pushReplacementNamed(context, "/");
    });
  }

  _logarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(email: usuario.email, password: usuario.senha).then((value) {
      Navigator.pushReplacementNamed(context, "/");
    });
  }
}
