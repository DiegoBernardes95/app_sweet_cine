import 'package:app_sweet_cine/model/cinema_model.dart';
import 'package:app_sweet_cine/model/filme_model.dart';
import 'package:app_sweet_cine/repositories/cinema_repository.dart';
import 'package:app_sweet_cine/repositories/filme_repository.dart';
import 'package:app_sweet_cine/services/widgets/custom_drawer.dart';
import 'package:app_sweet_cine/services/widgets/custom_logoApp.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfiguracoesPage extends StatefulWidget{
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage>{
  PackageInfo packageInfo = PackageInfo(appName: "", packageName: "", version: "", buildNumber: "");
  CinemaRepository cinemaRepository = CinemaRepository();
  FilmeRepository filmeRepository = FilmeRepository();
  bool exclusaoConfirmada = false;

  @override
  initState(){
    carregarDados();
    super.initState();
  }


  Future<void> carregarDados() async {
    cinemaRepository = Provider.of<CinemaRepository>(context, listen: false);
    filmeRepository = Provider.of<FilmeRepository>(context, listen: false);
    packageInfo = await PackageInfo.fromPlatform();

    await cinemaRepository.obterDados();
    await filmeRepository.obterListaDeFilmes();
    setState(() {});
  }

  // VERIFICA SE O COMPONENTE HOME_PAGE ESTÁ NA ARVORE DE WIDGETS
  void verificarHomeNaPilha () {
    if (exclusaoConfirmada) {  
      bool homePageNaPilha = false;
      // ignore: use_build_context_synchronously
      Navigator.popUntil(context, (route) {
        if (route.settings.name == "Home_Page") { // Verificar se "Home_Page" está na pilha
          homePageNaPilha = true;
          return true;
        }
        return false;
      });

      
      if (homePageNaPilha) { // Se "Home_Page" estiver na pilha, remova-a
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop("Home_Page");
      }

      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, "Home_Page"); // Empurrar uma nova instância de "Home_Page"
    }
  }
   
  // FUNÇÃO PARA EXCLUSÃO DOS DADOS
  AlertDialog excluirDados(Function() dadosRepository, Function() navigator, String contentAlert){
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 15, 26, 32),
      title: Text("Excluir", style: GoogleFonts.anton(color: Colors.white, fontSize: 19)),
      content: Text("Excluir todos os $contentAlert?", style: GoogleFonts.montserrat(color: Colors.white)),
      actions: [
        TextButton(
          onPressed: () async {
            await dadosRepository();
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            navigator();

          }, 
          child: Text("Sim", style: GoogleFonts.montserrat(color: Colors.white))
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
          }, 
          child: Text("Não", style: GoogleFonts.montserrat(color: Colors.white))
        ),
      ],
    );
  }

  // FORMATAÇÃO PARA COMPARTILHAMENTO DE DADOS DOS FILMES
  String formatarDadosFilmes(List<FilmeModel> filmes){
    StringBuffer buffer = StringBuffer();

    for(FilmeModel filme in filmes){
      buffer.writeln("Titulo: ${filme.titulo}");
      buffer.writeln("Gênero: ${filme.genero}");
      buffer.writeln("Capa: ${filme.capa}");
      buffer.writeln("Poster: ${filme.poster}");
      buffer.writeln("Cinema assistido: ${filme.cinemaAssistido}");
      buffer.writeln("Data: ${filme.data}");
      buffer.writeln("Ingresso: ${filme.ingresso}");
      buffer.writeln("Nota: ${filme.nota}");
      buffer.writeln("Sinopse: ${filme.sinopse}");
      buffer.writeln("Comentario: ${filme.comentario}");
      buffer.writeln("---------------------------------------x---------------------------------------");
    }

    return buffer.toString();
  }

 // FORMATAÇÃO PARA COMPARTILHAMENTO DE DADOS DOS CINEMAS
  String formatarDadosCinemas(List<CinemaModel> cinemas){
    StringBuffer buffer = StringBuffer();

    for(CinemaModel cinema in cinemas){
      buffer.writeln("Nome: ${cinema.nome}");
      buffer.writeln("Foto do cinema: ${cinema.fotoDoCinema}");
      buffer.writeln("Bairro: ${cinema.bairro}");
      buffer.writeln("Cidade: ${cinema.cidade}");
      buffer.writeln("Estado: ${cinema.estado}");
      buffer.writeln("Comentário: ${cinema.comentario}");
      buffer.writeln("Nota: ${cinema.nota}");
      buffer.writeln("Total de ingressos: ${cinema.totalDeIngressos}");
      buffer.writeln("Filmes assitidos: ${cinema.filmesAssistidos}");
      buffer.writeln("---------------------------------------x---------------------------------------");
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context){
    final configFilmes = Provider.of<FilmeRepository>(context, listen: false);
    final configCinemas = Provider.of<CinemaRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: CustomLogoApp(fontSizeTitle: 22, fontSizeSubtitle: 17),
      ),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/scratch.png"),
            fit: BoxFit.cover
          ),
          gradient: LinearGradient(
            colors: [Colors.black, Colors.transparent, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          children: [

            Center(child: Text("Configurações", style: GoogleFonts.anton(color: Colors.white, fontSize: 20))),

            const SizedBox(height: 70),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Compartilhamento", style: GoogleFonts.anton(color: Colors.white, fontSize: 20)),
                const SizedBox(height: 40),
                Container(
                  padding:  const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Compartilhar dados de filmes", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16)),
                              const Icon(Icons.share, color: Colors.white)
                            ],
                          ),
                        ),
                        onTap: (){
                          // codigo para compartilhamento de dados dos filmes
                          if(configFilmes.filmes.isNotEmpty){
                            Share.share(formatarDadosFilmes(configFilmes.filmes));
                          } else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Row(
                                children: [
                                  const Icon(Icons.warning, color: Colors.red),
                                  const SizedBox(width: 5),
                                  Text("Nenhum filme encontrado!", style: GoogleFonts.montserrat(color: Colors.white)),
                                ],
                              )
                            ));
                          }
                        },
                      )
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),

                Container(
                  padding:  const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Compartilhar dados de cinemas", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16)),
                              const Icon(Icons.share, color: Colors.white)
                            ],
                          ),
                        ),
                        onTap: (){
                          // codigo para compartilhamento de dados dos cinemas
                          if(configCinemas.cinemas.isNotEmpty){
                            Share.share(formatarDadosCinemas(configCinemas.cinemas));
                          } else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Row(
                                children: [
                                  const Icon(Icons.warning, color: Colors.red),
                                  const SizedBox(width: 5),
                                  Text("Nenhum cinema encontrado!", style: GoogleFonts.montserrat(color: Colors.white)),
                                ],
                              )
                            ));
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 50),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Excluir", style: GoogleFonts.anton(color: Colors.white, fontSize: 20)),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Excluir todos os registros", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16)),
                              const Icon(Icons.delete_forever, color: Colors.red)
                            ],
                          ),
                        ),
                        onTap: () async {
                          await showDialog(
                            context: context, 
                            builder: (_){
                              return excluirDados(
                                () async {
                                  if(cinemaRepository.cinemas.isEmpty && filmeRepository.filmes.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Row(
                                        children: [
                                          const Icon(Icons.warning, color: Colors.red),
                                          const SizedBox(width: 5),
                                          Text("Não há registros de filmes ou cinemas!", style: GoogleFonts.montserrat(color: Colors.white)),
                                        ],
                                      )
                                    ));
                                  } else{
                                    await cinemaRepository.removerTodosOsCinema();
                                    await filmeRepository.removerTodosOsFilmes();
                                  }
                                }, 
                                () => exclusaoConfirmada = cinemaRepository.cinemas.isEmpty && filmeRepository.filmes.isEmpty ? false : true,
                                "registros"
                              );
                            }
                          );
                          verificarHomeNaPilha();
                        },
                      ),

                      const SizedBox(height: 20),

                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Excluir todos os filmes", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16)),
                              const Icon(Icons.delete_forever, color: Colors.red)
                            ],
                          ),
                        ),
                        onTap: () async {
                          await showDialog(
                            context: context, 
                            builder: (_){
                              return excluirDados(
                                () async {
                                  if(filmeRepository.filmes.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Row(
                                        children: [
                                          const Icon(Icons.warning, color: Colors.red),
                                          const SizedBox(width: 5),
                                          Text("A lista de filmes já está vazia!", style: GoogleFonts.montserrat(color: Colors.white)),
                                        ],
                                      )
                                    ));
                                  } else{
                                    await filmeRepository.removerTodosOsFilmes();
                                  }
                                },
                                () => exclusaoConfirmada = filmeRepository.filmes.isEmpty ? false : true, 
                                "filmes"
                              );
                            }
                          );
                          verificarHomeNaPilha();
                        },
                      ),

                      const SizedBox(height: 20),

                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Excluir todos os cinemas", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16)),
                              const Icon(Icons.delete_forever, color: Colors.red)
                            ],
                          ),
                        ),
                        onTap: () async {
                          await showDialog(
                            context: context, 
                            builder: (_){
                              return excluirDados(
                                () async {
                                  if(cinemaRepository.cinemas.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Row(
                                        children: [
                                          const Icon(Icons.warning, color: Colors.red),
                                          const SizedBox(width: 5),
                                          Text("A lista de cinemas já está vazia!", style: GoogleFonts.montserrat(color: Colors.white)),
                                        ],
                                      )
                                    ));
                                  } else{
                                    await cinemaRepository.removerTodosOsCinema();
                                  }
                                },
                                () => exclusaoConfirmada = cinemaRepository.cinemas.isEmpty ? false : true,
                                "cinemas"
                              );
                            }
                          );

                          verificarHomeNaPilha();

                        },
                      ),

                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 50),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sobre", style: GoogleFonts.anton(color: Colors.white, fontSize: 20)),
                const SizedBox(height: 40),

                Container(
                  padding:  const EdgeInsets.symmetric(horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Desenvolvedor: ", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16)),
                        Text("Diego Bernardes", style: GoogleFonts.montserrat(color: Colors.grey))
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Versão:", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16)),
                        Text(packageInfo.version, style: GoogleFonts.montserrat(color: Colors.grey))
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Redes Sociais:", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16)),
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                await launchUrl(Uri.parse("https://www.linkedin.com/in/diegobernardes-webdev/"));
                              }, 
                              child: const FaIcon(FontAwesomeIcons.linkedin, color: Color.fromARGB(255, 21, 122, 173)),
                            ),
                            const SizedBox(width: 25),
                        
                            InkWell(
                              onTap: () async {
                                await launchUrl(Uri.parse("https://github.com/DiegoBernardes95"));
                              }, 
                              child: const FaIcon(FontAwesomeIcons.github, color: Colors.grey),
                            ),
                            const SizedBox(width: 25),
                        
                            InkWell(
                              onTap: () async {
                                await launchUrl(Uri.parse("https://www.instagram.com/diego.dovahkiin/"));
                              }, 
                              child: const FaIcon(FontAwesomeIcons.instagram, color: Color.fromARGB(255, 255, 63, 63)),
                            ),
                          ]
                        )
                      ],
                    ),
                  ),
                ),
                
              ],
            ),
            

          ],
        ),
      ),
    );
  }
}