import 'package:flutter/material.dart';

import '../../models/anuncio.dart';

class ItemAnuncio extends StatelessWidget {
  Anuncio anuncio;
  VoidCallback? onTapItem;
  VoidCallback? onPressedRemover;

  ItemAnuncio({Key? key, required this.anuncio, this.onTapItem, this.onPressedRemover}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Image.network(anuncio.fotos[0], fit: BoxFit.cover,),
              ),
              Expanded(
                flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(anuncio.titulo, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        Text("R\$ ${anuncio.preco}"),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text("Região: ${anuncio.estado}",
                              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  )),
             if(this.onPressedRemover != null)
               Expanded(
                   flex: 1,
                   child: TextButton(
                     onPressed: this.onPressedRemover,
                     style: TextButton.styleFrom(
                         backgroundColor: Colors.red
                     ),
                     child: Icon(Icons.delete, color: Colors.white,),
                   )),
            ],
          ),
        ),
      ),
    );
  }
}
