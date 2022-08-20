import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/anuncio.dart';

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
              )
            ],
          )
        ],
      ),
    );
  }


  _carouselCustom(){
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

  List<Widget> _getListaImagens(){
    List<String> listaUrlImagens = _anuncio.fotos;
    return listaUrlImagens.map((url) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover
          )
        ),
      );
    }).toList();
  }
}
