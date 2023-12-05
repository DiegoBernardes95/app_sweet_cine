import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TelaDeCarregamento extends StatefulWidget {
  bool mostrarBackground;
  TelaDeCarregamento({super.key, required this.mostrarBackground});

  @override
  State<TelaDeCarregamento> createState() => _TelaDeCarregamentoState();
}

class _TelaDeCarregamentoState extends State<TelaDeCarregamento> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: widget.mostrarBackground 
      ? 
      const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/scratch.png"),
            fit: BoxFit.cover
          ),
          gradient: LinearGradient(
            colors: [Colors.black, Color.fromARGB(255, 15, 26, 32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          )
      ) 
      :
      const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Color.fromARGB(255, 15, 26, 32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        )
      ),
      child: const CircularProgressIndicator(color: Colors.red)
    );
  }
}