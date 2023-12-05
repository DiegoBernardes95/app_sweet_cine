import 'package:app_sweet_cine/services/widgets/custom_tela_de_carregamento.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class CustomModalBottom extends StatefulWidget {

  TextEditingController urlImageController;
  String urlImage;
  Function(TextEditingController, String) atualizarVariaveis;

  CustomModalBottom({
    super.key, 
    required this.urlImageController,
    required this.urlImage,
    required this.atualizarVariaveis
  });

  @override
  State<CustomModalBottom> createState() => _CustomModalBottomState();
}

class _CustomModalBottomState extends State<CustomModalBottom> {
  bool carregando = false;

  @override
  void initState() {
    widget.urlImageController.text = widget.urlImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("assets/scratch.png"),
            //   fit: BoxFit.cover
            // ),
            gradient: LinearGradient(
              colors: [Colors.black, Color.fromARGB(255, 15, 26, 32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
            )
          ),
          child: carregando ?

          TelaDeCarregamento(mostrarBackground: false)

          :
          
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 55),
            children: [
    
              Text("Salvar imagem:", style: GoogleFonts.anton(color: Colors.white, fontSize: 25), textAlign: TextAlign.center),

              const SizedBox(height: 60),

              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.montserrat(color: Colors.white),
                    text: "1º - Pesquise a imagem desejada - digite o que procura e clique em ",
                    children: const [
                      TextSpan(
                        style: TextStyle(color: Colors.redAccent),
                        text: "Pesquisar"
                      )
                    ]
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.montserrat(color: Colors.white),
                    text: "2º - Após copiar o URL da imagem, cole no campo de texto e clique em ",
                    children: const [
                      TextSpan(
                        style: TextStyle(color: Colors.redAccent),
                        text: "Salvar"
                      )
                    ]
                  ),
                ),
              ),


              const SizedBox(height: 40),
          
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: widget.urlImageController,
                  decoration: InputDecoration(
                    label: Text("Insira o URL ou pesquise...", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17)),
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
                      child: const Icon(Icons.image, color: Colors.white, ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                      onPressed: (){
                        widget.urlImageController.text = "";
                      },
                    )
                  ),
                  cursorColor: Colors.white,
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
              ),
                
              const SizedBox(height: 20),
                
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
    
                  // PESQUISAR IMAGEM
                  TextButton(
                    onPressed: () async {
                      if(widget.urlImageController.text.trim().isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Campo de pesquisa vazio...", style: GoogleFonts.montserrat(color: Colors.white)))
                        );
                      } else{
                        setState(() {
                          carregando = true;
                        });

                        await launchUrl(Uri.parse("https://www.google.com/search?q=${widget.urlImageController.text}&tbm=isch"));
                        await Future.delayed(const Duration(seconds: 3));

                        setState(() {
                          carregando = false;
                        });
                      }
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Color.fromARGB(93, 158, 158, 158))
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white),
                        const SizedBox(width: 5),
                        Text("Pesquisar", style: GoogleFonts.montserrat(color: Colors.white)),
                      ],
                    ),
                    
                  ),
              
                  const SizedBox(width: 20),
              
                  // SALVAR IMAGEM
                  TextButton(
                    onPressed: (){
                      widget.urlImage = widget.urlImageController.text.trim();
                      widget.atualizarVariaveis(widget.urlImageController, widget.urlImage);
                      FocusManager.instance.primaryFocus?.unfocus();
                      Navigator.pop(context);
                      setState((){});
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Color.fromARGB(124, 244, 67, 54))
                    ),
                    child: Text("Salvar", style: GoogleFonts.montserrat(color: Colors.white)),
                  ),

                  const SizedBox(width: 8),
    
                  // SAIR 
                  TextButton(
                    onPressed: (){
                      FocusManager.instance.primaryFocus?.unfocus();
                      Navigator.pop(context);
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black45)
                    ),
                    child: Text("Cancelar", style: GoogleFonts.montserrat(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),

        ),
    );
  }
    
}