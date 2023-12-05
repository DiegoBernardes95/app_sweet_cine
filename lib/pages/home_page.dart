import 'package:animate_do/animate_do.dart';
import 'package:app_sweet_cine/emBreve/perfil_emBreve_page.dart';
import 'package:app_sweet_cine/model/cinema_model.dart';
import 'package:app_sweet_cine/model/emBreve_model.dart';
import 'package:app_sweet_cine/model/filme_model.dart';
import 'package:app_sweet_cine/pages/cinemas/cinemas_page.dart';
import 'package:app_sweet_cine/pages/cinemas/perfil_cinema_page.dart';
import 'package:app_sweet_cine/emBreve/emBreve_page.dart';
import 'package:app_sweet_cine/pages/filmes/filmes_page.dart';
import 'package:app_sweet_cine/pages/filmes/lista_filmes_page.dart';
import 'package:app_sweet_cine/pages/filmes/perfil_filme_page.dart';
import 'package:app_sweet_cine/pages/registro/registro_cinema_pages.dart';
import 'package:app_sweet_cine/pages/registro/registro_emBreve_pages.dart';
import 'package:app_sweet_cine/pages/registro/registro_filme_pages.dart';
import 'package:app_sweet_cine/repositories/cinema_repository.dart';
import 'package:app_sweet_cine/repositories/emBreve_repository.dart';
import 'package:app_sweet_cine/repositories/filme_repository.dart';
import 'package:app_sweet_cine/services/formatacoes_services.dart';
import 'package:app_sweet_cine/services/widgets/custom_btn_add.dart';
import 'package:app_sweet_cine/services/widgets/custom_logoApp.dart';
import 'package:app_sweet_cine/services/widgets/custom_drawer.dart';
import 'package:app_sweet_cine/services/widgets/custom_placar.dart';
import 'package:app_sweet_cine/services/widgets/custom_tela_de_carregamento.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  FilmeRepository filmeRepository = FilmeRepository();
  CinemaRepository cinemaRepository = CinemaRepository();
  EmBreveRepository emBreveRepository = EmBreveRepository();
  bool changedList = true;
  bool carregando = false;

  @override
  void initState() {
    carregarDados(true);
    super.initState();
  }

  Future<void> carregarDados(bool mostrarCarregamento) async {
    setState(() {
      if(mostrarCarregamento){
        carregando = true;
      }
    });

    final cinemaRepository = Provider.of<CinemaRepository>(context, listen: false);
    final filmeRepository = Provider.of<FilmeRepository>(context, listen: false);
    final emBreveRepository = Provider.of<EmBreveRepository>(context, listen: false);
    await cinemaRepository.obterDados();
    await filmeRepository.obterListaDeFilmes();
    await filmeRepository.obterFilmesPorNota();
    await emBreveRepository.listarFilmes();

    setState(() {
      if(mostrarCarregamento){
        carregando = false;
      }
    });
  }

  @override
  Widget build(BuildContext context){
    // PROVIDER CINEMA
    final cinemasFavoritos = Provider.of<CinemaRepository>(context, listen: true);
    final listaFilmes = Provider.of<FilmeRepository>(context, listen: false);
    final emBreve = Provider.of<EmBreveRepository>(context, listen: false);

    cinemasFavoritos.cinemas.sort((a, b) => b.filmesAssistidos.compareTo(a.filmesAssistidos));
    listaFilmes.filmes.sort((a, b) => b.data.compareTo(a.data));

    List<FilmeModel> filmesExibicao = listaFilmes.filmes.take(10).toList();
    List<CinemaModel> cinemasExibicao = cinemasFavoritos.cinemas.take(10).toList();
    List<EmBreveModel> emBreveExibicao = emBreve.filmesEmBreve.where((filmes) => !filmes.assistido).take(10).toList();

    return Scaffold(
      appBar: AppBar(   
        title: CustomLogoApp(fontSizeTitle: 22, fontSizeSubtitle: 17),
      ),
      drawer: const CustomDrawer(),
      body: 
      carregando ?

      TelaDeCarregamento(mostrarBackground: true)

      :
      
      RefreshIndicator(
        color: Colors.red,
        strokeWidth: 3,
        onRefresh:() => carregarDados(true),
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
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/retro-film.png'), 
                    fit: BoxFit.cover, 
                    colorFilter: ColorFilter.mode(Color.fromARGB(158, 15, 26, 32), BlendMode.darken)
                  )
                ),
                child: FadeInRight(
                  from: 20,
                  child: Center(
                    child: CustomLogoApp(fontSizeTitle: 30, fontSizeSubtitle: 20),
                  ),
                ),
              ),
        
              CustomPlacar(
                valor1: listaFilmes.filmes.length, 
                label1: "Filmes assistidos", 
                btn1: () async {
                  listaFilmes.filmes.isEmpty ?
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.red),
                        const SizedBox(width: 5),
                        Text("Nenhum filme cadastrado...", style: GoogleFonts.montserrat(color: Colors.white)),
                      ],
                    )
                  ))
                  :
                  await showDialog(
                    context: context, 
                    builder: (_){
                      return ListaFilmesPage(generoInformado: "", listarPor: "Recente", naoListarPorCinema: true, idCinemaList: 0);
                    }
                  );
                  carregarDados(false);
                },
                valor2: cinemasFavoritos.cinemas.length.toString(), 
                label2: "Cinemas frequentados",
                btn2: () async {
                  await showDialog(
                    context: context, 
                    builder: (_){
                      return const CinemaPage();
                    }
                  );
                  carregarDados(false);
                },
              ),
        
              Container(
                padding: const EdgeInsets.only(top: 45, bottom: 63, left: 30, right: 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Color.fromARGB(0, 15, 26, 32),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  ) 
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInDown(
                      from: 20,
                      child: Text("O que é o Sweet Cine?", style: GoogleFonts.anton(color: Colors.white, fontSize: 20))
                    ),
                    FadeInRight(
                      from: 20,
                      child: const SizedBox(width: 70, child: Divider(color: Colors.red))
                    ),
                    const SizedBox(height: 20),
                    FadeInLeft(
                      from: 20,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("O Sweet Cine é o lugar perfeito para você guardar os momentos especiais que a sétima arte te proporcionou.\n\nAqui você vai poder catalogar todos os filmes que já assistiu no cinema, salvar suas informações, deixar um comentário, uma nota e ainda ter acesso a um levantamento personalizado sobre sua jornada como cinéfilo. \n\nO Sweet Cine é seu lugar para guardar o inesquecível!", style: GoogleFonts.molengo(color: Colors.white, fontSize: 17)),
                      ),
                    )
                  ],
                ),
              ),
        
              Container(
                padding: const EdgeInsets.only(bottom: 30, top: 0, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
        
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
        
                        // Exibir o ranking de filme assistidos
                        InkWell(
                          onTap: (){
                            setState(() {
                              changedList = true;
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FadeInDown(from: 20, child: Text("Lista de Filmes", style: GoogleFonts.anton(color: Colors.white, fontSize: 19))),
                              FadeInRight(from: 20, child: Visibility(visible: changedList, child: const SizedBox(width: 50, child: Divider(color: Colors.red))))
                            ],
                          ),
                        ),
        
                        // Exibir os filmes que ainda serão assistidos 
                        InkWell(
                          onTap: (){
                            setState(() {
                              changedList = false;
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FadeInDown(from: 20, child: Text("Em breve", style: GoogleFonts.anton(color: Colors.white, fontSize: 19))),
                              FadeInRight(from: 20, child: Visibility(visible: !changedList, child: const SizedBox(width: 50, child: Divider(color: Colors.red))))
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await showDialog(
                              context: context, 
                              builder: (_){
                                return changedList ? const FilmePage() : const EmBrevePage();
                              }
                            );
                            carregarDados(false);
                          }, 
                          icon: const Icon(Icons.list_rounded, color: Colors.white, size: 19)
                        )
                      ],
                    ),
                    
                    const SizedBox(height: 30),
        
                    changedList ? 
                    
                    listaFilmes.filmes.isEmpty ? 
        
                    CustomBtnAdd(
                      labelBtn: "Adicionar filme", 
                      addFilmes: () async {
                        await showDialog(
                          context: context, 
                          builder: (_){
                            return RegistroFilmePage(filmeModel: FilmeModel.vazio(), filmesEmBreve: false);
                          }
                        );
                        carregarDados(false);
                      }
                    )
        
                    :
        
                    SizedBox(
                      height: 340,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(width: 15),
                        scrollDirection: Axis.horizontal,
                        itemCount: filmesExibicao.length,
                        itemBuilder: (_, index){
                          var filme = filmesExibicao[index];
                          return FadeIn(
                            child: InkWell(
                              onTap: () async {
                                await showDialog(
                                  context: context, 
                                  builder: (_){
                                    return PerfilFilmePage(filme: filme);
                                  }
                                );
                                carregarDados(false);
                              },
                              child: SizedBox(
                                width: 180,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        height: 260,
                                        width: 180,
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
                                    ),
                                    const SizedBox(height: 10),
                                    ListEstrelas(quantidade: filme.nota, tamanhoIcon: 25),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(filme.titulo, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 13), overflow: TextOverflow.ellipsis),
                                    )
                                  ],
                                ),
                              )
                            ),
                          );
                        }
                      ),
                    )
        
                    :
      
                    emBreve.filmesEmBreve.isEmpty || emBreveExibicao.isEmpty ?
      
                    CustomBtnAdd(
                      labelBtn: "Adicionar filme", 
                      addFilmes: () async {
                        await showDialog(
                          context: context, 
                          builder: (_){
                            return RegistroEmBrevePages(filmeModel: EmBreveModel.completoVazio());
                          }
                        );
                        carregarDados(false);
                      }
                    )
      
                    :
        
                    SizedBox(
                      height: 340,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(width: 15),
                        scrollDirection: Axis.horizontal,
                        itemCount: emBreveExibicao.length,
                        itemBuilder: (_, index){
                          var filme = emBreveExibicao[index];
                          return FadeIn(
                            child: InkWell(
                              onTap: () async {
                                await showDialog(
                                  context: context, 
                                  builder: (_){
                                    return PerfilEmBrevePage(emBreveModel: filme);
                                  }
                                );
                                carregarDados(false);
                              },
                              child: SizedBox(
                                width: 180,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        height: 260,
                                        width: 180,
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
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        children: [
                                          Text(filme.titulo, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 13), overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 5),
                                          Text(filme.dataLancamento.isEmpty ? "Data desconhecida" : FormatacoesService.dataFormatada(filme.dataLancamento), style: GoogleFonts.cutiveMono(color: filme.dataLancamento.isEmpty ? Colors.white : compararDatas(filme.dataLancamento, filme.assistido)), overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ),
                          );
                        }
                      ),
                    )
        
                  ],
                )
              ),
        
        
              Container(
                padding: const EdgeInsets.only(bottom: 30, top: 0, left: 20, right: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(0, 15, 26, 32),
                      Colors.black,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeInDown(from: 20, child: Text("Lista de Cinemas", style: GoogleFonts.anton(color: Colors.white, fontSize: 19))),
                            FadeInRight(from: 20, child: const SizedBox(width: 50, child: Divider(color: Colors.red)))
                          ],
                        ),
                        IconButton(
                          onPressed: () async {
                            await showDialog(
                              context: context, 
                              builder: (_){
                                return const CinemaPage();
                              }
                            );
                            carregarDados(false);
                          }, 
                          icon: const Icon(Icons.list_rounded, color: Colors.white, size: 19)
                        )
                      ],
                    ),
                    
                    const SizedBox(height: 30),
        
                    cinemasFavoritos.cinemas.isEmpty 
                    
                    ?
        
                    CustomBtnAdd(
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
                    )
        
                    :
        
                    SizedBox(
                      height: 340,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(width: 15),
                        scrollDirection: Axis.horizontal,
                        itemCount: cinemasExibicao.length,
                        itemBuilder: (_, index){
                          var cinema = cinemasExibicao[index];
                          return FadeIn(
                            child: InkWell(
                              onTap: () async {
                                await showDialog(
                                  context: context, 
                                  builder: (_){
                                    return PerfilCinemaPage(cinema: cinema);
                                  }
                                );
                                carregarDados(false);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                 color: Colors.white12,
                                  width: 330,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 260,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 84, 84, 84),
                                          image: cinema.fotoDoCinema.isEmpty || !FormatacoesService.urlValido(cinema.fotoDoCinema) ? 
                                          const DecorationImage(
                                            image: AssetImage("assets/popcorn.jpg"),
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                              Color.fromARGB(66, 0, 0, 0), 
                                              BlendMode.darken
                                            )
                                          )
                                          :
                                          DecorationImage(
                                            image: NetworkImage(cinema.fotoDoCinema),
                                            fit: BoxFit.cover
                                          )
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ListEstrelas(quantidade: cinema.nota, tamanhoIcon: 25),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Text(cinema.nome, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 13), overflow: TextOverflow.ellipsis,),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ),
                          );
                        }
                      ),
                    ),
                  ],
                )
              ),
        
        
            ],
          ),
        ),
      ),
    );
  }
}