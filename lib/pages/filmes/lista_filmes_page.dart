import 'package:app_sweet_cine/model/filme_model.dart';
import 'package:app_sweet_cine/pages/filmes/perfil_filme_page.dart';
import 'package:app_sweet_cine/pages/registro/registro_filme_pages.dart';
import 'package:app_sweet_cine/repositories/cinema_repository.dart';
import 'package:app_sweet_cine/repositories/filme_repository.dart';
import 'package:app_sweet_cine/services/formatacoes_services.dart';
import 'package:app_sweet_cine/services/widgets/custom_sistema_de_busca.dart';
import 'package:app_sweet_cine/services/widgets/custom_tela_de_carregamento.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ListaFilmesPage extends StatefulWidget {
  String listarPor;
  bool naoListarPorCinema;
  int idCinemaList;
  String generoInformado;
  ListaFilmesPage({super.key, required this.listarPor, required this.naoListarPorCinema, required this.idCinemaList, required this.generoInformado});

  @override
  State<ListaFilmesPage> createState() => _ListaFilmesPageState();
}

class _ListaFilmesPageState extends State<ListaFilmesPage> {
  String? genero;
  String? organizacao;
  int? idCinemaList;
  bool carregando = true;

  bool buscarFilme = false;
  var buscaController = TextEditingController(text: '');

  FilmeRepository filmeRepository = FilmeRepository();
  CinemaRepository cinemaRepository = CinemaRepository();
  List<FilmeModel> filmesFiltrados = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      Future.delayed(const Duration(milliseconds: 100), (){
        carregarDados(true, true);
      });
    });
    super.initState();
  }

  setarCarregando(bool valor){
    setState(() {
      carregando = valor;
    });
  }

  delayDados(bool setarCarregamento, bool exibirProgressIndicator, bool setarOrganizacaoEGenero) async {
    await setarCarregando(setarCarregamento);
    Future.delayed(const Duration(milliseconds: 150), (){
      carregarDados(exibirProgressIndicator, setarOrganizacaoEGenero);
    });
  }

  Future<void> carregarDados(bool mostrarCarregamento, bool setarOrganizacao) async {
    setState(() {
      if(mostrarCarregamento){
        carregando = true;
      }
    });

    filmeRepository = Provider.of<FilmeRepository>(context, listen: false);
    await filmeRepository.obterListaDeFilmes();
    await filmeRepository.obterFilmePorGenero(widget.generoInformado.isEmpty ? "Todos" : widget.generoInformado);
    await filmeRepository.obterGeneros();
    await filmeRepository.obterFilmesPorCinema(widget.idCinemaList);

    if(widget.idCinemaList != 0){
      await cinemaRepository.obterDadosPeloId(widget.idCinemaList);
    }
   
    idCinemaList = widget.idCinemaList;
    
    if(filmeRepository.generos.any((generos) => generos.genero == genero)){
      genero = genero;
    } else{
      genero = "Todos";
    }

    if(setarOrganizacao){
      genero = widget.generoInformado.isEmpty ? "Todos" : widget.generoInformado;
      organizacao = widget.listarPor;
    } else{
      if(buscarFilme){
        genero = widget.generoInformado.isEmpty ? "Todos" : widget.generoInformado;
      } else{
        genero = genero;
      }
      
      await filmeRepository.obterFilmePorGenero(genero!);
    }
    
    filmesFiltrados = widget.idCinemaList == 0 ? filmeRepository.filmes : filmeRepository.filmesPorCinema;
    buscarFilme = false;
    buscaController.text = "";

    setState(() {
      if(mostrarCarregamento){
        carregando = false;
      }
    });
  }

  carregarOrganizacao(FilmeRepository listaFilmes){
    if(organizacao == 'Recente'){

      listaFilmes.totalFilmesPorGenero.sort((a, b) => b.data.compareTo(a.data));
      listaFilmes.filmes.sort((a, b) => b.data.compareTo(a.data));
      listaFilmes.filmesPorCinema.sort((a, b) => b.data.compareTo(a.data));
      
    } else if(organizacao == "Antigo"){

      listaFilmes.totalFilmesPorGenero.sort((a, b) => a.data.compareTo(b.data));
      listaFilmes.filmes.sort((a, b) => a.data.compareTo(b.data));
      listaFilmes.filmesPorCinema.sort((a, b) => a.data.compareTo(b.data));

    } else{
      
      listaFilmes.totalFilmesPorGenero.sort((a, b) => b.nota.compareTo(a.nota));
      listaFilmes.filmes.sort((a, b) => b.nota.compareTo(a.nota));
      listaFilmes.filmesPorCinema.sort((a, b) => b.nota.compareTo(a.nota));
    }
  }

  // LISTAGEM DE TODOS OS GÊNEROS PARA O DROPDOWN
  List<DropdownMenuItem<String>> carregarGeneros(List<FilmeModel> lista) {

    Set<String> generos = {};

    generos.add("Todos");

    for (var genero in lista){
      generos.add(genero.genero);
    }

    List<DropdownMenuItem<String>> generosDatabase = [];

    for (var genero in generos){
      generosDatabase.add(DropdownMenuItem<String>(
        value: genero,
        child: Text(genero, style: const TextStyle(overflow: TextOverflow.ellipsis)),
      ));
    }

    return generosDatabase;
  }

  @override
  Widget build(BuildContext context) {
    final listaFilmes = Provider.of<FilmeRepository>(context, listen: false);
    final cinemaId = Provider.of<CinemaRepository>(context, listen: false);
    carregarOrganizacao(listaFilmes);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
        onPressed: () async{
          await showDialog(
            context: context, 
            builder: (_){
              return RegistroFilmePage(
                filmeModel: idCinemaList != 0 ?
                  FilmeModel.salvar(
                    idCinemaList!, 
                    "", 
                    "", 
                    "", 
                    "", 
                    "", 
                    0.0, 
                    "", 
                    "", 
                    0
                  )
                  :
                  FilmeModel.vazio(), 
                filmesEmBreve: false
              );
            }
          );
          delayDados(true, true, false);
        }
      ),
      appBar: AppBar( 
        leadingWidth: 0,
        toolbarHeight: 90,
        leading: Visibility(visible: false, child: Container()),
        backgroundColor: Colors.black54,
        title: buscarFilme
        
        ?

        CustomSistemaDeBusca(
          setController: (value){
            buscaController.text = value.text;
          }, 
          busca: (){
            setState(() {
              if (idCinemaList == 0){
                filmesFiltrados = listaFilmes.filmes.where((filmes) => filmes.titulo.toLowerCase().contains(buscaController.text.toLowerCase().trim())).toList();
              } else {
                filmesFiltrados = listaFilmes.filmesPorCinema.where((filmePorCinema) => filmePorCinema.titulo.toLowerCase().contains(buscaController.text.toLowerCase().trim())).toList();
              }
            });
          }, 
          sairDaBusca: (){
            delayDados(true, true, false);
          },
          label: "Digite o título do filme...",
        )
        
        :

        Row(
          children: [
            Visibility(
              visible: widget.naoListarPorCinema,
              child: Expanded(
                child: DropdownButton <String>(
                  itemHeight: 65,
                  menuMaxHeight: 400,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  iconEnabledColor: Colors.red,
                  isExpanded: true,
                  value: genero,
                  onChanged: (value) async {
                    genero = value.toString();
                    await listaFilmes.obterFilmePorGenero(value.toString());
            
                    setState((){
                      genero = value.toString();
                    });
                  },
                  hint: Text("Escolha um gênero", style: GoogleFonts.montserrat(color: Colors.white)),
                  items: carregarGeneros(listaFilmes.generos),

                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButton <String>(
                iconEnabledColor: Colors.red,
                style: GoogleFonts.montserrat(color: Colors.white),
                isExpanded: true,
                itemHeight: 65,
                value: organizacao,
                hint: Text("Organizar por...", style: GoogleFonts.montserrat(color: Colors.white)),
                onChanged: (value){
                  
                  organizacao = value.toString();
                  setState((){});
                  
                },
                items: const [
                  DropdownMenuItem <String>(
                    value: "Recente",
                    child: Text("Mais recente")
                  ),
                  DropdownMenuItem <String>(
                    value: "Antigo",
                    child: Text("Mais antigo")
                  ),
                  DropdownMenuItem <String>(
                    value: "Popular",
                    child: Text("Mais popular")
                  ),
                ],
              ),
            )
          ],
        ),

        actions: [
          Visibility(
            visible: !buscarFilme,
            child: IconButton(
              onPressed: (){
                setState(() {
                  genero = "Todos";
                  buscarFilme = true;
                });
              }, 
              icon: const Icon(Icons.search, color: Colors.white)
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh:() => carregarDados(true, true),
        color: Colors.red,
        strokeWidth: 3,
        child: DecoratedBox(
          decoration: const BoxDecoration( 
            image: DecorationImage(
              image: AssetImage("assets/scratch.png"),
              fit: BoxFit.cover
            ),
          ),
          child: carregando ? 
          TelaDeCarregamento(mostrarBackground: true)
          :
          ListView(
            children: [
          
              DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(169, 0, 0, 0), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  )
                ),
                child: Column(
                  children: [
          
                    Visibility(
                      visible: filmesFiltrados.isNotEmpty,
                      child: Container(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
          
                            Visibility(
                              visible: idCinemaList != 0,
                              child: Expanded(
                                flex: 1,
                                child: Text(cinemaId.cinema.nome, style: GoogleFonts.anton(color: Colors.white, fontSize: 16), overflow: TextOverflow.ellipsis)
                              )
                            ),
          
                            Visibility(
                              visible: idCinemaList != 0,
                              child: const SizedBox(width: 17)
                            ),
          
                            Expanded(
                              flex: 1,
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                textAlign: idCinemaList != 0 ? TextAlign.end : TextAlign.start,
                                text: TextSpan(
                                  style: GoogleFonts.anton(color: Colors.white, fontSize: 15),
                                  text: "Total de Filmes: ",
                                  children: [
                                    TextSpan(
                                      style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17),
                                      text: genero == "Todos" ? filmesFiltrados.length.toString() : listaFilmes.totalFilmesPorGenero.length.toString()
                                    )
                                  ]
                                )
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    
                    (listaFilmes.generos.isEmpty || filmesFiltrados.isEmpty) ?
                    
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 113,
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
                      padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (_, index) => const SizedBox(height: 10), 
                      itemCount: genero == 'Todos' ? filmesFiltrados.length : filmeRepository.totalFilmesPorGenero.length,
                      itemBuilder: (_, index){
                        var filme = genero == 'Todos' ? filmesFiltrados[index] : filmeRepository.totalFilmesPorGenero[index];
                        return Stack(
                          children: [
                            Positioned(
                              child: Container(height: 270)
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
                                      return PerfilFilmePage(filme: filme);
                                    }
                                  );
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  // delayDados(true, true, false);
                                  carregarDados(false, false);
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
                                        ListEstrelas(quantidade: filme.nota, tamanhoIcon: 17),
                                        const SizedBox(height: 5),
                                        Text(filme.titulo, style: GoogleFonts.anton(color: Colors.white, fontSize: 17), overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 5),
                                        Text(FormatacoesService.dataFormatada(filme.data).isEmpty ? "Data desconhecida" : FormatacoesService.dataFormatada(filme.data), style: GoogleFonts.cutiveMono(color: Colors.white), overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 10),
                                        Text(filme.sinopse.isEmpty ? "Sem sinopse..." : filme.sinopse, style: 
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
                              top: 48,
                              child: InkWell(
                                onTap: () async {
                                  await showDialog(
                                    context: context, 
                                    builder: (_){
                                      return PerfilFilmePage(filme: filme);
                                    }
                                  );
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  // delayDados(true, true, false);
                                  carregarDados(false, false);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: filme.poster.isEmpty || !FormatacoesService.urlValido(filme.poster)? 
                                    const DecorationImage(
                                      image: AssetImage("assets/cameraMovie.png"),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken)
                                    )
                                    :
                                    DecorationImage(
                                      image: NetworkImage(filme.poster),
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