// ignore_for_file: unnecessary_getters_setters, duplicate_ignore

// ignore: duplicate_ignore
class FilmeModel{
  int _id = 0;
  int _idCinema = 0;
  String _urlImage1 = "";
  String _urlImage2 = "";
  String _titulo = "";
  String _genero = "";
  String _data = "";
  double _ingresso = 0.0;
  String _sinopse = "";
  String _comentario = "";
  int _nota = 0;
  String _cinemaAssistido = "";
  int _contador = 0;

  FilmeModel(this._id, this._idCinema, this._urlImage1, this._urlImage2, this._titulo, this._genero, this._data, this._ingresso, this._sinopse, this._comentario, this._nota);

  FilmeModel.salvar(this._idCinema, this._urlImage1, this._urlImage2, this._titulo, this._genero, this._data, this._ingresso, this._sinopse, this._comentario, this._nota);

  FilmeModel.completo(this._id, this._idCinema, this._cinemaAssistido, this._urlImage1, this._urlImage2, this._titulo, this._genero, this._data, this._ingresso, this._sinopse, this._comentario, this._nota);

  FilmeModel.vazio(){
    _idCinema = 0;
    _urlImage1 = "";
    _urlImage2 = "";
    _titulo = "";
    _genero = "Escrever";
    _data = "";
    _ingresso = 0.0;
    _sinopse = "";
    _comentario = "";
    _nota = 0;
  }

  FilmeModel.completoVazio(){
    _id = 0;
    _idCinema = 0;
    _urlImage1 = "";
    _urlImage2 = "";
    _titulo = "";
    _genero = "";
    _data = "";
    _ingresso = 0.0;
    _sinopse = "";
    _comentario = "";
    _nota = 0;
    _cinemaAssistido = "";
  }

  FilmeModel.generoMaisAssistido(this._genero, this._contador);

  FilmeModel.totalIngressos(this._ingresso);

  FilmeModel.mostrarGeneros(this._genero, this._titulo, this._urlImage1, this._contador);

  int get id => _id;
  int get idCinema => _idCinema;

  // ignore: unnecessary_getters_setters
  String get poster => _urlImage1;
  set poster(String poster) => _urlImage1 = poster;

  String get capa => _urlImage2;
  set capa(String capa) => _urlImage2 = capa;

  String get titulo => _titulo;
  set titulo(String titulo) => _titulo = titulo;

  String get genero => _genero;
  set genero(String genero) => _genero = genero;

  String get data => _data;
  set data(String data) => _data = data;

  double get ingresso => _ingresso;
  set ingresso(double ingresso) => _ingresso = ingresso;

  String get sinopse => _sinopse;
  set sinopse(String sinopse) => _sinopse = sinopse;

  String get comentario => _comentario;
  set comentario(String comentario) => _comentario = comentario;

  int get nota => _nota;
  set nota(int nota) => _nota = nota;

  int get contadorGenero => _contador;
  set contadorGenero(int contadorGenero) => _contador = contadorGenero;

  String get cinemaAssistido => _cinemaAssistido;
  set cinemaAssistido(String cinemaAssistido) => _cinemaAssistido = cinemaAssistido;

}