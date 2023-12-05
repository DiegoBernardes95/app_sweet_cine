import 'package:animate_do/animate_do.dart';
import 'package:app_sweet_cine/model/filme_model.dart';
import 'package:app_sweet_cine/pages/registro/registro_filme_pages.dart';
import 'package:app_sweet_cine/repositories/filme_repository.dart';
import 'package:app_sweet_cine/services/formatacoes_services.dart';
import 'package:app_sweet_cine/services/widgets/custom_mostrar_textos.dart';
import 'package:app_sweet_cine/services/widgets/custom_tela_de_carregamento.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PerfilFilmePage extends StatefulWidget {
  FilmeModel filme;
  PerfilFilmePage({super.key, required this.filme});

  @override
  State<PerfilFilmePage> createState() => _PerfilFilmePageState();
}

class _PerfilFilmePageState extends State<PerfilFilmePage> {

  FilmeRepository filmeRepository = FilmeRepository();

  var comentarioController = TextEditingController(text: "");
  var sinopseController = TextEditingController(text: "");
  bool editarSinopse = false;
  bool editarComentario = false;
  String? dropdownCS;

  String dataFormatada = "";
  String ingressoFormatado = "";
  String verificacaoTempo = "";
  bool carregando = false;
  

  @override
  void initState() {
    carregarDados(true, widget.filme.comentario.isEmpty ? "Sinopse" : "Comentario");
    super.initState();
  }

  @override
  void dispose(){
    filmeRepository.filmePeloId = FilmeModel.completoVazio();
    super.dispose();
  }

  Future<void> carregarDados(bool mostrarCarregamento, String dropdownCSChange) async {
    setState(() {
      if(mostrarCarregamento){
        carregando = true;
      }
    });

    filmeRepository = Provider.of<FilmeRepository>(context, listen: false);
    await filmeRepository.obterDadosPeloId(widget.filme.id);
    ingressoFormatado = UtilBrasilFields.obterReal(filmeRepository.filmePeloId.ingresso);
    comentarioController.text = filmeRepository.filmePeloId.comentario;
    sinopseController.text = filmeRepository.filmePeloId.sinopse;
    dropdownCS = dropdownCSChange;

    setState(() {
      if(mostrarCarregamento){
        carregando = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final perfilFilme = Provider.of<FilmeRepository>(context, listen: false);
    dataFormatada = FormatacoesService.dataFormatada(perfilFilme.filmePeloId.data);
    try {
      verificacaoTempo = FormatacoesService.tempoDiferenca(perfilFilme.filmePeloId.data);
    } catch (e) {
      verificacaoTempo = "";
    }
    
    
 
    return Scaffold(
      body: carregando ?

      TelaDeCarregamento(mostrarBackground: true)
      
      :
      
      RefreshIndicator(
        onRefresh: () => carregarDados(true, comentarioController.text.isEmpty ? "Sinopse" : "Comentario"),
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
                Colors.black
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: ListView(
            children: [
              Stack(
                children: [
                  Positioned(
                    child: Container(height: 630)
                  ),
        
                  Positioned(
                    child: Container(
                      height: 400,
                      alignment: Alignment.topLeft,
                      decoration: 
                      BoxDecoration(
                        color: const Color.fromARGB(198, 84, 84, 84),
                        image: perfilFilme.filmePeloId.capa.isEmpty || !FormatacoesService.urlValido(perfilFilme.filmePeloId.capa) ?
                        const DecorationImage(
                          image: AssetImage('assets/popcorn.jpg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Color.fromARGB(88, 0, 0, 0), 
                            BlendMode.darken
                          )
                        ) 
                        :
                        DecorationImage(
                          image: NetworkImage(perfilFilme.filmePeloId.capa),
                          fit: BoxFit.cover
                        )
                      ),
                      child: Container(
                        height: 400,
                        alignment: Alignment.topCenter,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.5, 0.9]
                          )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context, 
                                  builder: (_){
                                    return RegistroFilmePage(filmeModel: perfilFilme.filmePeloId, filmesEmBreve: false);
                                  }
                                );
                                carregarDados(false, comentarioController.text.isEmpty ? "Sinopse" : "Comentario");
                              }, 
                              icon: const Icon(Icons.edit, color: Colors.white, size: 30)
                            ),
                        
                            const SizedBox(width: 3),
                        
                            IconButton(
                              onPressed: () async{
                                await showDialog(
                                  context: context, 
                                  builder: (_){
                                    return AlertDialog(
                                      backgroundColor: const Color.fromARGB(255, 15, 26, 32),
                                      title: Text("Excluir", style: GoogleFonts.montserrat(color: Colors.white)),
                                      content: Text("${perfilFilme.filmePeloId.titulo}?", style: GoogleFonts.anton(color: Colors.white),),
                                      actions: [
                                        TextButton(
                                          onPressed: () async{
                                            await perfilFilme.remover(perfilFilme.filmePeloId.id); 
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
                                carregarDados(false, comentarioController.text.isEmpty ? "Sinopse" : "Comentario");
                              }, 
                              icon: const Icon(Icons.delete, color: Colors.white, size: 30,)
                            )
                          ],
                        ),
                      ),
                    )
                  ),
        
                  Positioned(
                    top: 355,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black, Colors.transparent
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.5, 0.9]
                        )
                      ),
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FadeInLeft(
                            from: 20,
                            child: Container(
                              height: 260,
                              width: 180,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 84, 84, 84),
                                border: Border.all(color: Colors.white30),
                                image: perfilFilme.filmePeloId.poster.isEmpty || !FormatacoesService.urlValido(perfilFilme.filmePeloId.poster) ? 
                                const DecorationImage(
                                  image: AssetImage("assets/cameraMovie.png"),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken)
                                )
                                :
                                DecorationImage(
                                  image: NetworkImage(perfilFilme.filmePeloId.poster),
                                  fit: BoxFit.cover
                                )
                              ),
                            ),
                          ),
                            
                          FadeInDown(
                            from: 20,
                            delay: const Duration(milliseconds: 400),
                            child: Container(
                              height: 215,
                              width: MediaQuery.of(context).size.width - 190,
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 10),
                                  ListEstrelas(quantidade: perfilFilme.filmePeloId.nota, tamanhoIcon: 25),
                                  const SizedBox(height: 6),
                                  Text(perfilFilme.filmePeloId.titulo, style: GoogleFonts.anton(color: Colors.white, fontSize: 18), overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 15),
                                  Text(perfilFilme.filmePeloId.genero.isEmpty ? "Gênero desconhecido" : perfilFilme.filmePeloId.genero, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15), overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 6),
                                  Text(perfilFilme.filmePeloId.cinemaAssistido, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15), overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 6),
                                  Text(ingressoFormatado, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15)),
                                  const SizedBox(height: 6),
                                  Text(dataFormatada.isEmpty ? "Data desconhecida" : dataFormatada, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15), overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 6),
                                  Text(perfilFilme.filmePeloId.data.isEmpty ? "" : verificacaoTempo == "Hoje".toLowerCase() ? "Visto $verificacaoTempo" : "Visto há $verificacaoTempo", style: GoogleFonts.cutiveMono(color: Colors.white))
                                ], 
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  )
                ],
              ),
        
              const SizedBox(height: 50),

              dropdownCS == "Sinopse" 
              
              ?

              // CAMPO DA SINOPSE
              InkWell(
                child: Container(
                  color: Colors.black54,
                  height: !editarSinopse ? 400 : null,
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      FadeIn(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Sinopse", style: GoogleFonts.anton(color: Colors.white, fontSize: 21)),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: (){
                                    setState(() {
                                      editarSinopse = !editarSinopse;
                                    });
                                  }, 
                                  icon: const Icon(Icons.edit, color: Colors.white)
                                ),
                                    
                                PopupMenuButton(
                                  initialValue: dropdownCS,
                                  color: Colors.white,
                                  onSelected: (value){
                                    setState(() {
                                      dropdownCS = value.toString();
                                    });
                                    
                                  },
                                  itemBuilder: (_){
                                    return <PopupMenuEntry<String>>[
                                      PopupMenuItem(
                                        value: "Sinopse",
                                        child: Text("Sinopse", style: GoogleFonts.montserrat())
                                      ),
                                      PopupMenuItem(
                                        value: "Comentario",
                                        child: Text("Comentário", style: GoogleFonts.montserrat())
                                      ),
                                    ];
                                  }
                                )
                                    
                                    
                              ],
                            )
                          ],
                        ),
                      ),
                      const Divider(color: Colors.redAccent),
                      const SizedBox(height: 20),
                      
                      editarSinopse ?
              
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
                                    controller: sinopseController,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      label: Text("Sinopse", style: GoogleFonts.molengo(color: Colors.white, fontSize: 16)),
                                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      alignLabelWithHint: true,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                      
                                      
                                    ),
                                    cursorColor: Colors.white,
                                    style: GoogleFonts.molengo(color: Colors.white),
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
                                    await perfilFilme.atualizar(
                                      FilmeModel.completo(
                                        perfilFilme.filmePeloId.id, 
                                        perfilFilme.filmePeloId.idCinema, 
                                        perfilFilme.filmePeloId.cinemaAssistido, 
                                        perfilFilme.filmePeloId.poster, 
                                        perfilFilme.filmePeloId.capa, 
                                        perfilFilme.filmePeloId.titulo, 
                                        perfilFilme.filmePeloId.genero, 
                                        perfilFilme.filmePeloId.data, 
                                        perfilFilme.filmePeloId.ingresso, 
                                        sinopseController.text.trim(), 
                                        perfilFilme.filmePeloId.comentario, 
                                        perfilFilme.filmePeloId.nota
                                      )
                                    );
                                    await carregarDados(false, "Sinopse");
                                    setState(() {
                                      editarSinopse = false;
                                    });
                                    
                                  }, 
                                  child: const Text("Salvar")
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(124, 244, 67, 54))),
                                  onPressed: (){
                                    setState(() {
                                      editarSinopse = false;
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
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          
                          child: Text(
                            perfilFilme.filmePeloId.sinopse.isEmpty ? "Sem sinopse..." : perfilFilme.filmePeloId.sinopse,
                            style: GoogleFonts.molengo(
                              color: Colors.white,
                              fontSize: 16.6,
                            ),
                            maxLines: 13,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  await showDialog(
                      context: context, 
                      builder: (_) {
                        return CustomMostrarTextos(
                          titulo: perfilFilme.filmePeloId.titulo, 
                          imagemBackground: perfilFilme.filmePeloId.poster, 
                          texto: perfilFilme.filmePeloId.sinopse.isEmpty ? "Sem sinopse..." : perfilFilme.filmePeloId.sinopse
                        );
                      }
                    );
                    carregarDados(false, "Sinopse");
                },
              )

              :

              // CAMPO DO COMENTÁRIO
              InkWell(
                child: Container(
                  height: !editarComentario ? 400 : null,
                  color: Colors.black54,
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      FadeIn(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Na minha opinião...", style: GoogleFonts.anton(color: Colors.white, fontSize: 21)),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: (){
                                    setState(() {
                                      editarComentario = !editarComentario;
                                    });
                                  }, 
                                  icon: const Icon(Icons.edit, color: Colors.white)
                                ),
                                    
                                PopupMenuButton(
                                  initialValue: dropdownCS,
                                  color: Colors.white,
                                    
                                  onSelected: (value){
                                    setState(() {
                                      dropdownCS = value.toString();
                                    });
                                    
                                  },
                                  itemBuilder: (_){
                                    return <PopupMenuEntry<String>>[
                                      PopupMenuItem(
                                        value: "Sinopse",
                                        child: Text("Sinopse", style: GoogleFonts.montserrat())
                                      ),
                                      PopupMenuItem(
                                        value: "Comentario",
                                        child: Text("Comentário", style: GoogleFonts.montserrat())
                                      ),
                                    ];
                                  }
                                )
                                    
                              ],
                            )
                          ],
                        ),
                      ),
                      const Divider(color: Colors.redAccent),
                      const SizedBox(height: 20),
              
                      editarComentario ?
              
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
                                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                                    ),
                                    cursorColor: Colors.white,
                                    style: GoogleFonts.molengo(color: Colors.white),
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
                                    await perfilFilme.atualizar(
                                      FilmeModel.completo(
                                        perfilFilme.filmePeloId.id, 
                                        perfilFilme.filmePeloId.idCinema, 
                                        perfilFilme.filmePeloId.cinemaAssistido, 
                                        perfilFilme.filmePeloId.poster, 
                                        perfilFilme.filmePeloId.capa, 
                                        perfilFilme.filmePeloId.titulo, 
                                        perfilFilme.filmePeloId.genero, 
                                        perfilFilme.filmePeloId.data, 
                                        perfilFilme.filmePeloId.ingresso, 
                                        perfilFilme.filmePeloId.sinopse, 
                                        comentarioController.text.trim(), 
                                        perfilFilme.filmePeloId.nota
                                      )
                                    );
                                    await carregarDados(false, "Comentario");
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
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          child: Text(
                            perfilFilme.filmePeloId.comentario.isEmpty ? "Sem comentários..." : perfilFilme.filmePeloId.comentario,
                            style: GoogleFonts.molengo(
                              color: Colors.white,
                              fontSize: 16.6,
                            ),
                            maxLines: 13,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                onTap: () async {
                  await showDialog(
                    context: context, 
                    builder: (_){
                      return CustomMostrarTextos(
                        titulo: "Na minha opinião...", 
                        imagemBackground: perfilFilme.filmePeloId.capa, 
                        texto: perfilFilme.filmePeloId.comentario.isEmpty ? "Sem comentário" : perfilFilme.filmePeloId.comentario
                      );
                    }
                  );
                  carregarDados(false, "Comentario");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}