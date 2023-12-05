import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomBtnAdd extends StatefulWidget {
  String labelBtn;
  Function () addFilmes;
  CustomBtnAdd({super.key, required this.labelBtn, required this.addFilmes});

  @override
  State<CustomBtnAdd> createState() => _CustomBtnAddState();
}

class _CustomBtnAddState extends State<CustomBtnAdd> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.addFilmes();
      },
      child: Container(
        width: 180,
        height: 260,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(10)
        ),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(60)
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.add, size: 25)
            ),
            const SizedBox(height: 13),
            Text(widget.labelBtn, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}