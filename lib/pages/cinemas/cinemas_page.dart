import 'package:animate_do/animate_do.dart';
import 'package:app_sweet_cine/model/cinema_model.dart';
import 'package:app_sweet_cine/pages/registro/registro_cinema_pages.dart';
import 'package:app_sweet_cine/repositories/cinema_repository.dart';
import 'package:app_sweet_cine/repositories/filme_repository.dart';
import 'package:app_sweet_cine/services/formatacoes_services.dart';
import 'package:app_sweet_cine/services/widgets/custom_btn_add.dart';
import 'package:app_sweet_cine/services/widgets/custom_card_cinema.dart';
import 'package:app_sweet_cine/services/widgets/custom_drawer.dart';
import 'package:app_sweet_cine/services/widgets/custom_logoApp.dart';
import 'package:app_sweet_cine/services/widgets/custom_sistema_de_busca.dart';
import 'package:app_sweet_cine/services/widgets/custom_tela_de_carregamento.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CinemaPage extends StatefulWidget {
  const CinemaPage({super.key});

  @override
  State<CinemaPage> createState() => _CinemaPageState();
}

class _CinemaPageState extends State<CinemaPage> {
  CinemaRepository cinemaRepository = CinemaRepository();
  FilmeRepository filmeRepository = FilmeRepository();
  bool carregando = false;
  bool buscarCinema = false;
  var cinemaController = TextEditingController(text: '');
  List<CinemaModel> cinemasFiltrados = [];

  String dataFormatada = "";

  @override
  void initState() {
    carregarDados(true);
    super.initState();
  }

  Future<void> carregarDados(bool mostrarCarregamento) async{
    setState(() {
      if(mostrarCarregamento){
        carregando = true;
      }
    });

    final cinemaRepository = Provider.of<CinemaRepository>(context, listen: false);
    final filmeRepository = Provider.of<FilmeRepository>(context, listen: false);
    await cinemaRepository.obterDados();
    await filmeRepository.obterUltimoFilme();
    cinemasFiltrados = cinemaRepository.cinemas;
    buscarCinema = false;

    setState(() {
      if(mostrarCarregamento){
        carregando = false;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // PROVIDER CINEMAS
    final listCinema = Provider.of<CinemaRepository>(context, listen: false);
    final lastFilme = Provider.of<FilmeRepository>(context, listen: false);
    listCinema.cinemas.sort((a, b) => b.filmesAssistidos.compareTo(a.filmesAssistidos));
    dataFormatada = FormatacoesService.dataFormatada(lastFilme.ultimoFilme.data);

    return Scaffold(
      appBar: AppBar(
        title: CustomLogoApp(fontSizeTitle: 22, fontSizeSubtitle: 17),
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context, 
                builder: (_){
                  return RegistroCinemaPage(cinemaModel: CinemaModel.vazio());
                }
              );
              carregarDados(true);
            }, 
            icon: const Icon(Icons.add_comment_outlined, color: Colors.white)
          )
        ],
      ),
      drawer: const CustomDrawer(),
      body: carregando ?

      TelaDeCarregamento(mostrarBackground: true)
      
      :
      
      RefreshIndicator(
        onRefresh: () => carregarDados(true),
        strokeWidth: 3,
        color: Colors.red,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/scratch.png"),
              fit: BoxFit.cover
            ),
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Color.fromARGB(0, 15, 26, 32),
              ]
            )
          ),
          child: ListView(
            children: [

              Container(
                height: 340,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(198, 84, 84, 84),
                  image: lastFilme.ultimoFilme.poster.isEmpty || !FormatacoesService.urlValido(lastFilme.ultimoFilme.poster) ?
                  const DecorationImage(
                    image: AssetImage('assets/popcorn.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Color.fromARGB(139, 15, 26, 32), 
                      BlendMode.darken
                    )
                  ) 
                  : 
                  DecorationImage(
                    image: NetworkImage(lastFilme.ultimoFilme.poster),
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                      Color.fromARGB(139, 15, 26, 32), 
                      BlendMode.darken
                    )
                  )
                ),
                child: lastFilme.filmes.isEmpty ? 
                FadeInRight(
                  from: 20, 
                  child: CustomLogoApp(fontSizeTitle: 35, fontSizeSubtitle: 25)
                )
                :
                FadeInRight(
                  from: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Último cinema frequentado:", style: GoogleFonts.montserrat(color: Colors.amber)),
                      Text(lastFilme.ultimoFilme.cinemaAssistido == "" ? "Cinema desconhecido" : lastFilme.ultimoFilme.cinemaAssistido, style: GoogleFonts.anton(color: Colors.white, fontSize: 22)),
                      const SizedBox(height: 10),
                      Text("em", style: GoogleFonts.montserrat(color: Colors.amber)),
                      const SizedBox(height: 10),
                      Text(dataFormatada == '' ? 'Data desconhecida' : dataFormatada, style: GoogleFonts.anton(color: Colors.white, fontSize: 17)),
                    ],
                  ),
                ),
              ),
        
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(167, 0, 0, 0), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  )
                ),
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    FadeInLeft(from: 20, child: Text("Confira abaixo sua lista de cinemas frequentados:", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15), textAlign: TextAlign.center,)),
                    const SizedBox(height: 20),
                    FadeInRight(from: 20, child: Text("Clique em um dos cards para exibir a lista de filmes assistidos naquele cinema.", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16), textAlign: TextAlign.center)),
                    const SizedBox(height: 50),

                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                    
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FadeInDown(from: 20, child: Text("Cinemas", style: GoogleFonts.anton(color: Colors.white, fontSize: 19))),
                                FadeInRight(from: 20, child: const SizedBox(width: 50, child: Divider(color: Colors.red)))
                              ],
                            ),
                          ),
                    
                          buscarCinema ?
                    
                          Expanded(
                            flex: 2,
                            child: CustomSistemaDeBusca(
                              setController: (value){
                                cinemaController.text = value.text;
                              }, 
                              busca: (){
                                setState(() {
                                  cinemasFiltrados = listCinema.cinemas.where((cinema) => cinema.nome.toLowerCase().contains(cinemaController.text.trim().toLowerCase())).toList();
                                });
                              }, 
                              sairDaBusca: (){
                                buscarCinema = false;
                                cinemasFiltrados = listCinema.cinemas;
                                setState(() {});
                              }, 
                              label: "Diga o nome do cinema..."
                            ),
                          )
                          
                          :
                          
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: IconButton(
                              onPressed: (){
                                setState(() {
                                  buscarCinema = true;
                                });
                              }, 
                              icon: const Icon(Icons.search, color: Colors.white)
                            ),
                          ),
                    
                        ],
                      ),
                    ),
        
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              style: GoogleFonts.anton(color: Colors.white, fontSize: 15),
                              text: "Total de Cinemas: ",
                              children: [
                                TextSpan(
                                  style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17),
                                  text: cinemasFiltrados.length.toString()
                                )
                              ]
                            )
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
        
                    listCinema.cinemas.isEmpty ?

                    SizedBox(
                      width: double.infinity,
                      child: CustomBtnAdd(
                        labelBtn: "Adicionar cinema", 
                        addFilmes: () async {
                          await showDialog(
                            context: context, 
                            builder: (_){
                              return RegistroCinemaPage(cinemaModel: CinemaModel.vazio());
                            }
                          );
                          carregarDados(false);
                        }
                      ),
                    )

                    :

                    cinemasFiltrados.isEmpty ?

                    SizedBox(
                      height: 320,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off_outlined, color: Colors.white, size: 70),
                          const SizedBox(height: 20),
                          Text("Nenhum cinema encontrado...", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17))
                        ],
                      ),
                    )

                    :
        
                    SizedBox(
                      height: 400,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, index) => const SizedBox(width: 40),
                        itemCount: cinemasFiltrados.length,
                        itemBuilder: (_, index){
                          var cine = cinemasFiltrados[index];
                          return FadeIn(
                            child: CustomCardCinema(
                              cinema: cine,
                              carregarDados: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                final cinemaRepository = Provider.of<CinemaRepository>(context, listen: false);
                                final filmeRepository = Provider.of<FilmeRepository>(context, listen: false);
                                await cinemaRepository.obterDados();
                                await filmeRepository.obterUltimoFilme();
                                cinemasFiltrados = cinemaRepository.cinemas;
                                buscarCinema = false;
                                setState(() {});
                              },
                            ),
                          );
                        }
                      ),
                    ),

                  ],

                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}