import 'package:animate_do/animate_do.dart';
import 'package:app_sweet_cine/model/filme_model.dart';
import 'package:app_sweet_cine/pages/filmes/lista_filmes_page.dart';
import 'package:app_sweet_cine/pages/filmes/perfil_filme_page.dart';
import 'package:app_sweet_cine/pages/registro/registro_filme_pages.dart';
import 'package:app_sweet_cine/repositories/filme_repository.dart';
import 'package:app_sweet_cine/services/formatacoes_services.dart';
import 'package:app_sweet_cine/services/widgets/custom_btn_add.dart';
import 'package:app_sweet_cine/services/widgets/custom_drawer.dart';
import 'package:app_sweet_cine/services/widgets/custom_lista_filmes.dart';
import 'package:app_sweet_cine/services/widgets/custom_logoApp.dart';
import 'package:app_sweet_cine/services/widgets/custom_tela_de_carregamento.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FilmePage extends StatefulWidget {
  const FilmePage({super.key});

  @override
  State<FilmePage> createState() => _FilmePageState();
}

class _FilmePageState extends State<FilmePage> {

  FilmeRepository filmeRepository = FilmeRepository();
  String dataFormatada = "";
  String verificacaoTempo = "";
  bool carregando = false;

  List<FilmeModel> generosFiltrados = [];
  
  @override
  void initState() {
    super.initState();
    carregarDados(true);
  }

  @override
  void dispose(){
    filmeRepository.generos.clear();
    filmeRepository.filmePorNota.clear();
    filmeRepository.ultimoFilme = FilmeModel.completoVazio();
    super.dispose();
  }

  Future<void> carregarDados(bool mostrarCarregamento) async {
    setState(() {
      if(mostrarCarregamento){
        carregando = true;
      }
    });

    filmeRepository = Provider.of<FilmeRepository>(context, listen: false);
    await filmeRepository.obterListaDeFilmes();
    await filmeRepository.obterGeneros();
    await filmeRepository.obterFilmesPorNota();
    await filmeRepository.obterUltimoFilme();

    setState(() {
      if(mostrarCarregamento){
        carregando = false;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final listaFilme = Provider.of<FilmeRepository>(context, listen: false);
    final filmesFavoritosProvider = Provider.of<FilmeRepository>(context, listen: false);

    listaFilme.filmes.sort((a, b) => b.data.compareTo(a.data));
    filmesFavoritosProvider.filmePorNota.sort((a, b) => b.nota.compareTo(a.nota) == 0 ? a.data.compareTo(b.data) : b.nota.compareTo(a.nota));

    List<FilmeModel> filmesFavoritos = filmesFavoritosProvider.filmePorNota.take(10).toList();
    List<FilmeModel> filmesExibicao = listaFilme.filmes.take(10).toList();

    dataFormatada = FormatacoesService.dataFormatada(listaFilme.ultimoFilme.data);
    try {
      verificacaoTempo = FormatacoesService.tempoDiferenca(listaFilme.ultimoFilme.data);
    } catch (e) {
      verificacaoTempo = "";
    }


    return Scaffold(
      appBar: AppBar(
        title: CustomLogoApp(fontSizeTitle: 22, fontSizeSubtitle: 17),
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context, 
                builder: (_){
                  return RegistroFilmePage(filmeModel: FilmeModel.vazio(), filmesEmBreve: false);
                }
              );
              carregarDados(false);
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
        color: Colors.red,
        strokeWidth: 3,
        onRefresh: () => carregarDados(true),
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
                  image: listaFilme.ultimoFilme.capa.isEmpty || !FormatacoesService.urlValido(listaFilme.ultimoFilme.capa) ? 
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
                    image: NetworkImage(listaFilme.ultimoFilme.capa),
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                      Color.fromARGB(139, 15, 26, 32), 
                      BlendMode.darken
                    )
                  ),
                ),
                child: listaFilme.filmes.isEmpty ?
                FadeInRight(
                  from: 20, 
                  child: CustomLogoApp(fontSizeTitle: 35, fontSizeSubtitle: 25)
                )                
                :
                FadeInRight(
                  from: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Último filme assistido:", style: GoogleFonts.cutiveMono(color: Colors.white, fontSize: 15)),
                      const SizedBox(height: 20),
                      ListEstrelas(quantidade: listaFilme.ultimoFilme.nota, tamanhoIcon: 20),
                      const SizedBox(height: 5),
                      Text(listaFilme.ultimoFilme.titulo == "" ? "Título desconhecido" : listaFilme.ultimoFilme.titulo, style: GoogleFonts.anton(color: Colors.white, fontSize: 19)),
                      const SizedBox(height: 10),
                      Text(dataFormatada == "" ? "Data desconhecida" : dataFormatada, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15.5)),
                      const SizedBox(height: 7),
                      Text(listaFilme.ultimoFilme.data.isEmpty ? "" : verificacaoTempo == "Hoje".toLowerCase() ? verificacaoTempo : "há $verificacaoTempo", style: GoogleFonts.cutiveMono(color: Colors.white))
                    ],
                  ),
                ),
              ),
        
              Column(
                children: [
                  // CARROSEL DE FILMES
                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
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
                    height: 490,
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
                                FadeInDown(from: 20, child: Text("Assistidos recentemente", style: GoogleFonts.anton(color: Colors.white, fontSize: 19))),
                                FadeInRight(from: 20, child: const SizedBox(width: 35, child: Divider(color: Colors.red)))
                              ],
                            ),
                            IconButton(
                              onPressed: () async {
                                listaFilme.filmes.isEmpty ?
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(Icons.warning, color: Colors.red),
                                        const SizedBox(width: 5),
                                        Text('Nenhum filme encontrado...', style: GoogleFonts.montserrat(color: Colors.white)),
                                      ],
                                    )
                                  )
                                )

                                :

                                await showDialog(
                                  context: context, 
                                  builder: (_){
                                    return ListaFilmesPage(generoInformado: "", listarPor: "Recente", naoListarPorCinema: true, idCinemaList: 0);
                                  }
                                );
                                carregarDados(false);
                              }, 
                              icon: const Icon(Icons.list_rounded, color: Colors.white, size: 19)
                            )
                          ],
                        ),
                        
                        const SizedBox(height: 30),
        
                        listaFilme.filmes.isEmpty ?

                          CustomBtnAdd(
                            labelBtn: "Adicionar filme", 
                            addFilmes: ()async {
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
                          height: 360,
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
                                  child: CustomListaFilmes(filme: filme)
                                ),
                              );
                            }
                          ),
                        ),
                      ],
                    )
                  ),

                  // CARROSEL DE FILMES FAVORITOS
                  Visibility(
                    visible: listaFilme.filmePorNota.isNotEmpty,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 30, top: 30, left: 20, right: 20),
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
                                  FadeInDown(from: 20, child: Text("Favoritos", style: GoogleFonts.anton(color: Colors.white, fontSize: 19))),
                                  FadeInRight(from: 20, child: const SizedBox(width: 50, child: Divider(color: Colors.red)))
                                ],
                              ),
                              IconButton(
                                onPressed: () async {
                                  await showDialog(
                                    context: context, 
                                    builder: (_){
                                      return ListaFilmesPage(generoInformado: "", listarPor: "Popular", naoListarPorCinema: true, idCinemaList: 0);
                                    }
                                  );
                                  carregarDados(false);
                                }, 
                                icon: const Icon(Icons.list_rounded, color: Colors.white, size: 19)
                              )
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          
                          SizedBox(
                            height: 290,
                            child: ListView.separated(
                              separatorBuilder: (context, index) => const SizedBox(width: 15),
                              scrollDirection: Axis.horizontal,
                              itemCount: filmesFavoritos.length,
                              itemBuilder: (_, index){
                                var filme = filmesFavoritos[index];
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
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                        color: Colors.white12,
                                        width: 340,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 200,
                                              width: 340,
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(255, 84, 84, 84),
                                                image: filme.capa.isEmpty || !FormatacoesService.urlValido(filme.capa) ? 
                                                const DecorationImage(
                                                  image: AssetImage("assets/cameraMovie.png"),
                                                  fit: BoxFit.cover,
                                                  colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken)
                                                )
                                                :
                                                DecorationImage(
                                                  image: NetworkImage(filme.capa),
                                                  fit: BoxFit.cover
                                                )
                                              ),  
                                            ),
                                            const SizedBox(height: 20),
                                            ListEstrelas(quantidade: filme.nota, tamanhoIcon: 20),
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Text(filme.titulo, style: GoogleFonts.anton(color: Colors.white, fontSize: 14), overflow: TextOverflow.ellipsis),
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
                  ),
        
                  const SizedBox(height: 15),
        
                  // CARROSEL DE GÊNEROS
                  Visibility(
                    visible: listaFilme.generos.isNotEmpty,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 40, top: 0, left: 20, right: 20),
                      decoration: const BoxDecoration(
                        color: Colors.red,
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
                        children: [
                  
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FadeInDown(from: 20, child: Text("Gêneros", style: GoogleFonts.anton(color: Colors.white, fontSize: 19))),
                                  FadeInRight(from: 20, child: const SizedBox(width: 50, child: Divider(color: Colors.red)))
                                ],
                              ),
                              IconButton(
                                onPressed: () async {
                                  await showDialog(
                                    context: context, 
                                    builder: (_){
                                      return ListaFilmesPage(generoInformado: "", listarPor: "Recente", naoListarPorCinema: true, idCinemaList: 0);
                                    }
                                  );
                                  carregarDados(false);
                                }, 
                                icon: const Icon(Icons.list_rounded, color: Colors.white, size: 19)
                              )
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          
                          SizedBox(
                            height: 260,
                            child: ListView.separated(
                              separatorBuilder: (context, index) => const SizedBox(width: 15),
                              scrollDirection: Axis.horizontal,
                              itemCount: listaFilme.generos.toSet().toList().length,
                              itemBuilder: (_, index){
                                var genero = listaFilme.generos.toSet().toList()[index];
                                return FadeIn(
                                  child: InkWell(
                                    onTap: () async {
                                      await showDialog(
                                        context: context, 
                                        builder: (_){
                                          return ListaFilmesPage(generoInformado: genero.genero, listarPor: "Recente", naoListarPorCinema: true, idCinemaList: 0);
                                        }
                                      );
                                      carregarDados(false);
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            height: 260,
                                            width: 180,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 84, 84, 84),
                                              image: genero.poster.isEmpty || !FormatacoesService.urlValido(genero.poster) ?
                                              const DecorationImage(
                                                image: AssetImage("assets/cameraMovie.png"),
                                                fit: BoxFit.cover,
                                                colorFilter: ColorFilter.mode(Color.fromARGB(167, 30, 30, 30), BlendMode.darken)
                                              )
                                              :
                                              DecorationImage(
                                                image: NetworkImage(genero.poster),
                                                fit: BoxFit.cover,
                                                colorFilter: const ColorFilter.mode(Color.fromARGB(167, 30, 30, 30), BlendMode.darken)
                                              )
                                            ),
                                            child: Center(
                                              child: 
                                                Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                                  child: Text(genero.genero.toUpperCase(), style: GoogleFonts.anton(color: Colors.white, fontSize: 22), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,)
                                                )
                                              ),  
                                          ),
                                        ),
                                        
                                      ],
                                    ),
                                  ),
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}