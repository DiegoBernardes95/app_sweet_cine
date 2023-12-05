import 'package:app_sweet_cine/model/cinema_model.dart';
import 'package:app_sweet_cine/repositories/database_repository.dart';
import 'package:flutter/material.dart';

class CinemaRepository with ChangeNotifier{
  List<CinemaModel> _cinemas = [];
  List<CinemaModel> get cinemas => _cinemas;

  CinemaModel _cinema = CinemaModel.completoVazio();
  // ignore: unnecessary_getters_setters
  CinemaModel get cinema => _cinema;
  set cinema(CinemaModel cinema) => _cinema = cinema;

  CinemaModel _cineMaisFrequentado = CinemaModel.maisFrequentado("", 0, 0);
  CinemaModel get cineMaisFrequentado => _cineMaisFrequentado;

  // OBTER TODOS OS CINEMAS CADASTRADOS
  Future<void> obterDados() async {
    List<CinemaModel> cinemas = [];
    var db = await DatabaseRepository().obterDatabase();
    var result = await db.rawQuery(
      'SELECT c.id, c.nome, COALESCE(NULLIF(c.bairro, ""), "Bairro desconhecido") AS bairro, COALESCE(NULLIF(c.cidade, ""), "Cidade desconhecida") AS cidade, c.estado, c.foto_do_cinema, c.nota, c.comentario, COALESCE(COUNT(f.id_cinema), 0) AS filmes_assistidos, COALESCE(SUM(f.ingresso), 0) as total_de_ingressos FROM cinema c LEFT JOIN filme f ON c.id = f.id_cinema GROUP BY c.id;'
    );
    for (var element in result){
      cinemas.add(
        CinemaModel.completo(
          int.parse(element['id'].toString()), 
          element['nome'].toString(), 
          element['bairro'].toString(), 
          element['cidade'].toString(), 
          element['estado'].toString(), 
          element['foto_do_cinema'].toString(), 
          int.parse(element['nota'].toString()), 
          element['comentario'].toString(),
          int.parse(element['filmes_assistidos'].toString()),
          double.parse(element['total_de_ingressos'].toString())
        )
      );
    }
    _cinemas = cinemas;
    notifyListeners();
  }

  // OBTER CINEMA PELO ID
  Future<void> obterDadosPeloId(int id) async{
    var db = await DatabaseRepository().obterDatabase();
    var result = await db.rawQuery(
      "SELECT c.id, c.nome, c.bairro, c.cidade, c.estado, c.foto_do_cinema, c.nota, c.comentario, COALESCE(COUNT(f.id_cinema), 0) AS filmes_assistidos, COALESCE(SUM(f.ingresso), 0) as total_de_ingressos FROM cinema c LEFT JOIN filme f ON c.id = f.id_cinema WHERE c.id = ?", [id]
    );

    if(result.isNotEmpty){
      _cinema = CinemaModel.completo(
        int.parse(result.first['id'].toString()), 
        result.first['nome'].toString(), 
        result.first['bairro'].toString(), 
        result.first['cidade'].toString(), 
        result.first['estado'].toString(), 
        result.first['foto_do_cinema'].toString(), 
        int.parse(result.first['nota'].toString()), 
        result.first['comentario'].toString(), 
        int.parse(result.first['filmes_assistidos'].toString()), 
        double.parse(result.first['total_de_ingressos'].toString())
      );
    } else{
      _cinema = CinemaModel.completoVazio();
    }
    notifyListeners();
  }

  // OBTER O CINEMA MAIS FREQUENTADO
  Future<void> cinemaMaisFrequentado() async {
    var db = await DatabaseRepository().obterDatabase();
    var result = await db.rawQuery("SELECT c.nome, f.id_cinema, COUNT(f.id_cinema) AS filmes_assistidos FROM filme f INNER JOIN cinema c ON c.id = f.id_cinema GROUP BY f.id_cinema ORDER BY filmes_assistidos DESC LIMIT 1");

    if(result.isNotEmpty){
      _cineMaisFrequentado = CinemaModel.maisFrequentado(
        result.first['nome'].toString(), 
        int.parse(result.first['id_cinema'].toString()), 
        int.parse(result.first['filmes_assistidos'].toString())
      );
    } else{
      _cineMaisFrequentado = CinemaModel.maisFrequentado("", 0, 0);
    }
    notifyListeners();
  }

  // SALVAR CINEMAS
  Future<void> salvar(CinemaModel cinemaModel) async{
    var db = await DatabaseRepository().obterDatabase();
    await db.rawInsert(
      'INSERT INTO cinema (nome, bairro, cidade, estado, foto_do_cinema, nota, comentario) VALUES (?, ?, ?, ?, ?, ?, ?)', 
      [
        cinemaModel.nome, 
        cinemaModel.bairro, 
        cinemaModel.cidade, 
        cinemaModel.estado, 
        cinemaModel.fotoDoCinema, 
        cinemaModel.nota, 
        cinemaModel.comentario
      ]
    );
  }

  // ATUALIZAR CINEMAS
  Future<void> atualizar(CinemaModel cinemaModel) async{
    var db = await DatabaseRepository().obterDatabase();
    await db.rawInsert(
      'UPDATE cinema SET nome = ?, bairro = ?, cidade = ?, estado = ?, foto_do_cinema = ?, nota = ?, comentario = ? WHERE id = ?', 
      [
        cinemaModel.nome, 
        cinemaModel.bairro, 
        cinemaModel.cidade, 
        cinemaModel.estado, 
        cinemaModel.fotoDoCinema, 
        cinemaModel.nota, 
        cinemaModel.comentario, 
        cinemaModel.id
      ]
    );
  }

  // REMOVER CINEMAS
  Future<void> remover(int id) async{
    var db = await DatabaseRepository().obterDatabase();
    await db.rawInsert(
      'DELETE FROM cinema WHERE id = ?', [id]
    );
  }

  // REMOVER TODOS OS CINEMAS
  Future<void> removerTodosOsCinema() async {
    var db = await DatabaseRepository().obterDatabase();
    await db.rawInsert("DELETE FROM cinema");
  }

}