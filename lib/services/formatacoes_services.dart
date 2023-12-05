import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormatacoesService{
  // FORMATAÇÃO DE DATATIME PARA STRING
  static String dataFormatada(String data){
    DateTime? dataFilme;
    String resultado = "";
    int dia;
    int mes;
    int ano;
    String mesFormatado;

    try {
      dataFilme = DateTime.parse(data);
      dia = dataFilme.day;
      mes = dataFilme.month;
      ano = dataFilme.year;
      mesFormatado = "";

      switch(mes){
        case 1:
          mesFormatado = "janeiro";
          break;
        case 2:
          mesFormatado = "fevereiro";
          break;
        case 3:
          mesFormatado = "março";
          break;
        case 4:
          mesFormatado = "abril";
          break;
        case 5:
          mesFormatado = "maio";
          break;
        case 6:
          mesFormatado = "junho";
          break;
        case 7:
          mesFormatado = "julho";
          break;
        case 8:
          mesFormatado = "agosto";
          break;
        case 9:
          mesFormatado = "setembro";
          break;
        case 10:
          mesFormatado = "outubro";
          break;
        case 11:
          mesFormatado = "novembro";
          break;
        case 12:
          mesFormatado = "dezembro";
          break;
      }
      
      resultado = "$dia de $mesFormatado de $ano";

    } catch (e) {
      dataFilme = DateTime.now();
      resultado = "";
    }

    return resultado;
  }

  // COMPARAÇÃO DE DATAS
  static int compararDatas(String data){
    DateTime dataAtual = DateTime.now();
    DateTime dataSelecionada = DateTime.parse(data);

    int resultado = dataSelecionada.compareTo(dataAtual);

    return resultado;
  }


  // INFORMA QUANTO TEMPO FAZ
  static String tempoDiferenca(String data) {
    DateTime dataUltimo = DateTime.parse(data);
    Duration diferenca = DateTime.now().difference(dataUltimo);

    if (diferenca.inDays >= 365) {
      int anos = (diferenca.inDays / 365).floor();
      return anos == 1 ? '1 ano' : '$anos anos';
    } else if (diferenca.inDays >= 30) {
      int meses = (diferenca.inDays / 30).floor();
      return meses == 1 ? '1 mês' : '$meses meses';
    } else if (diferenca.inDays >= 7) {
      int semanas = (diferenca.inDays / 7).floor();
      return semanas == 1 ? '1 semana' : '$semanas semanas';
    } else if (diferenca.inDays > 0) {
      return diferenca.inDays == 1 ? '1 dia' : '${diferenca.inDays} dias';
    } else {
      return 'hoje';
    }
  }


  // FORMATAÇÃO DE MASCARA PARA DOUBLE
  static double formatarParaDouble(String valor){
    valor = valor.replaceAll("R\$", "").replaceAll(".", "").replaceAll(",", "."); // substituição dos simbolos

    var toDouble =  double.parse(valor);
    return toDouble;
  }

  // VERIFICACÃO DE URL DE IMAGENS
  static bool urlValido(String url){
    final regex = RegExp(
      r'^(?:http|https):\/\/' // Verifica se a URL começa com http:// ou https://
      r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|' // Verifica o domínio
      r'localhost|' // Permite localhost
      r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' // Permite endereços IP (v4)
      r'(?::\d+)?' // Permite a porta
      r'(?:/?|[/?]\S+)$', // Permite caminhos e query strings opcionais
      caseSensitive: false, // Torna a verificação de maiúsculas/minúsculas insensível
    );
    
    return regex.hasMatch(url);
  }
}

// COMPARAR DATA E RETORNAR A COR ESPECÍFICA
Color compararDatas(String data, assistido){
  Color cor;
  if(FormatacoesService.compararDatas(data) < 0){
    cor = assistido ? Colors.white : Colors.red;
  } else if(FormatacoesService.compararDatas(data) > 0){
    cor = assistido ? Colors.white : Colors.green;
  } else{
    cor = assistido ? Colors.white : Colors.blueAccent;
  }
  return cor;
}

// FORMATAÇÃO PARA EXIBIR AS ESTRELAS DA NOTA

// ignore: must_be_immutable
class ListEstrelas extends StatelessWidget{
  int quantidade;
  double tamanhoIcon;
  ListEstrelas({super.key, required this.quantidade, required this.tamanhoIcon});

  List<Icon> obterEstrelas(int quantidade){
    List<Icon> estrelas = <Icon>[];
    for(var i = 0; i < quantidade; i++){
      estrelas.add(
        Icon(Icons.star, color: Colors.amber, size: tamanhoIcon)
      );
    }
    return estrelas;
  }

  @override
  Widget build(BuildContext context){
    return quantidade == 0 ?
    Text("Nota indisponível", style: GoogleFonts.cutiveMono(color: Colors.white), overflow: TextOverflow.ellipsis)

    :

    Row(
      mainAxisSize: MainAxisSize.min,
      children: obterEstrelas(quantidade),
    );
  }
}