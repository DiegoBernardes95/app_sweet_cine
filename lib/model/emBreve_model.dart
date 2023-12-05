// ignore: file_names
class EmBreveModel{
  int _id = 0;
  String _titulo = "";
  String _poster = "";
  String _capa = "";
  String _sinopse = "";
  bool _assistido = false;
  String _dataLancamento = "";

  EmBreveModel(this._titulo, this._poster, this._capa, this._sinopse, this._assistido, this._dataLancamento);

  EmBreveModel.completo(this._id, this._titulo, this._poster, this._capa, this._sinopse, this._assistido, this._dataLancamento);

  EmBreveModel.completoVazio(){
    _id = 0;
    _titulo = "";
    _poster = "";
    _capa = "";
    _sinopse = "";
    _assistido = false;
    _dataLancamento = "";
  }

  int get id => _id;

  // ignore: unnecessary_getters_setters
  String get titulo => _titulo;
  set titulo(String titulo) => _titulo = titulo;

  // ignore: unnecessary_getters_setters
  String get poster => _poster;
  set poster(String poster) => _poster = poster;

  // ignore: unnecessary_getters_setters
  String get capa => _capa;
  set capa(String capa) => _capa = capa;

  // ignore: unnecessary_getters_setters
  String get dataLancamento => _dataLancamento;
  set dataLancamento(String dataLancamento) => _dataLancamento = dataLancamento;

  // ignore: unnecessary_getters_setters
  String get sinopse => _sinopse;
  set sinopse(String sinopse) => _sinopse = sinopse;

  // ignore: unnecessary_getters_setters
  bool get assistido => _assistido;
  set assistido(bool assistido) => _assistido = assistido;

}