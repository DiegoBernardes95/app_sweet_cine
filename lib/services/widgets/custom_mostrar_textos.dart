import 'package:animate_do/animate_do.dart';
import 'package:app_sweet_cine/services/formatacoes_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomMostrarTextos extends StatefulWidget {
  String titulo;
  String imagemBackground;
  String texto;
  CustomMostrarTextos({super.key, required this.titulo, required this.imagemBackground, required this.texto});

  @override
  State<CustomMostrarTextos> createState() => _CustomMostrarTextosState();
}

class _CustomMostrarTextosState extends State<CustomMostrarTextos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: widget.imagemBackground.isNotEmpty || FormatacoesService.urlValido(widget.imagemBackground) ? 
          DecorationImage(
            image: NetworkImage(widget.imagemBackground),
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(Color.fromARGB(196, 0, 0, 0), BlendMode.darken)
          )
          :
          const DecorationImage(
            image: AssetImage("assets/scratch.png"),
            fit: BoxFit.cover
          )
        ),
        child: Container(
          decoration: widget.titulo == "Na minha opinião..." ? 
          const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          )
          :
          const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            children: [
              FadeInDown(from: 20, child: Text(widget.titulo, style: GoogleFonts.anton(color: Colors.white, fontSize: 22))),
              const Divider(color: Colors.red),
              const SizedBox(height: 30),
        
              FadeInLeft(
                from: 20,
                delay: const Duration(milliseconds: 400),
                child: Text(widget.texto, style: GoogleFonts.molengo(color: Colors.white, fontSize: 16.9))
              )
            ],
          ),
        ),
      ),
    );
  }
}