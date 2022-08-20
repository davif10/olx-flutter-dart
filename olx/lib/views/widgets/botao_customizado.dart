import 'package:flutter/material.dart';

import '../../main.dart';

class BotaoCustomizado extends StatelessWidget {
  const BotaoCustomizado(
      {Key? key,
      required this.texto,
      this.corTexto = Colors.white,
      required this.onPressed})
      : super(key: key);

  final String texto;
  final Color corTexto;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: this.onPressed,
        style: TextButton.styleFrom(
            backgroundColor: temaPadrao.primaryColor,
            padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6)
            )
        ),
        child: Text(
          this.texto,
          style: TextStyle(color: this.corTexto, fontSize: 20),
        ));
  }
}
