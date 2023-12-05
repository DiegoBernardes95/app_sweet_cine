class CinemaModel{
  int _id = 0;
  String _nome = "";
  String _bairro = "";
  String _cidade = "";
  String _estado = "";
  String _fotoDoCinema = "";
  int _nota = 0;
  String _comentario = "";
  int _filmesAssistidos = 0;
  double _totalDeIngressos = 0.0;

  CinemaModel(this._id, this._nome, this._bairro, this._cidade, this._estado, this._fotoDoCinema, this._nota, this._comentario);

  CinemaModel.vazio(){
    _nome = "";
    _bairro = "";
    _cidade = "";
    _estado = "";
    _fotoDoCinema = "";
    _nota = 0;
    _comentario = "";
  }

  CinemaModel.completo(this._id, this._nome, this._bairro, this._cidade, this._estado, this._fotoDoCinema, this._nota, this._comentario, this._filmesAssistidos, this._totalDeIngressos);

  CinemaModel.completoVazio(){
    _id = 0;
    _nome = "";
    _bairro = "";
    _cidade = "";
    _estado = "";
    _fotoDoCinema = "";
    _nota = 0;
    _comentario = "";
    _filmesAssistidos = 0;
    _totalDeIngressos = 0;
  }

  CinemaModel.maisFrequentado(this._nome, this._id, this._filmesAssistidos);

  int get id => _id;

  // ignore: unnecessary_getters_setters
  String get nome => _nome;
  set nome(String nome) => _nome = nome;

  // ignore: unnecessary_getters_setters
  String get bairro => _bairro;
  set bairro(String bairro) => _bairro = bairro;

  // ignore: unnecessary_getters_setters
  String get cidade => _cidade;
  set cidade(String cidade) => _cidade = cidade;

  // ignore: unnecessary_getters_setters
  String get estado => _estado;
  set estado(String estado) => _estado = estado;

  // ignore: unnecessary_getters_setters
  String get fotoDoCinema => _fotoDoCinema;
  set fotoDoCinema(String fotoDoCinema) => _fotoDoCinema = fotoDoCinema;

  // ignore: unnecessary_getters_setters
  int get nota => _nota;
  set nota(int nota) => _nota = nota;

  // ignore: unnecessary_getters_setters
  String get comentario => _comentario;
  set comentario(String comentario) => _comentario = comentario;

  // ignore: unnecessary_getters_setters
  int get filmesAssistidos => _filmesAssistidos;
  set filmesAssistidos(int filmesAssistidos) => _filmesAssistidos = filmesAssistidos;

  // ignore: unnecessary_getters_setters
  double get totalDeIngressos => _totalDeIngressos;
  set totalDeIngressos(double totalDeIngressos) => _totalDeIngressos = totalDeIngressos;

}