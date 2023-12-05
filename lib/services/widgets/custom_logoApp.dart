import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomLogoApp extends StatefulWidget {
  double fontSizeTitle;
  double fontSizeSubtitle;
  CustomLogoApp({super.key, required this.fontSizeTitle, required this.fontSizeSubtitle});

  @override
  State<CustomLogoApp> createState() => _CustomLogoAppState();
}

class _CustomLogoAppState extends State<CustomLogoApp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
            text: TextSpan(
                text: "Sweet ",
                style: GoogleFonts.monoton(fontSize: widget.fontSizeTitle),
                children: const [
              TextSpan(
                  text: "Cine",
                  style: TextStyle(color: Color.fromARGB(255, 255, 63, 63)))
            ])),
        Text("O lar do inesquecível", style: GoogleFonts.zeyada(fontSize: widget.fontSizeSubtitle, color: Colors.white))
      ],
    );
  }
}
