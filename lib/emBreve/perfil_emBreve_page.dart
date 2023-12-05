import 'package:animate_do/animate_do.dart';
import 'package:app_sweet_cine/model/emBreve_model.dart';
import 'package:app_sweet_cine/model/filme_model.dart';
import 'package:app_sweet_cine/pages/registro/registro_emBreve_pages.dart';
import 'package:app_sweet_cine/pages/registro/registro_filme_pages.dart';
import 'package:app_sweet_cine/repositories/emBreve_repository.dart';
import 'package:app_sweet_cine/repositories/filme_repository.dart';
import 'package:app_sweet_cine/services/formatacoes_services.dart';
import 'package:app_sweet_cine/services/widgets/custom_tela_de_carregamento.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PerfilEmBrevePage extends StatefulWidget {
  EmBreveModel emBreveModel;
  PerfilEmBrevePage({super.key, required this.emBreveModel});

  @override
  State<PerfilEmBrevePage> createState() => _PerfilEmBrevePageState();
}

class _PerfilEmBrevePageState extends State<PerfilEmBrevePage> {

  EmBreveRepository emBreveRepository = EmBreveRepository();
  FilmeRepository filmeRepository = FilmeRepository();
  bool carregando = false;
  var editarSinopseController = TextEditingController(text: "");
  bool editarSinopse = false;

  DateTime? dataAtualizada;

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
    
    emBreveRepository = Provider.of<EmBreveRepository>(context, listen: false);
    filmeRepository = Provider.of<FilmeRepository>(context, listen: false);
    await emBreveRepository.listarFilmePorId(widget.emBreveModel.id);
    await filmeRepository.obterListaDeFilmes();
    editarSinopseController.text = emBreveRepository.filmeEmBrevePorId.sinopse;
    dataAtualizada = emBreveRepository.filmeEmBrevePorId.dataLancamento.isEmpty ? DateTime.now() : DateTime.parse(emBreveRepository.filmeEmBrevePorId.dataLancamento);

    setState(() {
      if(mostrarCarregamento){
        carregando = false;
      }
    });
  }

  String verificarAssitido(String data){
    DateTime verificar = DateTime.parse(data);
    if(verificar.isBefore(DateTime.now())){
      return "Exibido em:";
    } else{
      return "Assistir em:";
    }
  }

  @override
  Widget build(BuildContext context) {
    final filme = Provider.of<EmBreveRepository>(context, listen: false);
    final listFilmes = Provider.of<FilmeRepository>(context, listen: false);

    bool verificarFilme = listFilmes.filmes.any((element) => element.titulo.toLowerCase() == filme.filmeEmBrevePorId.titulo.toLowerCase());

    return Scaffold(
      body: carregando ?

      TelaDeCarregamento(mostrarBackground: true)
      
      :
      
      RefreshIndicator(
        strokeWidth: 3,
        color: Colors.red,
        onRefresh: () => carregarDados(true),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.transparent,
                Colors.black
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            ),
            image: DecorationImage(
              image: AssetImage('assets/scratch.png'),
              fit: BoxFit.cover
            )
          ),
          child: ListView(
            children: [

              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(198, 84, 84, 84),
                  image: filme.filmeEmBrevePorId.capa.isEmpty || !FormatacoesService.urlValido(filme.filmeEmBrevePorId.capa) ? 
                  const DecorationImage(
                    image: AssetImage("assets/popcorn.jpg"),
                    fit: BoxFit.cover,
                  )
                  :
                  DecorationImage(
                    image: NetworkImage(filme.filmeEmBrevePorId.capa),
                    fit: BoxFit.cover
                  )
                ),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context, 
                                  builder: (_){
                                    return RegistroEmBrevePages(filmeModel: filme.filmeEmBrevePorId);
                                  }
                                );
                                carregarDados(false);
                              }, 
                              icon: const Icon(Icons.edit, color: Colors.white, size: 30)
                            ),
                            const SizedBox(width: 5),
                            IconButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context, 
                                  builder: (_){
                                    return AlertDialog(
                                      backgroundColor: const Color.fromARGB(255, 15, 26, 32),
                                      title: Text("Excluir", style: GoogleFonts.anton(color: Colors.white)),
                                      content: Text("${filme.filmeEmBrevePorId.titulo}?", style: GoogleFonts.montserrat(color: Colors.white)),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            await filme.remover(filme.filmeEmBrevePorId.id);
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          }, 
                                          child: const Text("Sim"),
                                        ),
                                        TextButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          }, 
                                          child: const Text("Não"),
                                        ),
                                      ],
                                    );
                                  }
                                );
                              }, 
                              icon: const Icon(Icons.delete_rounded, color: Colors.white, size: 30)
                            ),
                            Visibility(
                              visible: !verificarFilme,
                              child: PopupMenuButton <String>(
                                color: Colors.white,
                                onSelected: (value) async {
                                  if(value == "Adicionar" && filme.filmeEmBrevePorId.assistido){
                                    await showDialog(
                                      context: context, 
                                      builder: (_){
                                        return RegistroFilmePage(
                                          filmeModel: FilmeModel.completo(
                                            0, 
                                            0, 
                                            "", 
                                            filme.filmeEmBrevePorId.poster, 
                                            filme.filmeEmBrevePorId.capa, 
                                            filme.filmeEmBrevePorId.titulo, 
                                            "", 
                                            filme.filmeEmBrevePorId.dataLancamento, 
                                            0, 
                                            filme.filmeEmBrevePorId.sinopse, 
                                            "", 
                                            0
                                          ),
                                          filmesEmBreve: true,
                                        );
                                      }
                                    );
                                  } else if(!filme.filmeEmBrevePorId.assistido){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            const Icon(Icons.warning, color: Colors.red),
                                            const SizedBox(width: 5),
                                            Text("Esse filme ainda não foi assistido...", style: GoogleFonts.montserrat(color: Colors.white)),
                                          ],
                                        )
                                      )
                                    );
                                  }
                                   
                                },
                                itemBuilder: (_){
                                  return <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: "Adicionar",
                                      child: Text("Adicionar à Filmes", style: GoogleFonts.montserrat()),
                                    )
                                  ];
                                }
                              ),
                            )
                          ],
                        ),
                        FadeInDown(
                          from: 20,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 35),
                            child: Text(filme.filmeEmBrevePorId.titulo.isEmpty ? "Título desconhecido" : filme.filmeEmBrevePorId.titulo, style: GoogleFonts.anton(color: Colors.white, fontSize: 24), overflow: TextOverflow.ellipsis),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 100,
                child: Row(
                  children: [

                    Expanded(
                      flex: 1,
                      child: FadeInLeft(
                        from: 20,
                        child: InkWell(
                          onTap: () async {
                            var data = await showDatePicker(
                              context: context, 
                              initialDate: dataAtualizada != null ? DateTime(dataAtualizada!.year, dataAtualizada!.month, dataAtualizada!.day) : DateTime.now(), 
                              firstDate: DateTime(1940, 1, 1), 
                              lastDate: DateTime(2100, 1, 1)
                            );
                            if(data != null){
                              await emBreveRepository.atualizar(
                                EmBreveModel.completo(
                                  filme.filmeEmBrevePorId.id, 
                                  filme.filmeEmBrevePorId.titulo, 
                                  filme.filmeEmBrevePorId.poster, 
                                  filme.filmeEmBrevePorId.capa, 
                                  filme.filmeEmBrevePorId.sinopse, 
                                  filme.filmeEmBrevePorId.assistido, 
                                  data.toString()
                                )
                              );
                            }
                            carregarDados(false);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            color: Colors.white12,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(filme.filmeEmBrevePorId.assistido ? "Assistido em:" : verificarAssitido(filme.filmeEmBrevePorId.dataLancamento), style: GoogleFonts.anton(color: Colors.white)),
                                const SizedBox(height: 15),
                                Text(filme.filmeEmBrevePorId.dataLancamento.isEmpty ? "Data desconhecida" : FormatacoesService.dataFormatada(filme.filmeEmBrevePorId.dataLancamento), style: GoogleFonts.montserrat(color: filme.filmeEmBrevePorId.dataLancamento.isEmpty ? Colors.white : compararDatas(filme.filmeEmBrevePorId.dataLancamento, filme.filmeEmBrevePorId.assistido), fontSize: 15), textAlign: TextAlign.center)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      flex: 1,
                      child: FadeInRight(
                        from: 20,
                        child: InkWell(
                          onTap: () async {
                            await showDialog(
                              context: context, 
                              builder: (_){
                                return AlertDialog(
                                  backgroundColor: const Color.fromARGB(255, 15, 26, 32),
                                  title: Text("Status", style: GoogleFonts.anton(color: Colors.white)),
                                      
                                  content: RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.montserrat(color: Colors.white),
                                      text: "Modificar status para ",
                                      children: [
                                        TextSpan(
                                          style: GoogleFonts.montserrat(color: filme.filmeEmBrevePorId.assistido ? Colors.red : Colors.green, fontStyle: FontStyle.italic),
                                          text: filme.filmeEmBrevePorId.assistido ? "Não assistido" : "Assistido",
                                          children: [
                                            TextSpan(
                                              text: "?",
                                              style: GoogleFonts.montserrat(color: Colors.white) 
                                            )
                                          ]
                                        )
                                      ]
                                    )
                                  ),
                                  
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        await filme.atualizar(
                                          EmBreveModel.completo(
                                            filme.filmeEmBrevePorId.id, 
                                            filme.filmeEmBrevePorId.titulo, 
                                            filme.filmeEmBrevePorId.poster, 
                                            filme.filmeEmBrevePorId.capa, 
                                            filme.filmeEmBrevePorId.sinopse, 
                                            !filme.filmeEmBrevePorId.assistido, 
                                            filme.filmeEmBrevePorId.dataLancamento
                                          )
                                        );
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                      }, 
                                      child: Text("Atualizar", style: GoogleFonts.montserrat(color: Colors.white))
                                    ),
                                    TextButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      }, 
                                      child: Text("Cancelar", style: GoogleFonts.montserrat(color: Colors.white))
                                    ),
                                  ],
                                );
                              }
                            );
                            carregarDados(false);
                          },
                          child: Container(
                            color: Colors.white12,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Status:", style: GoogleFonts.anton(color: Colors.white)),
                                const SizedBox(height: 15),
                                Text(filme.filmeEmBrevePorId.assistido ? "Assistido" : "Não assistido", style: GoogleFonts.montserrat(color: filme.filmeEmBrevePorId.assistido ? Colors.green : Colors.red, fontSize: 15, fontStyle: FontStyle.italic))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeIn(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sinopse", style: GoogleFonts.anton(color: Colors.white, fontSize: 21)),
                          IconButton(
                            onPressed: (){
                              setState(() {
                                editarSinopse = !editarSinopse;
                              });
                            },
                            icon: const Icon(Icons.edit_note_outlined, color: Colors.white)
                          )
                        ],
                      ),
                    ),
                    const Divider(color: Colors.redAccent),
                    const SizedBox(height: 25),
                    
                    editarSinopse ?
                    
                    Column(
                      children: [

                        Container(
                          color: Colors.white10,
                          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                          child: TextField(
                            controller: editarSinopseController,
                            maxLines: null,
                            decoration: InputDecoration(
                              label: Text("Sinopse", style: GoogleFonts.molengo(color: Colors.white, fontSize: 16)),
                              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              alignLabelWithHint: true,
                            ),
                            cursorColor: Colors.white,
                            style: GoogleFonts.molengo(color: Colors.white, fontSize: 16.6),
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white12)),
                              onPressed: () async {
                                await filme.atualizar(
                                  EmBreveModel.completo(
                                    filme.filmeEmBrevePorId.id, 
                                    filme.filmeEmBrevePorId.titulo, 
                                    filme.filmeEmBrevePorId.poster, 
                                    filme.filmeEmBrevePorId.capa, 
                                    editarSinopseController.text.trim(), 
                                    filme.filmeEmBrevePorId.assistido, 
                                    filme.filmeEmBrevePorId.dataLancamento
                                  )
                                );
                                await carregarDados(false);
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
                    )

                    : 
                     
                    FadeInLeft(
                      from: 20,
                      delay: const Duration(milliseconds: 400),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(filme.filmeEmBrevePorId.sinopse.isEmpty ? "Sem sinopse..." : filme.filmeEmBrevePorId.sinopse, style: GoogleFonts.molengo(color: Colors.white, fontSize: 17)),
                      ),
                    )
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