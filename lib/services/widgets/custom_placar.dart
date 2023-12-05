import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomPlacar extends StatefulWidget {
  String label1;
  int valor1;
  String label2;
  String valor2;
  Function () btn1;
  Function () btn2;
  CustomPlacar({super.key, required this.label1, required this.valor1, required this.btn1, required this.label2, required this.valor2, required this.btn2});

  @override
  State<CustomPlacar> createState() => _CustomPlacarState();
}

class _CustomPlacarState extends State<CustomPlacar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FadeInLeft(
            from: 20,
            child: TextButton(
              onPressed: (){
                widget.btn1();
              }, 
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color.fromARGB(120, 217, 217, 217)),
                padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20))
              ),
              child: Column(
                children: [
                  Text(widget.valor1.toString(), style: GoogleFonts.anton(color: const Color.fromARGB(255, 255, 217, 0), fontSize: 22)),
                  const SizedBox(height: 10),
                  Text(widget.label1, style: GoogleFonts.montserrat(color: Colors.white))
                ],
              )
            ),
          ),
        ),
        Expanded(
          child: FadeInRight(
            from: 20,
            child: TextButton(
              onPressed: (){
                widget.btn2();
              }, 
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color.fromARGB(130, 255, 63, 63)),
                padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20))
              ),
              child: Column(
                children: [
                  Text(widget.valor2, style: GoogleFonts.anton(color: const Color.fromARGB(255, 255, 217, 0), fontSize: 22)),
                  const SizedBox(height: 10),
                  Text(widget.label2, style: GoogleFonts.montserrat(color: Colors.white))
                ],
              )
            ),
          ),
        ),
      ],
    );
  }
}