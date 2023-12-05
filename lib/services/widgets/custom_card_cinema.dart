import 'package:app_sweet_cine/model/cinema_model.dart';
import 'package:app_sweet_cine/pages/cinemas/perfil_cinema_page.dart';
import 'package:app_sweet_cine/services/formatacoes_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomCardCinema extends StatefulWidget{
  CinemaModel cinema;
  Function () carregarDados;
  CustomCardCinema({super.key, required this.cinema, required this.carregarDados});
  
  @override
  State<CustomCardCinema> createState() => _CustomCardCinemaState();
}

class _CustomCardCinemaState extends State<CustomCardCinema>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){

    return InkWell(
      onTap: () async {
        await showDialog(
          context: context, 
          builder: (_){
            return PerfilCinemaPage(cinema: widget.cinema);
          }
        );
        widget.carregarDados();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.white12,
          width: 390,
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                height: 200,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 84, 84, 84),
                  image: widget.cinema.fotoDoCinema.isEmpty || !FormatacoesService.urlValido(widget.cinema.fotoDoCinema) ? 
                  const DecorationImage(
                    image: AssetImage("assets/popcorn.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Color.fromARGB(50, 15, 26, 32), 
                      BlendMode.darken
                    )
                  )
                  :
                  DecorationImage(
                    image: NetworkImage(widget.cinema.fotoDoCinema),
                    fit: BoxFit.cover,
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromARGB(228, 244, 67, 54),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.anton(color: Colors.white, fontSize: 15),
                          text: "Filmes: ",
                          children: [
                            TextSpan(
                              style: GoogleFonts.montserrat(color: Colors.white),
                              text: widget.cinema.filmesAssistidos.toString()
                            )
                          ]
                        )
                      ),
                    )
                  ],
                ),
              ),
      
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListEstrelas(quantidade: widget.cinema.nota, tamanhoIcon: 25),
                    const SizedBox(height: 10),
                    Text(widget.cinema.nome, style: GoogleFonts.anton(color: Colors.white, fontSize: 17)),
                    const SizedBox(height: 15),
                    Text(widget.cinema.bairro, style: GoogleFonts.montserrat(color: Colors.white)),
                    Text(widget.cinema.cidade, style: GoogleFonts.montserrat(color: Colors.white))
                  ],
                ),
              )
      
            ],
          ),
        ),
      )

    ); 
  }
}