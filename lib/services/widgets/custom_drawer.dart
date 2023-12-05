import 'package:app_sweet_cine/services/widgets/custom_logoApp.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      child: Container(
        color: const Color.fromARGB(255, 15, 26, 32),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 0),
          children: [
            Container(
              height: 300,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(93, 255, 63, 63),
                    Color.fromARGB(255, 15, 26, 32)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.5]
                )
              ),
              child: CustomLogoApp(fontSizeTitle: 25, fontSizeSubtitle: 20)
            ),
    
            const SizedBox(height: 40),
    
            InkWell(
              onTap: (){
                Navigator.pop(context);
                if(Navigator.of(context).canPop()){
                  final currentRoute = ModalRoute.of(context);
                  if(currentRoute != null && currentRoute.settings.name != 'Home_Page'){
                    Navigator.of(context).pushNamed("Home_Page");
                  }
                } else{
                  Navigator.of(context).pushNamed("Home_Page");
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 30,
                      child: Center(child: FaIcon(FontAwesomeIcons.house, color: Colors.white))
                    ),
                    const SizedBox(width: 25),
                    Text('Home', style: GoogleFonts.montserrat(color: Colors.white60, fontSize: 16))
                  ],
                ),
              ),
            ),
    
    
            InkWell(
              onTap: (){
                Navigator.pop(context);
                if(Navigator.of(context).canPop()){
                  final currentRoute = ModalRoute.of(context);
                  if(currentRoute != null && currentRoute.settings.name != 'Filmes_Page'){
                    Navigator.of(context).pushNamed("Filmes_Page");
                  }
                } else{
                  Navigator.of(context).pushNamed("Filmes_Page");
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Center(child: Image.asset('assets/video.png'))
                    ),
                    const SizedBox(width: 25),
                    Text('Filmes', style: GoogleFonts.montserrat(color: Colors.white60, fontSize: 16))
                  ],
                ),
              ),
            ),
    
    
            InkWell(
              onTap: (){
                Navigator.pop(context);
                if(Navigator.of(context).canPop()){
                  final currentRoute = ModalRoute.of(context);
                  if(currentRoute != null && currentRoute.settings.name != 'Cinemas_Page'){
                    Navigator.of(context).pushNamed("Cinemas_Page");
                  }
                } else{
                  Navigator.of(context).pushNamed("Cinemas_Page");
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Center(child: Image.asset("assets/pipoca.png"))
                    ),
                    const SizedBox(width: 25),
                    Text('Cinemas', style: GoogleFonts.montserrat(color: Colors.white60, fontSize: 16))
                  ],
                ),
              ),
            ),


            InkWell(
              onTap: (){
                Navigator.pop(context);
                if(Navigator.of(context).canPop()){
                  final currentRoute = ModalRoute.of(context);
                  if(currentRoute != null && currentRoute.settings.name != 'Em_Breve_Page'){
                    Navigator.of(context).pushNamed("Em_Breve_Page");
                  }
                } else{
                  Navigator.of(context).pushNamed("Em_Breve_Page");
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Center(child: Image.asset('assets/ingresso-de-filme.png', color: Colors.white,))
                    ),
                    const SizedBox(width: 25),
                    Text('Em Breve', style: GoogleFonts.montserrat(color: Colors.white60, fontSize: 16))
                  ],
                ),
              ),
            ),
    
    
            InkWell(
              onTap: (){
                Navigator.pop(context);
                if(Navigator.of(context).canPop()){
                  final currentRoute = ModalRoute.of(context);
                  if(currentRoute != null && currentRoute.settings.name != 'Infos_Page'){
                    Navigator.of(context).pushNamed("Infos_Page");
                  }
                } else{
                  Navigator.of(context).pushNamed("Infos_Page");
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 30,
                      child: Center(child: FaIcon(FontAwesomeIcons.info, color: Colors.white))
                    ),
                    const SizedBox(width: 25),
                    Text('Informações', style: GoogleFonts.montserrat(color: Colors.white60, fontSize: 16))
                  ],
                ),
              ),
            ),


            InkWell(
              onTap: (){
                Navigator.pop(context);
                if(Navigator.of(context).canPop()){
                  final currentRoute = ModalRoute.of(context);
                  if(currentRoute != null && currentRoute.settings.name != 'Configuracoes_Page'){
                    Navigator.of(context).pushNamed("Configuracoes_Page");
                  }
                } else{
                  Navigator.of(context).pushNamed("Configuracoes_Page");
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 30,
                      child: Center(child: Icon(Icons.miscellaneous_services_outlined, color: Colors.white60))
                    ),
                    const SizedBox(width: 25),
                    Text('Configurações', style: GoogleFonts.montserrat(color: Colors.white60, fontSize: 16))
                  ],
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}