import 'package:app_sweet_cine/model/cinema_model.dart';
import 'package:app_sweet_cine/model/filme_model.dart';
import 'package:app_sweet_cine/pages/registro/registro_cinema_pages.dart';
import 'package:app_sweet_cine/repositories/cinema_repository.dart';
import 'package:app_sweet_cine/repositories/filme_repository.dart';
import 'package:app_sweet_cine/services/formatacoes_services.dart';
import 'package:app_sweet_cine/services/widgets/custom_modalBottom.dart';
import 'package:app_sweet_cine/services/widgets/custom_notas.dart';
import 'package:app_sweet_cine/services/widgets/custom_tela_de_carregamento.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RegistroFilmePage extends StatefulWidget {
  FilmeModel filmeModel;
  bool filmesEmBreve;
  RegistroFilmePage({super.key, required this.filmeModel, required this.filmesEmBreve});

  @override
  State<RegistroFilmePage> createState() => _RegistroFilmePageState();
}

class _RegistroFilmePageState extends State<RegistroFilmePage> {
 
  // variaveis condicionais e de transição
  FilmeRepository filmeRepository = FilmeRepository();
  CinemaRepository cinemaRepository = CinemaRepository();

  var escreverGenero = true;
  String? generoDropdown;
  int? idCinemaDropdown;

  String dataSemFormatacao = "";
  DateTime? dataFilme;

  // setando imagem da capa
  var urlImageCapaController = TextEditingController(text: "");
  // bool imagemDeUrlCapa = true;
  String urlImageCapa = "";

  // setando imagem do poster
  var urlImagePosterController = TextEditingController(text: "");
  // bool imagemDeUrlPoster = true;
  String urlImagePoster = "";

  // controllers
  var tituloController = TextEditingController(text: "");
  var sinopseController = TextEditingController(text: "");
  // var comentarioController = TextEditingController(text: "");
  String comentario = "";
  var dataController = TextEditingController(text: "");
  var notaController = 0;
  var ingressoController = TextEditingController(text: "");
  double ingressoFormatado = 0.0; 
  var generoController = TextEditingController(text: "");

  bool carregando = false;

  @override
  void initState() {
    carregarDados(true);
    super.initState();
  }

  // CARREGAR GÊNEROS E CINEMAS
  Future<void> carregarDados(bool mostrarCarregamento) async {
    filmeRepository = Provider.of<FilmeRepository>(context, listen: false);
    cinemaRepository = Provider.of<CinemaRepository>(context, listen: false);
    await carregarValores(mostrarCarregamento);
    await filmeRepository.obterGeneros();
    await cinemaRepository.obterDados();

    setState((){});
  }

  carregarValores(bool mostrarCarregamento){
    setState(() {
      if(mostrarCarregamento && widget.filmeModel.id != 0){
        carregando = true;
      }
    });
    

    idCinemaDropdown = widget.filmeModel.idCinema;
    // Verificar se o idCinemaDropdown existe na lista de cinemas
    if (!cinemaRepository.cinemas.any((cinema) => cinema.id == idCinemaDropdown)) {
      idCinemaDropdown = 0; // Definir um valor padrão
    }
    urlImagePoster = widget.filmeModel.poster; 
    urlImageCapa = widget.filmeModel.capa;
    tituloController.text = widget.filmeModel.titulo;
    generoController.text = widget.filmeModel.genero == "Escrever" || widget.filmeModel.genero == "Gênero desconhecido" ? "" : widget.filmeModel.genero;
    generoDropdown = widget.filmeModel.genero;
    sinopseController.text = widget.filmeModel.sinopse; 
    comentario = widget.filmeModel.comentario;
    notaController = widget.filmeModel.nota;

    // inicializando data
    dataSemFormatacao = widget.filmeModel.data;
    if(dataSemFormatacao.isEmpty){
      dataController.text = "";
    } else{
      dataController.text = FormatacoesService.dataFormatada(dataSemFormatacao);
      dataFilme = DateTime.parse(dataSemFormatacao);
    }
    
    // inicializando ingresso
    ingressoFormatado = widget.filmeModel.ingresso;
    ingressoFormatado != 0 ? ingressoController.text = UtilBrasilFields.obterReal(widget.filmeModel.ingresso) : ingressoController.text = "";
  
    setState(() {
      if(mostrarCarregamento && mostrarCarregamento && widget.filmeModel.id != 0){
        carregando = false;
      }
    });
    
  }

  atualizarCinemas() async {
    await cinemaRepository.obterDados();
    setState(() {});
  }


  List<DropdownMenuItem<String>> listarGenero(List<FilmeModel> lista) {
    Set<String> generosUnicos = {};
    
    // Use um conjunto para garantir valores únicos
    widget.filmeModel.genero == "Gênero desconhecido" || widget.filmeModel.genero == "Escrever" ? 

    generosUnicos.add("Escrever")
    :
    generosUnicos.add("Escrever"); // Adicione valores padrão

    for (var genero in lista) {
      generosUnicos.add(genero.genero);
    }

    List<DropdownMenuItem<String>> generos = [];

    for (var genero in generosUnicos) {
      generos.add(
        DropdownMenuItem<String>(
          value: genero,
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromARGB(124, 244, 67, 54),
                  ),
                  width: 45,
                  height: 45,
                  child: const Icon(Icons.local_movies_outlined, color: Colors.white),
                ),
                const SizedBox(width: 15),
                Flexible(child: Text(genero, style: GoogleFonts.montserrat(color: Colors.white), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ),
      );
    }

    return generos;
  }


  List<DropdownMenuItem<int>>? listarCinemas(List<CinemaModel> lista){
    List<DropdownMenuItem<int>> cinemas = [
      DropdownMenuItem <int>(
        value: 0,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color.fromARGB(124, 244, 67, 54),
            ),
              width: 45,
              height: 45,
              child: const Icon(Icons.smart_display_rounded, color: Colors.white)
            ),
            const SizedBox(width: 15),
            Text("Cadastrar cinema", style: GoogleFonts.montserrat(color: Colors.white)),
          ],
        ),
      ),
    ];

    for (var cinema in lista){
      cinemas.add(
        DropdownMenuItem <int>(
          value: cinema.id,
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color.fromARGB(124, 244, 67, 54),
                ),
                  width: 45,
                  height: 45,
                  child: const Icon(Icons.smart_display_rounded, color: Colors.white)
                ),
                const SizedBox(width: 15),
                Flexible(child: Text(cinema.nome, style: GoogleFonts.montserrat(color: Colors.white), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        )
      );
    }

    return cinemas;
  }

  @override
  Widget build(BuildContext context) {
    final providerFilme = Provider.of<FilmeRepository>(context, listen: false);
    final providerCinema = Provider.of<CinemaRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Filme", style: GoogleFonts.montserrat(color: Colors.white)),
        leading: Visibility(visible: false, child: Container()),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close_rounded, color: Colors.redAccent, size: 20)
          )
        ],
      ),
      body: carregando ?

      TelaDeCarregamento(mostrarBackground: true)
      
      :
      
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/scratch.png"),
            fit: BoxFit.cover
          ),
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 15, 26, 32), Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.3, 0.9]
          )
        ), 
        child: ListView(
          children: [
            SizedBox(
              height: 320,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  children: [
                    
                    Positioned(
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 84, 84, 84),
                            image: DecorationImage(
                              image: NetworkImage(urlImageCapa),
                              fit: BoxFit.cover,
                              colorFilter: const ColorFilter.mode(Colors.black38, BlendMode.darken)
                            )
                          )
                         
                        ),
                        onTap: () async {
                          await showModalBottomSheet(
                            shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            context: context, 
                            builder: (_){
                              return CustomModalBottom(
                                urlImageController: urlImageCapaController,
                                urlImage: urlImageCapa, 
                                atualizarVariaveis: (newUrlImageController, newUrlImage){
                                  setState(() {
                                      urlImageCapaController = newUrlImageController;
                                      urlImageCapa = newUrlImage;
                                  });
                                },
                              );
                            }
                          );
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                    ),
                    
                    Positioned(
                      bottom: 45,
                      left: 20,
                      child: Container(
                        height: 230,
                        width: 150,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(93, 158, 158, 158),
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: NetworkImage(urlImagePoster),
                              fit: BoxFit.cover,
                            ),
                          ),
                        
                        child: IconButton(
                          onPressed: () async {
                            await showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                              ),
                              context: context, 
                              builder: (_) {
                                return CustomModalBottom(
                                  urlImageController: urlImagePosterController,
                                  urlImage: urlImagePoster, 
                                  atualizarVariaveis: (newUrlImageController, newUrlImage){
                                    setState(() {
                                        urlImagePosterController = newUrlImageController;
                                        urlImagePoster = newUrlImage;
                                    });
                                  },
                                );
                              }
                            );
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          icon: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(9),
                              child: Icon(Icons.add, size: 20),
                            )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      
            const SizedBox(height: 30),
      
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextField(
                    controller: tituloController,
                    decoration: InputDecoration(
                      label: Text("Título", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17)),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      alignLabelWithHint: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                      prefixIcon: Container( 
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(124, 244, 67, 54),
                        ),
                        margin: const EdgeInsets.only(right: 15),
                        width: 45,
                        child: const Icon(Icons.movie_creation_outlined, color: Colors.white, ),
                      ),
                    ),
                    cursorColor: Colors.white,
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
            
                  const SizedBox(height: 25),
      
                  // ESCOLHENDO O GÊNERO DO FILME
                  escreverGenero 
                  
                  ?
      
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: generoController,
                          decoration: InputDecoration(
                            label: Text("Gênero", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17)),
                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            alignLabelWithHint: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 20),
                            prefixIcon: Container( 
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color.fromARGB(124, 244, 67, 54),
                              ),
                              margin: const EdgeInsets.only(right: 15),
                              width: 45,
                              child: const Icon(Icons.local_movies_outlined, color: Colors.white, ),
                            ),
                          ),
                          cursorColor: Colors.white,
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                      ),
      
                      const SizedBox(width: 10),
      
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: (){
                            escreverGenero = false;
                            setState(() {});
                          }, 
                          style: const ButtonStyle(
                            elevation: MaterialStatePropertyAll(8),
                            shadowColor: MaterialStatePropertyAll(Colors.white30),
                            backgroundColor: MaterialStatePropertyAll(Color.fromARGB(124, 244, 67, 54)),
                            fixedSize: MaterialStatePropertyAll(Size(20, 50)),
                          ),
                          child: Text("Opções", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15))
                        )
                      )
                    ],
                  )
      
                  :
      
                  DropdownButton <String>(
                    value: generoDropdown,
                    dropdownColor: const Color.fromARGB(255, 8, 16, 20),
                    iconEnabledColor: Colors.red,
                    itemHeight: 80,
                    menuMaxHeight: 500,
                    isExpanded: true,
                    onChanged: (value){
                      setState(() {
                        generoDropdown = value.toString();
                        generoController.text = generoDropdown!;
                        if(value.toString() == "Escrever"){
                          escreverGenero = true;
                          generoController.text = '';
                        }
                      });
                    },
                    hint: Text("Informe o gênero", style: GoogleFonts.montserrat(color: Colors.white)),
                    items: listarGenero(providerFilme.generos)
                  ),
                  // FIM DO CÓDIGO PARA ESCOLHER O GÊNERO
      
                  const SizedBox(height: 25),
      
                  // ESCOLHENDO O CINEMA ASSISTIDO
                  DropdownButton <int>(
                    value: idCinemaDropdown,
                    dropdownColor: const Color.fromARGB(255, 8, 16, 20),
                    iconEnabledColor: Colors.red,
                    itemHeight: 80,
                    menuMaxHeight: 500,
                    isExpanded: true,
                    onChanged: (value) async {
                      idCinemaDropdown = int.parse(value.toString());
      
                      if (idCinemaDropdown == 0) {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => RegistroCinemaPage(cinemaModel: CinemaModel.vazio())));
                        idCinemaDropdown = 0;
                        await atualizarCinemas();
                      } else {
                        idCinemaDropdown = int.parse(value.toString());
                      }
                      setState(() {});
                      
                    },
                    items: listarCinemas(providerCinema.cinemas),
                    hint: Text("Escolher cinema", style: GoogleFonts.montserrat(color: Colors.white)),
                  ),
      
                  // FIM DO CÓDIGO PARA ESCOLHER O CINEMA ASSISTIDO
      
                  const SizedBox(height: 25),
      
                  TextField(
                    controller: dataController,
                    maxLines: null,
                    readOnly: true,
                    onTap: () async {
                      var data =  await showDatePicker(
                        context: context, 
                        initialDate: dataFilme != null ? DateTime(dataFilme!.year, dataFilme!.month, dataFilme!.day) : DateTime.now(), 
                        firstDate: DateTime(1940, 1, 1), 
                        lastDate: DateTime(2100, 1, 1),
                      );
      
                      if(data != null && data.isBefore(DateTime.now())){
                        dataSemFormatacao = data.toString();
                        dataController.text = FormatacoesService.dataFormatada(data.toString());
                      } else{
                        dataController.text = "Escolha uma data válida...";
                      }
                    },
                    decoration: InputDecoration(
                      label: Text("Assistido em...", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17)),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      alignLabelWithHint: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                      prefixIcon: Container( 
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(124, 244, 67, 54),
                        ),
                        margin: const EdgeInsets.only(right: 15),
                        width: 45,
                        child: const Icon(Icons.calendar_month, color: Colors.white, ),
                      ),
                      suffix: InkWell(
                        onTap: (){
                          setState(() {
                            FocusManager.instance.primaryFocus?.unfocus();
                            dataController.text = "";
                            dataSemFormatacao = "";
                          });
                        },
                        child: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                      )
                    ),
                    cursorColor: Colors.white,
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
      
                  const SizedBox(height: 25),
      
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: ingressoController,
                          onChanged: (value){
                            ingressoFormatado = FormatacoesService.formatarParaDouble(value);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CentavosInputFormatter(moeda: true)
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            label: Text("Ingresso", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15)),
                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            alignLabelWithHint: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            prefixIcon: Container( 
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color.fromARGB(124, 244, 67, 54),
                              ),
                              margin: const EdgeInsets.only(right: 10),
                              width: 25,
                              child: const Icon(Icons.attach_money, color: Colors.white, ),
                            ),
                          ),
                          cursorColor: Colors.white,
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ), 
                      ),
      
                      const SizedBox(width: 10),
      
                      Expanded(
                        flex: 3,
                        child: CustomNotas(
                          notaController: notaController, 
                          updateValues: (newNotaController){
                            setState(() {
                              notaController = newNotaController;
                            });
                          }
                        )
                      )
                    ],
                  ),
      
                  const SizedBox(height: 25),
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container( 
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(124, 244, 67, 54),
                        ),
                        margin: const EdgeInsets.only(right: 15, top: 20),
                        width: 35,
                        height: 45,
                        child: const Icon(Icons.menu_book_sharp, color: Colors.white),
                      ),
                      Expanded(
                        child: TextField(
                          controller: sinopseController,
                          maxLines: null,
                          decoration: InputDecoration(
                            label: Text("Sinopse", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17)),
                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            alignLabelWithHint: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          cursorColor: Colors.white,
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
      
                  const SizedBox(height: 35),
      
                  widget.filmeModel.id == 0 ?
      
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(8),
                        shadowColor: MaterialStatePropertyAll(Colors.white30),
                        backgroundColor: MaterialStatePropertyAll(Color.fromARGB(124, 244, 67, 54)),
                        fixedSize: MaterialStatePropertyAll(Size(20, 50)),
                      ),
                      onPressed: () async {
      
                        if(tituloController.text.trim().isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Row(
                              children: [
                                const Icon(Icons.warning, color: Colors.red),
                                const SizedBox(width: 5),
                                Text("Informe o título do filme!", style: GoogleFonts.montserrat(color: Colors.white)),
                              ],
                            ))
                          );
                        } else {
                          await filmeRepository.salvar(
                            FilmeModel.salvar( 
                              idCinemaDropdown!, 
                              urlImagePoster.trim(), 
                              urlImageCapa.trim(), 
                              tituloController.text.trim(), 
                              generoController.text.trim().isEmpty ? "Gênero desconhecido" : generoController.text.trim(), 
                              dataSemFormatacao.trim(), 
                              ingressoFormatado, 
                              sinopseController.text.trim(), 
                              comentario.trim(), 
                              notaController
                            )
                          );

                          if(widget.filmesEmBreve){
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            // ignore: use_build_context_synchronously
                            Navigator.popAndPushNamed(context, "Filmes_Page");
                          } else{
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          }
                          
                        }
                       
                      }, 
                      child: Text('Salvar', style: GoogleFonts.anton(color: Colors.white, fontSize: 17)) 
                    ),
                  )
      
                  :
      
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(8),
                        shadowColor: MaterialStatePropertyAll(Colors.white30),
                        backgroundColor: MaterialStatePropertyAll(Color.fromARGB(124, 244, 67, 54)),
                        fixedSize: MaterialStatePropertyAll(Size(20, 50)),
                      ),
                      onPressed: () async {
      
                        if(tituloController.text.trim().isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Row(
                              children: [
                                const Icon(Icons.warning, color: Colors.red),
                                const SizedBox(width: 5),
                                Text("Informe o título do filme!", style: GoogleFonts.montserrat(color: Colors.white)),
                              ],
                            ))
                          );
                        } else{
                          await filmeRepository.atualizar(
                            FilmeModel(
                              widget.filmeModel.id, 
                              idCinemaDropdown!, 
                              urlImagePoster.trim(), 
                              urlImageCapa.trim(), 
                              tituloController.text.trim(), 
                              generoController.text.trim().isEmpty ? "Gênero desconhecido" : generoController.text.trim(),
                              dataSemFormatacao, 
                              ingressoFormatado, 
                              sinopseController.text.trim(), 
                              comentario.trim(), 
                              notaController
                            )
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                       
                      }, 
                      child: Text('Salvar', style: GoogleFonts.anton(color: Colors.white, fontSize: 17)) 
                    ),
                  )
      
                ],
              ),
            ),
      
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}