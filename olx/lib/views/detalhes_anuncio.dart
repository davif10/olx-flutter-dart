import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/anuncio.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class DetalhesAnuncio extends StatefulWidget {
  DetalhesAnuncio({Key? key, required this.anuncio}) : super(key: key);

  Anuncio? anuncio;

  @override
  State<DetalhesAnuncio> createState() => _DetalhesAnuncioState();
}

class _DetalhesAnuncioState extends State<DetalhesAnuncio> {
  late Anuncio _anuncio;
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    _anuncio = widget.anuncio!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anúncio"),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 250,
                child: _carouselCustom(),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "R\$ ${_anuncio.preco}",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: temaPadrao.primaryColor),
                    ),
                    Text(
                      "${_anuncio.titulo}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      "Descrição",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${_anuncio.descricao}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      "Contato",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 70),
                      child: Text(
                        "${_anuncio.telefone}",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: temaPadrao.primaryColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Ligar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                onTap: () {
                  _ligarTelefone(_anuncio.telefone);
                },
              ))
        ],
      ),
    );
  }

  _ligarTelefone(String telefone) async{
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: telefone,
    );
    if(await canLaunchUrl(launchUri)){
      await launchUrl(launchUri);
    }else{
      print("Não pode fazer a ligação");
    }
  }

  _carouselCustom() {
    return Column(children: [
      Expanded(
        child: CarouselSlider(
          items: _getListaImagens(),
          carouselController: _controller,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _anuncio.fotos.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 12.0,
              height: 12.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: temaPadrao.primaryColor
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ]);
  }

  List<Widget> _getListaImagens() {
    List<String> listaUrlImagens = _anuncio.fotos;
    return listaUrlImagens.map((url) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: NetworkImage(url), fit: BoxFit.scaleDown)),
      );
    }).toList();
  }
}
