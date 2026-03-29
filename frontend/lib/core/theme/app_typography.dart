//& Imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//& Typography Definitions
abstract class AppTypography {
  static final TextStyle headingXS = GoogleFonts.poppins(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle headingS = GoogleFonts.poppins(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle headingM = GoogleFonts.poppins(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle displayL = GoogleFonts.poppins(
    fontSize: 48.0,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle bodySRegular = GoogleFonts.lato(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle bodySMedium = GoogleFonts.lato(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle bodySBold = GoogleFonts.lato(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle bodyMBold = GoogleFonts.lato(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle overlineS = GoogleFonts.lato(
    fontSize: 12.0,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.2,
  );

  static final TextStyle overlineXS = GoogleFonts.lato(
    fontSize: 10.0,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.0,
  );

  static final TextStyle captionMedium = GoogleFonts.lato(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle labelXSRegular = GoogleFonts.lato(
    fontSize: 11.0,
    fontWeight: FontWeight.normal,
  );
  
  static final TextStyle captionBold = GoogleFonts.lato(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
  );
}
