import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomSistemaDeBusca extends StatefulWidget {
  Function (TextEditingController) setController;
  Function () busca;
  Function () sairDaBusca;
  String label;
  CustomSistemaDeBusca({super.key, required this.setController, required this.busca, required this.sairDaBusca, required this.label});

  @override
  State<CustomSistemaDeBusca> createState() => _CustomSistemaDeBuscaState();
}

class _CustomSistemaDeBuscaState extends State<CustomSistemaDeBusca> {
  var buscaController = TextEditingController(text: '');
  late FocusNode _focusNode;

  @override
  initState(){
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) { // DEFINE O FOCO APÓS O FRAME SER RENDERIZADO
      FocusScope.of(context).requestFocus(_focusNode);
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      controller: buscaController,
      onChanged: (value) async {
        await widget.setController(buscaController);
        widget.busca();
      },
      decoration: InputDecoration(
        label: Text(widget.label, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 13)),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
        contentPadding: const EdgeInsets.all(0),
        prefixIcon: const Icon(Icons.search, color: Colors.amber),
        suffixIcon: IconButton(
          icon: const Icon(Icons.close_outlined, color: Colors.red), 
          onPressed: (){
            widget.sairDaBusca();
          },
        )
      ),
      cursorColor: Colors.white,
      style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15),
    );
  }
}