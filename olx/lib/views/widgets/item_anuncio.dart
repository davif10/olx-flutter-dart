import 'package:flutter/material.dart';

class ItemAnuncio extends StatelessWidget {
  const ItemAnuncio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 120,
                color: Colors.orange,
              ),
              Expanded(
                flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Video Game", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        Text("R\$ 1.200,80")
                      ],
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {  },
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
