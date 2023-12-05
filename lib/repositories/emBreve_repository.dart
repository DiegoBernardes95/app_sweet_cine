import 'package:app_sweet_cine/model/emBreve_model.dart';
import 'package:app_sweet_cine/repositories/database_repository.dart';
import 'package:flutter/material.dart';

class EmBreveRepository with ChangeNotifier{

  List<EmBreveModel> _filmesEmBreve = [];
  List<EmBreveModel> get filmesEmBreve => _filmesEmBreve;

  EmBreveModel _filmeEmBrevePorId = EmBreveModel.completoVazio();
  EmBreveModel get filmeEmBrevePorId => _filmeEmBrevePorId;

  EmBreveModel _proximoFilme = EmBreveModel.completoVazio();
  EmBreveModel get proximoFilme => _proximoFilme;


  // LISTAR TODOS OS FILMES
  Future<void> listarFilmes() async {
    List<EmBreveModel> filmesEmBreve = [];
    var db = await DatabaseRepository().obterDatabase();
    var result = await db.rawQuery("SELECT id, titulo, poster, capa, sinopse, assistido, data_lancamento FROM emBreve ORDER BY data_lancamento ASC");

    for (var element in result){
      filmesEmBreve.add(
        EmBreveModel.completo(
          int.parse(element["id"].toString()),
          element["titulo"].toString(), 
          element["poster"].toString(), 
          element["capa"].toString(),
          element['sinopse'].toString(), 
          element['assistido'] == 1,
          element["data_lancamento"].toString()
        )
      );
    }

    _filmesEmBreve = filmesEmBreve;
    notifyListeners();
  }

  // LISTAR FILME POR ID
  Future<void> listarFilmePorId(int id) async {
    var db = await DatabaseRepository().obterDatabase();
    var result = await db.rawQuery("SELECT id, titulo, poster, capa, sinopse, assistido, data_lancamento FROM emBreve WHERE id = ?", [id]);

    if(result.isNotEmpty){
      _filmeEmBrevePorId = EmBreveModel.completo(
        int.parse(result.first["id"].toString()),
        result.first['titulo'].toString(), 
        result.first['poster'].toString(), 
        result.first['capa'].toString(), 
        result.first['sinopse'].toString(),
        result.first['assistido'] == 1,
        result.first['data_lancamento'].toString()
      );
    } else {
      _filmeEmBrevePorId = EmBreveModel.completoVazio();
    }

    notifyListeners();
  }

  Future<void> obterProximoFilme() async {
    var db = await DatabaseRepository().obterDatabase();
    var result = await db.rawQuery("SELECT id, titulo, poster, capa, sinopse, assistido, data_lancamento FROM emBreve WHERE data_lancamento > CURRENT_DATE AND assistido = 0 ORDER BY data_lancamento ASC LIMIT 1");
    if(result.isNotEmpty){
      _proximoFilme = EmBreveModel.completo(
        int.parse(result.first['id'].toString()), 
        result.first['titulo'].toString(), 
        result.first['poster'].toString(), 
        result.first['capa'].toString(), 
        result.first['sinopse'].toString(), 
        result.first['assistido'] == 1, 
        result.first['data_lancamento'].toString()
      );
    } else{
      _proximoFilme = EmBreveModel.completoVazio();
    }

    notifyListeners();
  }

  // SALVAR UM FILME
  Future<void> salvar(EmBreveModel filmeEmBreve) async {
    var db = await DatabaseRepository().obterDatabase();
    await db.rawInsert("INSERT INTO emBreve (titulo, poster, capa, sinopse, assistido, data_lancamento) VALUES (?, ?, ?, ?, ?, ?)", [
      filmeEmBreve.titulo,
      filmeEmBreve.poster,
      filmeEmBreve.capa,
      filmeEmBreve.sinopse,
      filmeEmBreve.assistido,
      filmeEmBreve.dataLancamento
    ]);
  }

  // ATUALIZAR UM FILME
  Future<void> atualizar(EmBreveModel filme) async{
    var db = await DatabaseRepository().obterDatabase();
    await db.rawInsert("UPDATE emBreve SET titulo = ?, poster = ?, capa = ?, sinopse = ?, assistido = ?, data_lancamento = ? WHERE id = ?", [
      filme.titulo,
      filme.poster,
      filme.capa,
      filme.sinopse,
      filme.assistido,
      filme.dataLancamento,
      filme.id
    ]);
  }

  // REMOVER UM FILME
  Future<void> remover(int id) async{
    var db = await DatabaseRepository().obterDatabase();
    await db.rawInsert("DELETE FROM emBreve WHERE id = ?", [id]);
  }

  Future<void> removerAssistidos() async {
    var db = await DatabaseRepository().obterDatabase();
    await db.rawInsert("DELETE FROM emBreve WHERE assistido = ?", [1]);
  }

}