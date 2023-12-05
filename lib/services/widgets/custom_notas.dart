import 'package:app_sweet_cine/services/notas_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomNotas extends StatefulWidget {
  int notaController;
  Function (int) updateValues;

  CustomNotas({super.key, required this.notaController, required this.updateValues});

  @override
  State<CustomNotas> createState() => _CustomNotasState();
}

class _CustomNotasState extends State<CustomNotas> {
  var notas = NotasServices.obterNotas();

  @override
  void initState() {
    widget.notaController = notas[0].nota;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton <int>(
      value: widget.notaController,
      isExpanded: true,
      dropdownColor: const Color.fromARGB(255, 8, 16, 20),
      iconEnabledColor: Colors.red,
      itemHeight: 80,
      menuMaxHeight: 500,
      onChanged: (value){
        setState(() {
          widget.notaController = value!;
          widget.updateValues(widget.notaController);
        });
      },
      items: notas.map((nota) => 
        DropdownMenuItem<int>(
          value: nota.nota,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(124, 244, 67, 54),
              ),
                width: 45,
                height: 45,
                child: const Icon(Icons.star_border, color: Colors.white)
              ),
              const SizedBox(width: 15),
              Text(nota.descricao, style: GoogleFonts.montserrat(color: Colors.white)),
            ],
          ), 
        )
      ).toList()
    );
  }
}