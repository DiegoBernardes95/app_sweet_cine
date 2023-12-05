import 'package:app_sweet_cine/services/estados_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomEstados extends StatefulWidget {
  String estado;
  Function (String) updateEstado;
  CustomEstados({super.key, required this.estado, required this.updateEstado});

  @override
  State<CustomEstados> createState() => _CustomEstadosState();
}

class _CustomEstadosState extends State<CustomEstados> {
  var estados = EstadosServices.obterEstados();

  @override
  void initState() {
    widget.estado = estados[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.estado,
      isExpanded: true,
      dropdownColor: const Color.fromARGB(255, 8, 16, 20),
      menuMaxHeight: 500,
      itemHeight: 80,
      iconEnabledColor: Colors.red,
      items: estados.map((String item) => 
        DropdownMenuItem<String>(
          value: item,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(124, 244, 67, 54),
              ),
                width: 45,
                height: 45,
                child: const Icon(Icons.map, color: Colors.white)
              ),
              const SizedBox(width: 15),
              Text(item, style: GoogleFonts.montserrat(color: Colors.white)),
            ],
          ),
        )
      ).toList(),
      onChanged: (value){
        setState(() { 
          widget.estado = value.toString();
          widget.updateEstado(widget.estado);
        });
      },
    );
  }
}