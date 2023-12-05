import 'package:app_sweet_cine/model/cinema_model.dart';
import 'package:app_sweet_cine/repositories/cinema_repository.dart';
import 'package:app_sweet_cine/services/estados_services.dart';
import 'package:app_sweet_cine/services/notas_services.dart';
import 'package:app_sweet_cine/services/widgets/custom_estados.dart';
import 'package:app_sweet_cine/services/widgets/custom_modalBottom.dart';
import 'package:app_sweet_cine/services/widgets/custom_notas.dart';
import 'package:app_sweet_cine/services/widgets/custom_tela_de_carregamento.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class RegistroCinemaPage extends StatefulWidget {
  CinemaModel cinemaModel;
  RegistroCinemaPage({super.key, required this.cinemaModel});

  @override
  State<RegistroCinemaPage> createState() => _RegistroCinemaPageState();
}

class _RegistroCinemaPageState extends State<RegistroCinemaPage> {
  var cinemaRepository = CinemaRepository();
  
  // valores para o banco de dados
  var urlImage = "";
  var nomeController = TextEditingController(text: "");
  var bairroController = TextEditingController(text: "");
  var cidadeController = TextEditingController(text: "");
  String estado = "";
  String comentario = "";
  int notaController = 0;
  // valores para o banco de dados

  // setando imagem do cinema
  var urlImageController = TextEditingController(text: "");
  // fim do set de imagem do cinema

  bool carregando = false;

  @override
  void initState() {
    obterDados(true);
    super.initState();
  }

  obterDados(bool mostrarCarregamento) async {
    await carregarValores(mostrarCarregamento);
    setState((){});
  }

  carregarValores(bool mostrarCarregamento){
    if(mostrarCarregamento && widget.cinemaModel.id != 0){
      carregando = true;
    }

    nomeController.text = widget.cinemaModel.nome;
    bairroController.text = widget.cinemaModel.bairro;
    cidadeController.text = widget.cinemaModel.cidade;
    estado = widget.cinemaModel.estado.isEmpty ? EstadosServices.obterEstados()[0] : widget.cinemaModel.estado; 
    urlImage = widget.cinemaModel.fotoDoCinema;
    notaController = widget.cinemaModel.nota != 0 ? widget.cinemaModel.nota : NotasServices.obterNotas()[0].nota;
    comentario = widget.cinemaModel.comentario;

    if(mostrarCarregamento && widget.cinemaModel.id != 0){
      carregando = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cinema", style: GoogleFonts.montserrat(color: Colors.white)),
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

            Container(
              height: 320,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 84, 84, 84),
                image: DecorationImage(
                  image: NetworkImage(urlImage),
                  fit: BoxFit.cover
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 40),
                onPressed: () async {
                  // ignore: use_build_context_synchronously
                  await showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    context: context, 
                    builder: (_){
                      return CustomModalBottom(
                        urlImageController: urlImageController,
                        urlImage: urlImage,
                        atualizarVariaveis: (newUrlImageController, newUrlImage){
                          setState(() {
                            urlImageController = newUrlImageController;
                            urlImage = newUrlImage;
                          });
                        },
                      );
                    }
                  );
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: InputDecoration(
                      label: Text("Nome", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17)),
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
                        child: const Icon(Icons.home_work_outlined, color: Colors.white, ),
                      ),
                    ),
                    cursorColor: Colors.white,
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
            
                  const SizedBox(height: 25),
            
                  TextField(
                    controller: bairroController,
                    decoration: InputDecoration(
                      label: Text("Bairro", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17)),
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
                        child: const Icon(Icons.location_pin, color: Colors.white),
                      ),
                    ),
                    cursorColor: Colors.white,
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
            
                  const SizedBox(height: 25),
            
                  TextField(
                    controller: cidadeController,
                    decoration: InputDecoration(
                      label: Text("Cidade", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17)),
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
                        child: const Icon(Icons.location_city_outlined, color: Colors.white),
                      ),
                    ),
                    cursorColor: Colors.white,
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
            
                  const SizedBox(height: 20),

                  CustomEstados(
                    estado: estado, 
                    updateEstado: (newEstado) {
                      setState(() {
                        estado = newEstado;
                      });
                    }
                  ),
            
                  const SizedBox(height: 15),
            
                  CustomNotas( 
                    notaController: notaController,
                    updateValues: (newNotaController) {
                      setState(() {
                        notaController = newNotaController;
                      });
                    },
                  ),
            
                  const SizedBox(height: 35),
            
                  SizedBox(
                    width: double.infinity,
                    child: 
                    
                    widget.cinemaModel.nome == "" ?

                    TextButton(
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(8),
                        shadowColor: MaterialStatePropertyAll(Colors.white30),
                        backgroundColor: MaterialStatePropertyAll(Color.fromARGB(124, 244, 67, 54)),
                        fixedSize: MaterialStatePropertyAll(Size(20, 50)),
                      ),
                      onPressed: () async {

                        if(nomeController.text.trim().isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Row(
                              children: [
                                const Icon(Icons.warning, color: Colors.red),
                                const SizedBox(width: 5),
                                Text("Nome do cinema precisa ser informado!", style: GoogleFonts.montserrat(color: Colors.white)),
                              ],
                            ))
                          );
                        } else{
                          await cinemaRepository.salvar(
                            CinemaModel(
                              widget.cinemaModel.id,
                              nomeController.text.trim(), 
                              bairroController.text.trim(), 
                              cidadeController.text.trim(), 
                              estado.trim(), 
                              urlImage.trim(), 
                              notaController, 
                              comentario.trim()
                            )
                          );

                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                        
                      }, 
                      child: Text('Salvar', style: GoogleFonts.anton(color: Colors.white, fontSize: 17)) 
                    )

                    :

                    TextButton(
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(8),
                        shadowColor: MaterialStatePropertyAll(Colors.white30),
                        backgroundColor: MaterialStatePropertyAll(Color.fromARGB(124, 244, 67, 54)),
                        fixedSize: MaterialStatePropertyAll(Size(20, 50)),
                      ),
                      onPressed: () async {

                        if(nomeController.text.trim().isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Row(
                              children: [
                                const Icon(Icons.warning, color: Colors.red),
                                const SizedBox(width: 5),
                                Text("Nome do cinema precisa ser informado!", style: GoogleFonts.montserrat(color: Colors.white)),
                              ],
                            ))
                          );
                        } else{
                          await cinemaRepository.atualizar(
                            CinemaModel(
                              widget.cinemaModel.id,
                              nomeController.text.trim(), 
                              bairroController.text.trim(), 
                              cidadeController.text.trim(), 
                              estado.trim(), 
                              urlImage.trim(), 
                              notaController, 
                              comentario.trim(),
                            )
                          );
                          
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }

                      }, 
                      child: Text('Salvar', style: GoogleFonts.anton(color: Colors.white, fontSize: 17)) 
                    )

                  )
                ],
              ),
            ),

            const SizedBox(height: 30)

          ],
        ),
      ),
    );
  }
}