import 'package:app_sweet_cine/emBreve/emBreve_page.dart';
import 'package:app_sweet_cine/model/cinema_model.dart';
import 'package:app_sweet_cine/model/filme_model.dart';
import 'package:app_sweet_cine/pages/cinemas/cinemas_page.dart';
import 'package:app_sweet_cine/pages/configuracoes_page.dart';
import 'package:app_sweet_cine/pages/filmes/filmes_page.dart';
import 'package:app_sweet_cine/pages/home_page.dart';
import 'package:app_sweet_cine/pages/infos_page.dart';
import 'package:app_sweet_cine/pages/registro/registro_cinema_pages.dart';
import 'package:app_sweet_cine/pages/registro/registro_filme_pages.dart';
import 'package:app_sweet_cine/repositories/cinema_repository.dart';
import 'package:app_sweet_cine/repositories/emBreve_repository.dart';
import 'package:app_sweet_cine/repositories/filme_repository.dart';
import 'package:app_sweet_cine/pages/splash_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CinemaRepository()),
        ChangeNotifierProvider(create: (_) => FilmeRepository()),
        ChangeNotifierProvider(create: (_) => EmBreveRepository())
      ],
      child: const SweetCine(),
    )
    
  );
}

class SweetCine extends StatelessWidget{
  const SweetCine({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 15, 26, 32),
          toolbarHeight: 80,
          centerTitle: true
        ),
        canvasColor: const Color.fromARGB(255, 15, 26, 32),
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(Colors.white)
          )
        ),
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Color.fromARGB(255, 141, 141, 141),
          headerBackgroundColor: Color.fromARGB(255, 15, 26, 32),
          dayForegroundColor: MaterialStatePropertyAll(Colors.black),
          weekdayStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          yearForegroundColor: MaterialStatePropertyAll(Colors.black),
          todayBackgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 15, 26, 32)),
          todayForegroundColor: MaterialStatePropertyAll(Color.fromARGB(178, 255, 255, 255)),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: Colors.black),
            fillColor: Colors.red,
            floatingLabelStyle: TextStyle(color: Colors.white),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          )
        ),
      ),
      routes: {
        "Home_Page": (context) => const HomePage(),
        "Cinemas_Page": (context) => const CinemaPage(),
        "Filmes_Page": (context) => const FilmePage(),
        "Em_Breve_Page": (context) => const EmBrevePage(),
        "Infos_Page": (context) => const InfosPage(),
        "Registro_Cinemas" : (context) => RegistroCinemaPage(cinemaModel: CinemaModel.vazio()),
        "Registro_Filmes": (context) => RegistroFilmePage(filmeModel: FilmeModel.vazio(), filmesEmBreve: false),
        "Configuracoes_Page": (context) => const ConfiguracoesPage()
      },
      debugShowCheckedModeBanner: false,
      home: const SplashScreenPage(),
    );
  }
}