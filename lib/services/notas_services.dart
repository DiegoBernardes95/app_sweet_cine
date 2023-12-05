class NotasServices{
  int nota = 0;
  String descricao = "";

  NotasServices(this.nota, this.descricao);

  static List<NotasServices> obterNotas(){
    final List<NotasServices> notas = [
      NotasServices(0, "Notas"),
      NotasServices(1, "1 - Péssimo"),
      NotasServices(2, "2 - Razoável"),
      NotasServices(3, "3 - Bom"),
      NotasServices(4, "4 - Muito Bom"),
      NotasServices(5, "5 - Ótimo"),
      NotasServices(6, "6 - Espetacular"),
      NotasServices(7, "7 - Perfeito")
    ];
    return notas;
  }
}