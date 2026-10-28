import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const ink = Color(0xFF16233B); 
const bg = Color(0xFFF3F6FA); 
const teal = Color(0xFF0F8B8D); 
const coral = Color(0xFFFF6F59); 
const sun = Color(0xFFFFC857); 


TextStyle display(double size, {Color color = ink}) =>
    GoogleFonts.bricolageGrotesque(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
      height: 1.1,
    );


   ThemeData buildTheme() {
     return ThemeData(
       useMaterial3: true,
       scaffoldBackgroundColor: bg,
       colorScheme: ColorScheme.fromSeed(seedColor: teal),
     );
   }