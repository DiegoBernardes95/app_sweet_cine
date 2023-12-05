import 'package:app_sweet_cine/model/filme_model.dart';
import 'package:app_sweet_cine/services/formatacoes_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomListaFilmes extends StatefulWidget {
  FilmeModel filme;
  CustomListaFilmes({super.key, required this.filme});

  @override
  State<CustomListaFilmes> createState() => _CustomListaFilmesState();
}

class _CustomListaFilmesState extends State<CustomListaFilmes> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          Container(
            height: 260,
            width: 180,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 84, 84, 84),
              image: widget.filme.poster.isEmpty || !FormatacoesService.urlValido(widget.filme.poster) ? 
              const DecorationImage(
                image: AssetImage("assets/cameraMovie.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken)
              )
              :
              DecorationImage(
                image: NetworkImage(widget.filme.poster),
                fit: BoxFit.cover
              )
            ),  
          ),
          Container(
            width: 180,
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Text(widget.filme.titulo, style: GoogleFonts.anton(color: Colors.white), overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Text(widget.filme.genero.isEmpty ? "Gênero desconhecido" : widget.filme.genero, style: GoogleFonts.montserrat(color: Colors.white), overflow: TextOverflow.ellipsis),
              ],
            ),
          )
        ],
      ),
    );
  }
}