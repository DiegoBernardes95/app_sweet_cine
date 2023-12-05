import 'package:app_sweet_cine/model/filme_model.dart';
import 'package:app_sweet_cine/repositories/database_repository.dart';
import 'package:flutter/widgets.dart';

class FilmeRepository with ChangeNotifier{
  // LISTAR TODOS OS FILMES
  List<FilmeModel> _filmes = [];
  List<FilmeModel> get filmes => _filmes;

  // LISTAR FILME PELO ID
  FilmeModel _filmePeloId = FilmeModel.completoVazio();
  // ignore: unnecessary_getters_setters
  FilmeModel get filmePeloId => _filmePeloId;
  set filmePeloId(FilmeModel filmePeloId) => _filmePeloId = filmePeloId;

  // LISTAR ULTIMO FILME ASSISTIDO
  FilmeModel _ultimoFilme = FilmeModel.completoVazio();
  // ignore: unnecessary_getters_setters
  FilmeModel get ultimoFilme => _ultimoFilme;
  set ultimoFilme(FilmeModel ultimoFilme) => _ultimoFilme = ultimoFilme;

  // GÊNERO MAIS ASSISTIDO
  FilmeModel _generoMaisAssistido = FilmeModel.generoMaisAssistido("", 0);
  FilmeModel get generoMaisAssistido => _generoMaisAssistido;

  // TOTAL DOS INGRESSOS
  FilmeModel _totalIngressos = FilmeModel.totalIngressos(0.0);
  FilmeModel get totalIngressos => _totalIngressos;

  // TOTAL DOS FILMES
  // ignore: prefer_final_fields
  FilmeModel _totalFilmes = FilmeModel.vazio();
  FilmeModel get totalFilmes => _totalFilmes;

  // LISTAR FILMES POR GÊNERO
  List<FilmeModel> _totalFilmesPorGenero = [];
  List<FilmeModel> get totalFilmesPorGenero => _totalFilmesPorGenero;

  // LISTAR GÊNEROS
  List<FilmeModel> _generos = [];
  List<FilmeModel> get generos => _generos;

  // LISTAR FILMES POR CINEMA
  List<FilmeModel> _filmesPorCinema = [];
  List<FilmeModel> get filmesPorCinema => _filmesPorCinema;

  // LISTAR FILMES POR NOTA
  List<FilmeModel> _filmesPorNota = [];
  List<FilmeModel> get filmePorNota => _filmesPorNota;


  // LISTAR TODOS OS FILMES ASSISTIDOS
  Future<void> obterListaDeFilmes() async{
    List<FilmeModel> filmes = [];
    var db = await DatabaseRepository().obterDatabase();
    var result = await db.rawQuery(
      'SELECT f.id, f.id_cinema, COALESCE(c.nome, "Nenhum cinema cadastrado") AS cinema_assistido, f.titulo, f.genero, COALESCE(NULLIF(f.data, ""), "Data desconhecida") AS data, f.ingresso, f.comentario, f.sinopse, COALESCE(f.nota, 0) AS nota, f.poster, f.capa FROM filme f LEFT JOIN cinema c ON c.id = f.id_cinema ORDER BY f.data'
    );

    for (var element in result) {
      filmes.add(
        FilmeModel.completo(
          int.parse(element['id'].toString()), 
          int.parse(element['id_cinema'].toString()), 
          element['cinema_assistido'].toString(),
          element['poster'].toString(), 
          element['capa'].toString(), 
          element['titulo'].toString(), 
          element['genero'].toString(), 
          element['data'].toString(), 
          double.parse(element['ingresso'].toString()), 
          element['sinopse'].toString(), 
          element['comentario'].toString(), 
          int.parse(element['nota'].toString())
        )
      );
    }
    _filmes = filmes;
    notifyListeners();
  }

  // LISTAR UM FILME PELO ID
  Future<void> obterDadosPeloId(int id) async {
    var db = await DatabaseRepository().obterDatabase();
    var result = await db.rawQuery(
      'SELECT f.id, f.id_cinema, COALESCE(c.nome, "Nenhum cinema cadastrado") AS cinema_assistido, f.titulo, f.genero, f.data, f.ingresso, f.comentario, f.sinopse, f.nota, f.poster, f.capa FROM filme f LEFT JOIN cinema c ON c.id = f.id_cinema WHERE f.id = ?', [id]
    );
    _filmePeloId = FilmeModel.completo(
      int.parse(result.first['id'].toString()), 
      int.parse(result.first['id_cinema'].toString()), 
      result.first['cinema_assistido'].toString(),
      result.first['poster'].toString(), 
      result.first['capa'].toString(), 
      result.first['titulo'].toString(), 
      result.first['genero'].toString(), 
      result.first['data'].toString(), 
      double.parse(result.first['ingresso'].toString()), 
      result.first['sinopse'].toString(), 
      result.first['comentario'].toString(), 
      int.parse(result.first['nota'].toString())
    );
    notifyListeners();
  }

  // LISTAR ÚLTIMO FILME ASSISTIDO
  Future<void> obterUltimoFilme() async {
    var db = await DatabaseRepository().obterDatabase();
    var result = await db.rawQuery(
      'SELECT f.id, COALESCE(NULLIF(f.id_cinema, ""), 0) as id_cinema, COALESCE(c.nome, "Nenhum cinema cadastrado") AS cinema_assistido, COALESCE(NULLIF(c.foto_do_cinema, ""), "") AS foto_do_cinema, f.titulo, f.genero, f.data, f.ingresso, f.comentario, f.sinopse, f.nota, f.capa FROM filme f LEFT JOIN cinema c ON c.id = f.id_cinema ORDER BY f.data DESC LIMIT 1'
    );

    // Verifica se a lista result não está vazia
    if (result.isNotEmpty) {
      _ultimoFilme = FilmeModel.completo(
        int.parse(result.first['id'].toString()), 
        int.parse(result.first['id_cinema'].toString()), 
        result.first['cinema_assistido'].toString(),
        result.first['foto_do_cinema'].toString(), 
        result.first['capa'].toString(), 
        result.first['titulo'].toString(), 
        result.first['genero'].toString(), 
        result.first['data'].toString(), 
        double.parse(result.first['ingresso'].toString()), 
        result.first['sinopse'].toString(), 
        result.first['comentario'].toString(), 
        int.parse(result.first['nota'].toString())
      );
    } else {
      // Lida com o caso em que a lista result está vazia, talvez definindo _ultimoFilme como nulo ou realizando outra ação apropriada.
      _ultimoFilme = FilmeModel.completoVazio();
    }
    notifyListeners();
  }

  // GÊNERO MAIS ASSISTIDO

  Future<void> obterGeneroMaisAssistido() async {
    var db = await DatabaseRepository().obterDatabase();
    var result = await db.rawQuery(
      'SELECT genero, COUNT(genero) AS contadorGenero FROM filme GROUP BY genero ORDER BY contadorGenero DESC LIMIT 1'
    );

    if(result.isNotEmpty){
      _generoMaisAssistido = FilmeModel.generoMaisAssistido(
        result.first['genero'].toString(), 
        int.parse(result.first['contadorGenero'].toString())
      );
    } else{
      _generoMaisAssistido = FilmeModel.generoMaisAssistido("", 0);
    }
    
    notifyListeners();
  }


  // VALOR TOTAL DOS INGRESSOS

  Future<void> valorTotalIngressos() async {
    var db = await DatabaseRepository().obterDatabase();
    var result = await db.rawQuery(
      'SELECT COALESCE(SUM(ingresso), 0.0) AS total_ingresso FROM filme'
    );

    if(result.isNotEmpty){
      _totalIngressos = FilmeModel.totalIngressos(
        double.parse(result.first['total_ingresso'].toString())
      );
    } else{
      _totalIngressos = FilmeModel.totalIngressos(0.0);
    }
   
    notifyListeners();
  }

  // LISTAR FILMES POR NOTA

   Future<void> obterFilmesPorNota() async{
    List<FilmeModel> filmesPorNota = [];
    var db = await DatabaseRepository().obterDatabase();
    var result = await db.rawQuery(
      'SELECT f.id, f.id_cinema, COALESCE(c.nome, "Nenhum cinema cadastrado") AS cinema_assistido, f.titulo, f.genero, f.data, f.ingresso, f.comentario, f.sinopse, f.nota, f.poster, f.capa FROM filme f LEFT JOIN cinema c ON c.id = f.id_cinema ORDER BY f.nota DESC LIMIT 10'
    );
    for (var element in result) {
      filmesPorNota.add(
        FilmeModel.completo(
          int.parse(element['id'].toString()), 
          int.parse(element['id_cinema'].toString()), 
          element['cinema_assistido'].toString(),
          element['poster'].toString(), 
          element['capa'].toString(), 
          element['titulo'].toString(), 
          element['genero'].toString(), 
          element['data'].toString(), 
          double.parse(element['ingresso'].toString()), 
          element['sinopse'].toString(), 
          element['comentario'].toString(), 
          int.parse(element['nota'].toString())
        )
      );
    }
    _filmesPorNota = filmesPorNota;
    notifyListeners();
  }

  // LISTAR FILMES POR GÊNERO

  Future<void> obterFilmePorGenero(String genero) async{
    List<FilmeModel> totalPorGenero = [];
    var db = await DatabaseRepository().obterDatabase();
    var result = await db.rawQuery(
      'SELECT f.id, f.id_cinema, COALESCE(c.nome, "Nenhum cinema cadastrado") AS cinema_assistido, f.titulo, f.genero, f.data, f.ingresso, f.comentario, f.sinopse, f.nota, f.poster, f.capa FROM filme f LEFT JOIN cinema c ON c.id = f.id_cinema WHERE f.genero = ? ORDER BY f.data DESC', [genero]
    );
    for (var element in result) {
      totalPorGenero.add(
        FilmeModel.completo(
          int.parse(element['id'].toString()), 
          int.parse(element['id_cinema'].toString()), 
          element['cinema_assistido'].toString(),
          element['poster'].toString(), 
          element['capa'].toString(), 
          element['titulo'].toString(), 
          element['genero'].toString(), 
          element['data'].toString(), 
          double.parse(element['ingresso'].toString()), 
          element['sinopse'].toString(), 
          element['comentario'].toString(), 
          int.parse(element['nota'].toString())
        )
      );
    }
    _totalFilmesPorGenero = totalPorGenero;
    notifyListeners();
  }

  // TOTAL DE FILMES EM CADA GÊNERO

  Future<void> obterGeneros() async{
    List<FilmeModel> filmesPorGenero = [];
    var db = await DatabaseRepository().obterDatabase();
    var result = await db.rawQuery(
      'SELECT f.genero, COUNT(f.genero) AS qtd_de_filmes, f.titulo, f.poster FROM filme f JOIN ( SELECT genero, MAX(data) AS max_data_view FROM filme GROUP BY genero ) t ON f.genero = t.genero AND f.data = t.max_data_view GROUP BY f.genero, f.titulo, f.poster ORDER BY max_data_view DESC'
    );
    for (var element in result) {
      filmesPorGenero.add(
        FilmeModel.mostrarGeneros(
          element['genero'].toString(),
          element['titulo'].toString(), 
          element['poster'].toString(),
          int.parse(element['qtd_de_filmes'].toString())
        )
      );
    }
    _generos = filmesPorGenero;
    notifyListeners();
  }

  // LISTAR FILMES POR CINEMA

  Future<void> obterFilmesPorCinema(int idCinema) async {
    var db = await DatabaseRepository().obterDatabase();
    var result = await db.rawQuery(
      'SELECT f.id, f.id_cinema, c.nome, f.poster, f.capa, f.titulo, f.genero, f.data, f.ingresso, f.comentario, f.sinopse, f.nota FROM filme f INNER JOIN cinema c on f.id_cinema = c.id WHERE f.id_cinema = ? ORDER BY f.data DESC', [idCinema]
    );

    if (result.isNotEmpty) {
      List<FilmeModel> filmesPorCinema = result.map((row) => FilmeModel.completo(
        int.parse(row['id'].toString()), 
        int.parse(row['id_cinema'].toString()), 
        row['cinema_assistido'].toString(),
        row['poster'].toString(), 
        row['capa'].toString(), 
        row['titulo'].toString(), 
        row['genero'].toString(), 
        row['data'].toString(), 
        double.parse(row['ingresso'].toString()), 
        row['sinopse'].toString(), 
        row['comentario'].toString(), 
        int.parse(row['nota'].toString())
      )).toList();

      _filmesPorCinema = filmesPorCinema;
      notifyListeners();
    } else {
      // Lida com o caso de consulta sem resultados, por exemplo, limpando a lista existente.
      _filmesPorCinema.clear();
      notifyListeners();
    }
  }


  // SALVAR UM FILME
  Future<void> salvar(FilmeModel filmeModel) async{
    var db = await DatabaseRepository().obterDatabase();
    await db.rawInsert(
      'INSERT INTO filme (id_cinema, poster, capa, titulo, genero, data, ingresso, sinopse, comentario, nota) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', 
      [
        filmeModel.idCinema, 
        filmeModel.poster, 
        filmeModel.capa, 
        filmeModel.titulo,
        filmeModel.genero,
        filmeModel.data,
        filmeModel.ingresso,
        filmeModel.sinopse,
        filmeModel.comentario,
        filmeModel.nota
      ]
    );
  }

  // ATUALIZAR AS INFORMAÇÕES DO FILME
  Future<void> atualizar(FilmeModel filmeModel) async{
    var db = await DatabaseRepository().obterDatabase();
    db.rawInsert(
      'UPDATE filme SET id_cinema = ?, poster = ?, capa = ?, titulo = ?, genero = ?, data = ?, ingresso = ?, sinopse = ?, comentario = ?, nota = ? WHERE id = ?', 
      [
        filmeModel.idCinema, 
        filmeModel.poster, 
        filmeModel.capa, 
        filmeModel.titulo,
        filmeModel.genero,
        filmeModel.data,
        filmeModel.ingresso,
        filmeModel.sinopse,
        filmeModel.comentario,
        filmeModel.nota,
        filmeModel.id
      ]
    );
  }

  // DELETAR UM FILME
  Future<void> remover(int id) async{
    var db = await DatabaseRepository().obterDatabase();
    db.rawInsert(
      'DELETE FROM filme WHERE id = ?', [id]
    );
  }

  // DELETAR TODOS OS FILMES
  Future<void> removerTodosOsFilmes() async{
    var db = await DatabaseRepository().obterDatabase();
    await db.rawInsert("DELETE FROM filme");
  }
}