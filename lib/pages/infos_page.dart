import 'package:app_sweet_cine/model/filme_model.dart';
import 'package:app_sweet_cine/repositories/cinema_repository.dart';
import 'package:app_sweet_cine/repositories/filme_repository.dart';
import 'package:app_sweet_cine/services/formatacoes_services.dart';
import 'package:app_sweet_cine/services/widgets/custom_drawer.dart';
import 'package:app_sweet_cine/services/widgets/custom_logoApp.dart';
import 'package:app_sweet_cine/services/widgets/custom_tela_de_carregamento.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InfosPage extends StatefulWidget {
  const InfosPage({super.key});

  @override
  State<InfosPage> createState() => _InfosPageState();
}

class _InfosPageState extends State<InfosPage> with TickerProviderStateMixin {

  CinemaRepository cinemaRepository = CinemaRepository();
  FilmeRepository filmeRepository = FilmeRepository();

  double ingressoFormatado = 0.0;
  String cinemaMaisFrequentado = "Resultado indisponível...";
  int filmesCinemaMaisFrequentado = 0;
  String generoMaisAssistido = "Nenhum gênero encontrado...";
  int filmesGeneroMaisAssistido = 0;
  bool carregando = false;


  late TabController tabController;
  int paginas = 0;

  @override
  void initState() {
    tabController = TabController(initialIndex: 2, length: 5, vsync: this);
    carregarDados(true);
    super.initState();
  }

  Future<void> carregarDados(bool mostrarCarregamento) async {
    setState(() {
      if(mostrarCarregamento){
        carregando = true;
      }
    });

    filmeRepository = Provider.of<FilmeRepository>(context, listen: false);
    cinemaRepository = Provider.of<CinemaRepository>(context, listen: false);
    await cinemaRepository.obterDados();
    await filmeRepository.obterListaDeFilmes();
    await cinemaRepository.cinemaMaisFrequentado();
    await filmeRepository.obterGeneroMaisAssistido();
    await filmeRepository.valorTotalIngressos();
    await filmeRepository.obterFilmesPorNota();

    ingressoFormatado = filmeRepository.totalIngressos.ingresso;
    cinemaMaisFrequentado = cinemaRepository.cineMaisFrequentado.nome;
    filmesCinemaMaisFrequentado = cinemaRepository.cineMaisFrequentado.filmesAssistidos;
    generoMaisAssistido = filmeRepository.generoMaisAssistido.genero;
    filmesGeneroMaisAssistido = filmeRepository.generoMaisAssistido.contadorGenero;

    setState((){
      if(mostrarCarregamento){
        carregando = false;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final infoCine = Provider.of<CinemaRepository>(context, listen: false);
    final infoFilme = Provider.of<FilmeRepository>(context, listen: false);

    infoFilme.filmePorNota.sort((a, b) => b.nota.compareTo(a.nota) == 0 ? a.data.compareTo(b.data) : b.nota.compareTo(a.nota));

    List<FilmeModel> filmesExibicao = infoFilme.filmePorNota.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: CustomLogoApp(fontSizeTitle: 22, fontSizeSubtitle: 17),
      ),
      drawer: const CustomDrawer(),
      body: carregando ?

      TelaDeCarregamento(mostrarBackground: true)

      :
      
       TabBarView(
        controller: tabController,
        children: [
      
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/popcorn.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Color.fromARGB(176, 0, 0, 0), BlendMode.darken)
              )
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Cinema", style: GoogleFonts.monoton(color: Colors.white, fontSize: 25)),
                    const SizedBox(height: 22),
                    Text("O cinema mais frequentado por você foi o...", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17)),
                    const SizedBox(height: 20),
                    Text(cinemaMaisFrequentado.isEmpty ? "Cinema não identificado" : cinemaMaisFrequentado, style: GoogleFonts.anton(color: Colors.amber, fontSize: 25)),
                    const SizedBox(height: 15,),
                    Text("com", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17)),
                    const SizedBox(height: 15),
                    RichText(
                      text: TextSpan(
                        text: filmesCinemaMaisFrequentado.toString(),
                        style: GoogleFonts.anton(color: Colors.amber, fontSize: 25),
                        children: [
                          TextSpan(text: " filmes assistidos!", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17))
                        ]
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
      
      
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/genrerInfos.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Color.fromARGB(176, 0, 0, 0), BlendMode.darken)
              )
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Gênero", style: GoogleFonts.monoton(color: Colors.white, fontSize: 25)),
                    const SizedBox(height: 22),
                    Text("O gênero mais assistido por você foi o...", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17)),
                    const SizedBox(height: 20),
                    Text(generoMaisAssistido.isEmpty ? "Gênero não encontrado" : generoMaisAssistido, style: GoogleFonts.anton(color: Colors.amber, fontSize: 25)),
                    const SizedBox(height: 15,),
                    Text("com", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17)),
                    const SizedBox(height: 15),
                    RichText(
                      text: TextSpan(
                        text: filmesGeneroMaisAssistido.toString(),
                        style: GoogleFonts.anton(color: Colors.amber, fontSize: 25),
                        children: [
                          TextSpan(text: " filmes assistidos!", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17))
                        ]
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
      
      
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/placarInfos.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Color.fromARGB(176, 0, 0, 0), BlendMode.darken)
              )
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Placar", style: GoogleFonts.monoton(color: Colors.white, fontSize: 25)),
                    const SizedBox(height: 22),
                    RichText(
                      text: TextSpan(
                        text: infoFilme.filmes.length.toString(),
                        style: GoogleFonts.anton(color: Colors.amber, fontSize: 25),
                        children: [
                          TextSpan(text: " filmes foram assistidos até o momento!", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17))
                        ]
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: infoCine.cinemas.length.toString(),
                        style: GoogleFonts.anton(color: Colors.amber, fontSize: 25),
                        children: [
                          TextSpan(text: " cinemas foram frequentados até o momento!", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17))
                        ]
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
      
      
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/ticket.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Color.fromARGB(176, 0, 0, 0), BlendMode.darken)
              )
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Ingressos", style: GoogleFonts.monoton(color: Colors.white, fontSize: 25)),
                    const SizedBox(height: 22),
                    Text("O valor total gasto em ingressos por você até o momento foi de...", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17), textAlign: TextAlign.center,),
                    const SizedBox(height: 20),
                    Text(UtilBrasilFields.obterReal(ingressoFormatado), style: GoogleFonts.anton(color: Colors.amber, fontSize: 25))
                  ],
                ),
              ),
            ),
          ),
      
      
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/cineInfos.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Color.fromARGB(176, 0, 0, 0), BlendMode.darken)
              )
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Text("Ranking", style: GoogleFonts.monoton(color: Colors.white, fontSize: 25), textAlign: TextAlign.center),
      
                    const SizedBox(height: 40),
              
                    infoFilme.filmePorNota.isEmpty ? 
                    
                    Column(
                      children: [
                        Image.asset('assets/oculos-3d.png', height: 250),
                        const SizedBox(height: 20),
                        Text("Nenhum filme encontrado...", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18)),
                      ],
                    )

                    :

                    ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (_, index) => const SizedBox(height: 10),
                      itemCount: filmesExibicao.length,
                      itemBuilder: (_, index) {
                        var filme = filmesExibicao[index];
                        return Container(
                          color: index.isOdd ? Colors.transparent : Colors.white24,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("${(index + 1).toString()}º", style: GoogleFonts.anton(color: Colors.white, fontSize: 17)),
                                    const SizedBox(width: 10),
                                    Container(
                                      height: 100,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 84, 84, 84),
                                        image: filme.poster.isEmpty || !FormatacoesService.urlValido(filme.poster) ? 
                                        const DecorationImage(
                                          image: AssetImage("assets/cameraMovie.png"),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken)
                                        )
                                        :
                                        DecorationImage(
                                          image: NetworkImage(filme.poster),
                                          fit: BoxFit.cover
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Text(filme.titulo, style: GoogleFonts.montserrat(color: Colors.white), overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 5),
                                    ListEstrelas(quantidade: filme.nota, tamanhoIcon: 20)
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(filme.nota.toString(), style: GoogleFonts.anton(color: Colors.white), textAlign: TextAlign.center,)
                              )
                            ],
                          ),
                        );
                      }
                    ),
      
                  ],
                ),
              ),
            ),
          ),
      
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        color: Colors.white,
        backgroundColor: const Color.fromARGB(255, 15, 26, 32),
        height: 75,
        activeColor: const Color.fromARGB(190, 255, 63, 63),
        items: const [  
          TabItem(
            title: "Cinema", 
            icon: Icon(Icons.theater_comedy_outlined, color: Colors.amber),
            activeIcon: Icon(Icons.theater_comedy_outlined, color: Colors.white),
          ),
          TabItem(
            title: "Gênero", 
            icon: Icon(Icons.local_movies_outlined, color: Colors.amber),
            activeIcon: Icon(Icons.local_movies_outlined, color: Colors.white),
          ),
          TabItem(
            title: "Placar",
            icon: Icon(Icons.scoreboard_outlined, color: Colors.amber), 
            activeIcon: Icon(Icons.scoreboard_outlined, color: Colors.white)
          ),
          TabItem(
            title: "Ingressos", 
            icon: Icon(Icons.attach_money_outlined, color: Colors.amber),
            activeIcon: Icon(Icons.attach_money_outlined, color: Colors.white),
          ),
          TabItem(
            title: "Ranking", 
            icon: Icon(Icons.line_axis_outlined, color: Colors.amber),
            activeIcon: Icon(Icons.line_axis_outlined, color: Colors.white)
          ),
        ],
        onTap: (value) {
         tabController.index = value;
        },
        controller: tabController,
      ),
    );
  }
}