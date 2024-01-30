import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  Style._();

  static const whiteColor = Color(0xffFFFFFF);
  static const blackColor = Color(0xff000000);
  static const blackColor50=Color(0x70000000);
  static const blackColor17=Color(0x17000000);
  static const whiteColor50=Color(0x60FFFFFF);
  static const darkPrimaryColor=Color(0x70453671);
  static const primaryColor=Color(0xFFDAD4EC);
  static const redColor=Color(0xffF20826);
  static const transperntColor=Colors.transparent;


  static const gradient = LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [Color(0x9EFFE9F4), Colors.white],
  );

  static const darkGradient = LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [Color(0x9E74264D), Colors.black],
  );


  static TextStyle boldText(
      {Color color = Style.blackColor,
      double size = 24,
      FontWeight weight = FontWeight.w700}) {
   return GoogleFonts.roboto(color: color, fontSize: size.sp, fontWeight: weight);
  }

  static TextStyle miniText(
      {Color color = Style.blackColor50,
        double size = 10,
        FontWeight weight = FontWeight.w500}) {
   return GoogleFonts.sansita(color: color, fontSize: size.sp, fontWeight: weight);
  }
  static TextStyle normalText(
      {Color color = Style.blackColor,
        double size = 12,
        FontWeight weight = FontWeight.w700}) {
   return GoogleFonts.sansita(color: color, fontSize: size.sp, fontWeight: weight);
  }
}
