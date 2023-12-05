import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 5), (){
      Navigator.pushReplacementNamed(context, "Home_Page");
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/popcorn.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Color.fromARGB(127, 0, 0, 0), BlendMode.darken)
          )
        ),
        width: double.infinity,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.transparent,
                Colors.black
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
        
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedTextKit(
                    totalRepeatCount: 1,
                    animatedTexts: [
                      ColorizeAnimatedText(
                        speed: const Duration(milliseconds: 1200),
                        "Sweet", 
                        textStyle: GoogleFonts.monoton(fontSize: 50, color: Colors.white), 
                        colors: [
                          Colors.white,
                          Colors.white,
                          const Color.fromARGB(255, 255, 63, 63),
                          
                        ]
                      ),
                    ]
                  ),
                  const SizedBox(width: 5),
                  AnimatedTextKit(
                    totalRepeatCount: 1,
                    animatedTexts: [
                      ColorizeAnimatedText(
                        speed: const Duration(milliseconds: 2400),
                        "Cine", 
                        textStyle: GoogleFonts.monoton(fontSize: 50, color: const Color.fromARGB(255, 255, 63, 63)), 
                        colors: [
                          const Color.fromARGB(255, 255, 63, 63),
                          const Color.fromARGB(255, 255, 63, 63),
                          Colors.white
                        ]
                      ),
                    ]
                  ),
                ],
              ),
        
              // DefaultTextStyle(
              //   style: GoogleFonts.zeyada(color: Colors.white, fontSize: 30),
              //   child: AnimatedTextKit(
              //     totalRepeatCount: 1,
                  
              //     animatedTexts: [
              //       TypewriterAnimatedText("O lar do inesquecível!", speed: const Duration(milliseconds: 150), cursor: ""),
              //     ]
              //   ),
              // )
        
            ],
          ),
        ),
      ),
    );
  }
}