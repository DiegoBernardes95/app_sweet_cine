import 'package:animate_do/animate_do.dart';
import 'package:app_sweet_cine/model/cinema_model.dart';
import 'package:app_sweet_cine/model/filme_model.dart';
import 'package:app_sweet_cine/pages/filmes/lista_filmes_page.dart';
import 'package:app_sweet_cine/pages/filmes/perfil_filme_page.dart';
import 'package:app_sweet_cine/pages/registro/registro_cinema_pages.dart';
import 'package:app_sweet_cine/repositories/cinema_repository.dart';
import 'package:app_sweet_cine/repositories/filme_repository.dart';
import 'package:app_sweet_cine/services/formatacoes_services.dart';
import 'package:app_sweet_cine/services/widgets/custom_lista_filmes.dart';
import 'package:app_sweet_cine/services/widgets/custom_placar.dart';
import 'package:app_sweet_cine/services/widgets/custom_tela_de_carregamento.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PerfilCinemaPage extends StatefulWidget {
  CinemaModel cinema;
  PerfilCinemaPage({super.key, required this.cinema});

  @override
  State<PerfilCinemaPage> createState() => _PerfilCinemaPageState();
}

class _PerfilCinemaPageState extends State<PerfilCinemaPage> {
  FilmeRepository filmeRepository = FilmeRepository();
  CinemaRepository cinemaRepository = CinemaRepository();
  String obterReal(double valor){
    var result = UtilBrasilFields.obterReal(valor);
    return result;
  }

  var comentarioController = TextEditingController(text: "");
  bool carregando = false;
  bool editarComentario = false;
  String verificacaoTempo = "";

  @override
  void initState() {
    carregarDados(true);
    super.initState();
  }

  @override
  void dispose(){
    filmeRepository.filmesPorCinema.clear();
    cinemaRepository.cinema = CinemaModel.vazio();
    super.dispose();
  }

  Future<void> carregarDados(bool mostrarCarregamento) async {
    setState(() {
      if(mostrarCarregamento){
        carregando = true;
      }
    });

    cinemaRepository = Provider.of<CinemaRepository>(context, listen: false);
    filmeRepository = Provider.of<FilmeRepository>(context, listen: false);
    await cinemaRepository.obterDadosPeloId(widget.cinema.id);
    await filmeRepository.obterFilmesPorCinema(widget.cinema.id);
    comentarioController.text = cinemaRepository.cinema.comentario;

    setState(() {
      if(mostrarCarregamento){
        carregando = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // PROVIDER CINEMA
    final perfilCinema = Provider.of<CinemaRepository>(context, listen: false);
    final listFilmes = Provider.of<FilmeRepository>(context, listen: false);

    List<FilmeModel> filmesExibicao = listFilmes.filmesPorCinema.take(10).toList();
    try {
      verificacaoTempo = FormatacoesService.tempoDiferenca(listFilmes.filmesPorCinema.last.data);
    } catch (e) {
      verificacaoTempo = "";
    }
    

    return Scaffold(
      body: carregando ?
      
      TelaDeCarregamento(mostrarBackground: true)

      :

      RefreshIndicator(
        onRefresh: () => carregarDados(true),
        strokeWidth: 3,
        color: Colors.red,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/scratch.png"),
              fit: BoxFit.cover
            ),
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Color.fromARGB(0, 15, 26, 32),
                Colors.black
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: ListView(
            children: [
      
              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(198, 84, 84, 84),
                  image: perfilCinema.cinema.fotoDoCinema.isEmpty || !FormatacoesService.urlValido(perfilCinema.cinema.fotoDoCinema) ? 
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
                    image: NetworkImage(perfilCinema.cinema.fotoDoCinema),
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(Color.fromARGB(139, 15, 26, 32), BlendMode.darken)
                  )
                ),
                child: Stack(
                  children: [
      
                    Positioned(
                      child: FadeInDown(
                        from: 20,
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ListEstrelas(quantidade: perfilCinema.cinema.nota, tamanhoIcon: 25),
                              const SizedBox(height: 10),
                              Text(perfilCinema.cinema.nome, style: GoogleFonts.anton(color: Colors.white, fontSize: 20)),
                              const SizedBox(height: 15),
                              Text("${perfilCinema.cinema.bairro.isEmpty ? "Bairro desconhecido" : perfilCinema.cinema.bairro} - ${perfilCinema.cinema.cidade.isEmpty ? "Cidade desconhecida" : perfilCinema.cinema.cidade}", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15)),
                              const SizedBox(height: 10),
                              Text(perfilCinema.cinema.estado == "Estados" ? "Estado desconhecido" : perfilCinema.cinema.estado, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15)),
                              const SizedBox(height: 10),
                              Text(listFilmes.filmesPorCinema.isEmpty || listFilmes.filmesPorCinema.last.data.isEmpty ? "" : verificacaoTempo == "Hoje".toLowerCase() ? "Frequentado a partir de $verificacaoTempo" : "Frequentado há $verificacaoTempo", style: GoogleFonts.cutiveMono(color: Colors.white))
                            ],
                          ),
                        ),
                      ),
                    ),
          
                    Positioned(
                      top: 15,
                      right: 10,
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await showDialog(
                                context: context, 
                                builder: (_){
                                  return RegistroCinemaPage(cinemaModel: perfilCinema.cinema);
                                }
                              );
                              carregarDados(false);
                            },
                            icon: const Icon(Icons.edit, color: Colors.white, size: 28)
                          ),
                          const SizedBox(width: 5),
                          IconButton(
                            onPressed: () async {
                              await showDialog(
                                context: context, 
                                builder: (_){
                                  return AlertDialog(
                                    backgroundColor: const Color.fromARGB(255, 15, 26, 32),
                                    title: Text("Excluir", style: GoogleFonts.montserrat(color: Colors.white)),
                                    content: Text("${perfilCinema.cinema.nome}?", style: GoogleFonts.anton(color: Colors.white),),
                                    actions: [
                                      TextButton(
                                        onPressed: () async{
                                          await cinemaRepository.remover(perfilCinema.cinema.id); 
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        }, 
                                        child: const Text("Sim")
                                      ),
                                      TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        }, 
                                        child: const Text("Não")
                                      )
                                    ],
                                  );
                                }
                              );
                              carregarDados(false);
                            }, 
                            icon: const Icon(Icons.delete, color: Colors.white, size: 28)
                          )
                        ],
                      ),
                    )
                  ]
                ),
              ),
      
      
              CustomPlacar(
                valor1: perfilCinema.cinema.filmesAssistidos, 
                label1: "Filmes assistidos", 
                btn1: () async {
                  listFilmes.filmesPorCinema.isEmpty ?

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.red),
                        const SizedBox(width: 5),
                        Text('Nenhum filme assistido até o momento...', style: GoogleFonts.montserrat(color: Colors.white)),
                      ],
                    )
                  ))

                  :

                  await showDialog(
                    context: context, 
                    builder: (_){
                      return ListaFilmesPage(generoInformado: "", listarPor: "Recente", naoListarPorCinema: false, idCinemaList: perfilCinema.cinema.id);
                    }
                  );
                  carregarDados(false);
                },
                valor2: obterReal(perfilCinema.cinema.totalDeIngressos), 
                label2: "Gastos em ingresso!",
                btn2: (){},
              ),
      
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.4]
                  )
                ),
                child: Column(
                  children: [

                    Column(
                      children: [
                        FadeIn(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                            
                              Text("Na minha opinião...", style: GoogleFonts.anton(color: Colors.white, fontSize: 19)),
                                            
                              IconButton(
                                onPressed: (){
                                  setState(() {
                                    editarComentario = !editarComentario;
                                  });
                                }, 
                                icon: const Icon(Icons.edit, color: Colors.white)
                              )
                            ],
                          ),
                        ),
                        const Divider(color: Colors.red),

                        const SizedBox(height: 40),

                        editarComentario ?

                        // EDITAR COMENTÁRIO SOBRE O CINEMA
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          color: Colors.white10,
                          child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: comentarioController,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        label: Text("Comentário", style: GoogleFonts.molengo(color: Colors.white, fontSize: 16)),
                                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
                                        alignLabelWithHint: true,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                        
                                      ),
                                      cursorColor: Colors.white,
                                      style: GoogleFonts.molengo(color: Colors.white, fontSize: 16.6),
                                    ),
                                  ),
                                ],
                              ),
                  
                              const SizedBox(height: 15),
                  
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white12)),
                                    onPressed: () async {
                                      await perfilCinema.atualizar(
                                        CinemaModel.completo(
                                          perfilCinema.cinema.id, 
                                          perfilCinema.cinema.nome, 
                                          perfilCinema.cinema.bairro, 
                                          perfilCinema.cinema.cidade,
                                          perfilCinema.cinema.estado, 
                                          perfilCinema.cinema.fotoDoCinema,
                                          perfilCinema.cinema.nota, 
                                          comentarioController.text.trim(), 
                                          perfilCinema.cinema.filmesAssistidos, 
                                          perfilCinema.cinema.totalDeIngressos
                                        )
                                      );
                                      await carregarDados(false);
                                      setState(() {
                                        editarComentario = false;
                                      });
                                      
                                    }, 
                                    child: const Text("Salvar")
                                  ),
                                  const SizedBox(width: 10),
                                  TextButton(
                                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(124, 244, 67, 54))),
                                    onPressed: (){
                                      setState(() {
                                        editarComentario = false;
                                      });
                                    }, 
                                    child: const Text("Cancelar")
                                  )
                                ],
                              )
                            ],
                          ),
                        )

                        :

                        FadeInLeft(
                          from: 20,
                          delay: const Duration(milliseconds: 400),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(perfilCinema.cinema.comentario.isEmpty ? "Sem comentário!" : perfilCinema.cinema.comentario, style: GoogleFonts.molengo(color: Colors.white, fontSize: 16.6)),
                          ),
                        ),

                      ],
                    ),
      
                    const SizedBox(height: 45),

                    const Divider(color: Colors.redAccent),

                    const SizedBox(height: 50),
      
                    FadeIn(child: Text("Essa é sua lista de filmes assistidos no cinema", style: GoogleFonts.montserrat(color: Colors.white))),
      
                    const SizedBox(height: 20),
      
                    FadeIn(child: Text(perfilCinema.cinema.nome, style: GoogleFonts.anton(color: Colors.white, fontSize: 20))),
      
                    const SizedBox(height: 10),
      
                    FadeIn(child: Text("Reviva cada momento!", style: GoogleFonts.zeyada(color: Colors.white, fontSize: 17))),
      
                    const SizedBox(height: 50),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            FadeInDown(from: 20, child: Text("Filmes", style: GoogleFonts.anton(color: Colors.white, fontSize: 19))),
                            FadeInRight(from: 20, child: const SizedBox(width: 50, child: Divider(color: Colors.red)))
                          ],
                        ),
                        IconButton(
                          onPressed: () async {
                            if(listFilmes.filmesPorCinema.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.warning, color: Colors.red),
                                    const SizedBox(width: 5),
                                    Text('Nenhum filme assistido até o momento...', style: GoogleFonts.montserrat(color: Colors.white)),
                                  ],
                                )
                              ));
                            } else{
                              await showDialog(
                                context: context, 
                                builder: (_){
                                  return ListaFilmesPage(generoInformado: "", listarPor: "Recente", naoListarPorCinema: false, idCinemaList: perfilCinema.cinema.id);
                                }
                              );
                            }
                           
                              carregarDados(false);
                          }, 
                          icon: const Icon(Icons.list_outlined, color: Colors.white, size: 19)
                        )
                      ],
                    ),
      
                    const SizedBox(height: 50),
      
                    listFilmes.filmesPorCinema.isEmpty ? 
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30, left: 15),
                          child: SizedBox(
                            child: Text("Nenhum filme encontrado...", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ],
                    )

                    :
                    
                    SizedBox(
                      height: 360,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, index) => const SizedBox(width: 10),
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
                        },
                      ),
                    )

                    
                  ],
                )
              )
      
            ],
          ),
        ),
      ),
    );
  }
}