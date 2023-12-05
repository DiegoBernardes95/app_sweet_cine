import 'package:animate_do/animate_do.dart';
import 'package:app_sweet_cine/emBreve/perfil_emBreve_page.dart';
import 'package:app_sweet_cine/model/emBreve_model.dart';
import 'package:app_sweet_cine/pages/registro/registro_emBreve_pages.dart';
import 'package:app_sweet_cine/repositories/emBreve_repository.dart';
import 'package:app_sweet_cine/services/formatacoes_services.dart';
import 'package:app_sweet_cine/services/widgets/custom_btn_add.dart';
import 'package:app_sweet_cine/services/widgets/custom_drawer.dart';
import 'package:app_sweet_cine/services/widgets/custom_logoApp.dart';
import 'package:app_sweet_cine/services/widgets/custom_sistema_de_busca.dart';
import 'package:app_sweet_cine/services/widgets/custom_tela_de_carregamento.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EmBrevePage extends StatefulWidget {
  const EmBrevePage({super.key});

  @override
  State<EmBrevePage> createState() => _EmBrevePageState();
}

class _EmBrevePageState extends State<EmBrevePage> {
  EmBreveRepository emBreveRepository = EmBreveRepository();
  bool carregando = true;
  List<EmBreveModel> filmesFiltrados = [];
  bool buscarFilme = false;
  var buscaController = TextEditingController(text: "");
  String? selecao;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), (){
        carregarDados(true, false);
      });
    });
    super.initState();
  }

  Future<void> carregarDados(bool mostrarCarregamento, bool setarFiltro) async {
    setState(() {
      if(mostrarCarregamento){
        carregando = true;
      }
    });

    final emBreveRepository = Provider.of<EmBreveRepository>(context, listen: false);
    await emBreveRepository.listarFilmes();
    await emBreveRepository.obterProximoFilme();
    
    if(setarFiltro){
      selecao = selecao;
      await emBreveRepository.listarFilmes();
    } else{
      selecao = "Não assistido";
    }
    
    filmesFiltrados = emBreveRepository.filmesEmBreve;
    buscarFilme = false;
    buscaController.text = "";

    setState(() {
      if(mostrarCarregamento){
        carregando = false;
      }
    });
  }

  carregarOrganizacao(EmBreveRepository listarFilmes){
    if(buscarFilme){
      filmesFiltrados = listarFilmes.filmesEmBreve.where((filme) => filme.titulo.toLowerCase().contains(buscaController.text.toLowerCase().trim())).toList();
    } else{
      if(selecao == "Assistido"){
        filmesFiltrados = listarFilmes.filmesEmBreve.where((filme) => filme.assistido).toList();
        filmesFiltrados.sort((a, b) => b.dataLancamento.compareTo(a.dataLancamento));
      } else if(selecao == "Não assistido"){
        filmesFiltrados = listarFilmes.filmesEmBreve.where((filme) => !filme.assistido).toList();
      } else if(selecao == "Todos"){
        filmesFiltrados = listarFilmes.filmesEmBreve;
      }
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final listarFilmes = Provider.of<EmBreveRepository>(context, listen: false);
    carregarOrganizacao(listarFilmes);

    return Scaffold(
      appBar: AppBar(
        title: CustomLogoApp(fontSizeTitle: 22, fontSizeSubtitle: 17), 
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context, 
                builder: (_){
                  return RegistroEmBrevePages(filmeModel: EmBreveModel.completoVazio());
                }
              );
              carregarDados(false, false);
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
        strokeWidth: 3,
        color: Colors.red,
        onRefresh: () => carregarDados(true, false),
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
              image: AssetImage("assets/scratch.png"),
              fit: BoxFit.cover
            )
          ),
          child: ListView(
            children: [

              Container(
                height: 340,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(198, 84, 84, 84),
                  image: listarFilmes.proximoFilme.capa.isEmpty || !FormatacoesService.urlValido(listarFilmes.proximoFilme.capa) 
                  ? 
                  const DecorationImage(
                    image: AssetImage("assets/popcorn.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Color.fromARGB(139, 15, 26, 32), 
                      BlendMode.darken
                    )
                  )
                  
                  :
              
                  DecorationImage(
                    image: NetworkImage(listarFilmes.proximoFilme.capa),
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                      Color.fromARGB(139, 15, 26, 32), 
                      BlendMode.darken
                    )
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: listarFilmes.filmesEmBreve.isEmpty ? 
                FadeInRight(from: 20, child: CustomLogoApp(fontSizeTitle: 35, fontSizeSubtitle: 25))
                :
                FadeInRight(
                  from: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                              
                      Text("Próximo filme:", style: GoogleFonts.cutiveMono(color: Colors.white, fontSize: 15)),
                      const SizedBox(height: 9),
                      Text(listarFilmes.proximoFilme.titulo.isEmpty ? "Não encontrado..." : listarFilmes.proximoFilme.titulo, style: GoogleFonts.anton(color: Colors.white, fontSize: 24), overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Visibility(
                        visible: listarFilmes.proximoFilme.dataLancamento.isEmpty ? false : true,
                        child: Text("em", style: GoogleFonts.cutiveMono(color: Colors.white, fontSize: 15))
                      ),
                      const SizedBox(height: 8),
                      Visibility(
                        visible: listarFilmes.proximoFilme.dataLancamento.isEmpty ? false : true,
                        child: Text(listarFilmes.proximoFilme.dataLancamento.isEmpty ? "Data desconhecida" : FormatacoesService.dataFormatada(listarFilmes.proximoFilme.dataLancamento), style: GoogleFonts.montserrat(color: listarFilmes.proximoFilme.dataLancamento.isEmpty ? Colors.white : compararDatas(listarFilmes.proximoFilme.dataLancamento, listarFilmes.proximoFilme.assistido), fontSize: 15), overflow: TextOverflow.ellipsis)
                      )
                              
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.only(right: 10, left: 10, top: 50, bottom: 30),
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

                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                    
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FadeInDown(from: 20, child: Text('Em breve', style: GoogleFonts.anton(color: Colors.white, fontSize: 19))),
                                  FadeInRight(from: 20, child: const SizedBox(width: 35, child: Divider(color: Colors.red))),
                                ],
                              ),
                            ),
                          ),
                    
                          buscarFilme ?
                      
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: CustomSistemaDeBusca(
                                setController: (value){
                                  buscaController.text = value.text;
                                }, 
                                busca: (){
                                  setState(() {
                                    filmesFiltrados = listarFilmes.filmesEmBreve.where((filme) => filme.titulo.toLowerCase().contains(buscaController.text.toLowerCase().trim())).toList();
                                  });
                                }, 
                                sairDaBusca: (){
                                  carregarDados(false, true);
                                },
                                label: "Digite o título do filme...",
                              ),
                            ),
                          )
                    
                          :
                    
                          Row(
                            children: [

                              IconButton(
                                onPressed: (){
                                  setState(() {
                                    buscarFilme = true;
                                  });
                                }, 
                                icon: const Icon(Icons.search_outlined, color: Colors.white,)
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
                                        content: Text("Todos os filmes assistidos?", style: GoogleFonts.montserrat(color: Colors.white)),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              if(listarFilmes.filmesEmBreve.where((filme) => filme.assistido).toList().isEmpty){
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Row(
                                                    children: [
                                                      const Icon(Icons.warning, color: Colors.red),
                                                      const SizedBox(width: 5),
                                                      Text("Nenhum filme foi assistido até o momento...", style: GoogleFonts.montserrat(color: Colors.white)),
                                                    ],
                                                  ))
                                                );
                                              } else{
                                                await listarFilmes.removerAssistidos();
                                                setState(() {
                                                  carregando = true;
                                                });
                                              }
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                            }, 
                                            child: const Text("Sim")
                                          ),
                                          TextButton(
                                            onPressed: (){
                                              setState(() {
                                                carregando = false;
                                              });
                                              Navigator.pop(context);
                                            }, 
                                            child: const Text("Não")
                                          ),
                                        ],
                                      );
                                    }
                                  );
                                  carregarDados(carregando, true);
                                }, 
                                icon: const Icon(Icons.delete, color: Colors.white)),

                              const SizedBox(width: 5),

                              SizedBox(
                                width: 130,
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: selecao,
                                  iconEnabledColor: Colors.red,
                                  style: GoogleFonts.montserrat(color: Colors.white),
                                  onChanged: (value){
                                    selecao = value.toString();
                                    setState(() {});
                                  },
                                  items: const [
                                    DropdownMenuItem(
                                      value: "Todos",
                                      child: Text("Todos")
                                    ),
                                    DropdownMenuItem(
                                      value: "Assistido",
                                      child: Text("Assistidos")
                                    ),
                                    DropdownMenuItem(
                                      value: "Não assistido",
                                      child: Text("Não assistidos")
                                    ),
                                  ], 
                                  
                                ),
                              )
                    
                            ],
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
                              text: "Total de Filmes: ",
                              children: [
                                TextSpan(
                                  style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17),
                                  text: filmesFiltrados.length.toString()
                                )
                              ]
                            )
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    listarFilmes.filmesEmBreve.isEmpty ?

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: CustomBtnAdd(
                        labelBtn: "Adicionar filme", 
                        addFilmes: () async {
                          await showDialog(
                            context: context, 
                            builder: (_){
                              return RegistroEmBrevePages(filmeModel: EmBreveModel.completoVazio());
                            }
                          );
                          carregarDados(false, false);
                        }
                      ),
                    )
                    
                    :

                    filmesFiltrados.isEmpty ?

                    SizedBox(
                      height: 340,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off_outlined, color: Colors.white, size: 70),
                          const SizedBox(height: 20),
                          Text("Nenhum filme encontrado...", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17))
                        ],
                      ),
                    )

                    :

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, index) => const SizedBox(height: 15),
                      itemCount: filmesFiltrados.length,
                      itemBuilder: (_, index){
                        var filmeEmBreve = filmesFiltrados[index];
                        return FadeInLeft(
                          from: index.isOdd ? 30 : 60,
                          child: Stack(
                            children: [
                                      
                              Positioned(
                                child: Container(height: 280)
                              ),
                                      
                              Positioned(
                                right: 10,
                                top: 26,
                                width: MediaQuery.of(context).size.width - 80,
                                height: 245,
                                child: InkWell(
                                  onTap: () async {
                                    await showDialog(
                                      context: context, 
                                      builder: (_){
                                        return PerfilEmBrevePage(emBreveModel: filmeEmBreve);
                                      }
                                    );
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    carregarDados(false, true);
                                    
                                  },
                                  child: DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Colors.white12
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 100),
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 35),
                                          Text(filmeEmBreve.titulo, style: GoogleFonts.anton(color: Colors.white, fontSize: 17), overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 5),
                                          Text(filmeEmBreve.dataLancamento.isEmpty ? "Data desconhecida" : FormatacoesService.dataFormatada(filmeEmBreve.dataLancamento), style: GoogleFonts.cutiveMono(color: filmeEmBreve.dataLancamento.isEmpty ? Colors.white : compararDatas(filmeEmBreve.dataLancamento, filmeEmBreve.assistido)), overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 10),
                                          Text(filmeEmBreve.assistido ? "Assistido" : "Não assistido", style: GoogleFonts.montserrat(color: filmeEmBreve.assistido ? Colors.green : Colors.red, fontStyle: FontStyle.italic)),
                                          const SizedBox(height: 10),
                                          Text(filmeEmBreve.sinopse.isEmpty ? "Sem sinopse..." : filmeEmBreve.sinopse, style: 
                                            GoogleFonts.molengo(color: Colors.white, fontSize: 14.5),
                                            maxLines: 6,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ),
                                      
                              Positioned(
                                left: 15,
                                top: 50,
                                child: InkWell(
                                  onTap: () async {
                                    await showDialog(
                                      context: context, 
                                      builder: (_){
                                        return PerfilEmBrevePage(emBreveModel: filmeEmBreve);
                                      }
                                    );
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    carregarDados(false, true);
                                    
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: filmeEmBreve.poster.isEmpty || !FormatacoesService.urlValido(filmeEmBreve.poster) ?
                                      
                                      const DecorationImage(
                                        image: AssetImage("assets/cameraMovie.png"),
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken)
                                      )
                                
                                      :
                                
                                      DecorationImage(
                                        image: NetworkImage(filmeEmBreve.poster),
                                        fit: BoxFit.cover
                                      ),
                                      color: const Color.fromARGB(255, 84, 84, 84),
                                    ),
                                    height: 200,
                                    width: 120,
                                  ),
                                )
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}