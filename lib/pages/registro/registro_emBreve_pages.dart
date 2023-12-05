import 'package:app_sweet_cine/model/emBreve_model.dart';
import 'package:app_sweet_cine/repositories/emBreve_repository.dart';
import 'package:app_sweet_cine/services/formatacoes_services.dart';
import 'package:app_sweet_cine/services/widgets/custom_modalBottom.dart';
import 'package:app_sweet_cine/services/widgets/custom_tela_de_carregamento.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RegistroEmBrevePages extends StatefulWidget{
  EmBreveModel filmeModel;
  RegistroEmBrevePages({super.key, required this.filmeModel});

  @override
  State<RegistroEmBrevePages> createState() => _RegistroEmBrevePagesState();
}

class _RegistroEmBrevePagesState extends State<RegistroEmBrevePages>{

    // variaveis condicionais e de transição
  EmBreveRepository filmeEmBreveRepository = EmBreveRepository();

 
  int? idCinemaDropdown;
  bool? filmeAssistido;

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
  var dataController = TextEditingController(text: "");
  var sinopseController = TextEditingController(text: "");
  bool carregando = false;

  @override
  void initState() {
    carregarDados(true);
    super.initState();
  }

  // CARREGAR GÊNEROS E CINEMAS
  Future<void> carregarDados(bool mostrarCarregamento) async {
    filmeEmBreveRepository = Provider.of<EmBreveRepository>(context, listen: false);
    await carregarValores(mostrarCarregamento);
    setState((){});
  }

  carregarValores(bool mostrarCarregamento){
    setState(() {
      if(mostrarCarregamento && widget.filmeModel.id != 0){
        carregando = true;
      }
    });
   
    urlImagePoster = widget.filmeModel.poster; 
    urlImageCapa = widget.filmeModel.capa;
    tituloController.text = widget.filmeModel.titulo;
    sinopseController.text = widget.filmeModel.sinopse;
    filmeAssistido = widget.filmeModel.assistido;
    // inicializando data
    dataSemFormatacao = widget.filmeModel.dataLancamento;
    if(dataSemFormatacao.isEmpty){
      dataController.text = "";
    } else{
      dataController.text = FormatacoesService.dataFormatada(dataSemFormatacao);
      dataFilme = DateTime.parse(dataSemFormatacao);
    }

    setState(() {
      if(mostrarCarregamento && widget.filmeModel.id != 0){
        carregando = false;
      }
    });
  
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Em breve", style: GoogleFonts.montserrat(color: Colors.white)),
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
      
                      if(data != null){
                        dataSemFormatacao = data.toString();
                        dataController.text = FormatacoesService.dataFormatada(data.toString());
                      }
                    },
                    decoration: InputDecoration(
                      label: Text("Assistir em...", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17)),
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
                        child: const Icon(Icons.calendar_month, color: Colors.white),
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
                      ),
                      
                    ),
                    cursorColor: Colors.white,
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),

                  const SizedBox(height: 25),

                  DropdownButton <bool>(
                    value: filmeAssistido,
                    dropdownColor: const Color.fromARGB(255, 8, 16, 20),
                    iconEnabledColor: Colors.red,
                    itemHeight: 80,
                    menuMaxHeight: 500,
                    isExpanded: true,
                    onChanged: (value){
                      setState(() {
                        filmeAssistido = value;
                      });
                      
                    },
                    items: [
                      DropdownMenuItem <bool>(
                        value: false,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color.fromARGB(124, 244, 67, 54),
                            ),
                              width: 45,
                              height: 45,
                              child: const Icon(Icons.remove_red_eye_outlined, color: Colors.white)
                            ),
                            const SizedBox(width: 15),
                            Text("Não assistido", style: GoogleFonts.montserrat(color: Colors.white)),
                          ],
                        ),
                      ),
                      DropdownMenuItem <bool>(
                        value: true,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color.fromARGB(124, 244, 67, 54),
                            ),
                              width: 45,
                              height: 45,
                              child: const Icon(Icons.remove_red_eye_outlined, color: Colors.white)
                            ),
                            const SizedBox(width: 15),
                            Text("Assistido", style: GoogleFonts.montserrat(color: Colors.white)),
                          ],
                        ),
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
                          await filmeEmBreveRepository.salvar(
                            EmBreveModel(
                              tituloController.text.trim(), 
                              urlImagePoster.trim(), 
                              urlImageCapa.trim(),
                              sinopseController.text.trim(),
                              filmeAssistido!,
                              dataSemFormatacao.isEmpty ? DateTime.now().toString() : dataSemFormatacao.trim(), 
                            )
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
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
                          await filmeEmBreveRepository.atualizar(
                            EmBreveModel.completo(
                              widget.filmeModel.id,
                              tituloController.text.trim(), 
                              urlImagePoster.trim(), 
                              urlImageCapa.trim(),
                              sinopseController.text.trim(),
                              filmeAssistido!,
                              dataSemFormatacao.isEmpty ? DateTime.now().toString() : dataSemFormatacao.trim(), 
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