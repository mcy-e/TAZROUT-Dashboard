//& Imports
import 'package:google_fonts/google_fonts.dart';

//& AppTypography Class
abstract class AppTypography {
  
  //& Display Styles
  static final TextStyle displayXL = GoogleFonts.poppins(
    fontSize: 96.0,
    fontWeight: FontWeight.w700,
    height: 96 / 96,
    letterSpacing: -4.8,
  );
  static final TextStyle displayL = GoogleFonts.poppins(
    fontSize: 30.0,
    fontWeight: FontWeight.w700,
    height: 36 / 30,
    letterSpacing: -0.75,
  );

  //& Heading Styles
  static final TextStyle headingM = GoogleFonts.poppins(
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    height: 28 / 20,
    letterSpacing: -0.5,
  );
  static final TextStyle headingS = GoogleFonts.poppins(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    height: 28 / 18,
    letterSpacing: 0,
  );
  static final TextStyle headingXS = GoogleFonts.poppins(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0,
  );

  //& Body Styles
  static final TextStyle bodyLBold = GoogleFonts.inter(
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: 0,
  );
  static final TextStyle bodyMBold = GoogleFonts.inter(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    height: 26 / 16,
    letterSpacing: 0,
  );
  static final TextStyle bodyMMedium = GoogleFonts.inter(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 26 / 16,
    letterSpacing: 0,
  );
  static final TextStyle bodySBold = GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    height: 22.75 / 14,
    letterSpacing: 0,
  );
  static final TextStyle bodySMedium = GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0,
  );
  static final TextStyle bodySRegular = GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0,
  );

  //& Caption Styles
  static final TextStyle captionBold = GoogleFonts.inter(
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    height: 16 / 12,
    letterSpacing: 1.2,
  );
  static final TextStyle captionSemiBold = GoogleFonts.inter(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0,
  );
  static final TextStyle captionMedium = GoogleFonts.inter(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0,
  );

  //& Label Styles
  static final TextStyle labelXSBold = GoogleFonts.inter(
    fontSize: 10.0,
    fontWeight: FontWeight.w700,
    height: 20 / 10,
    letterSpacing: 0.25,
  );
  static final TextStyle labelXSRegular = GoogleFonts.inter(
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    height: 20 / 10,
    letterSpacing: 0,
  );

  //& Overline Styles
  static final TextStyle overlineS = GoogleFonts.inter(
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    height: 16 / 12,
    letterSpacing: 2.4,
    textBaseline: TextBaseline.alphabetic,
  );
  static final TextStyle overlineXS = GoogleFonts.inter(
    fontSize: 10.0,
    fontWeight: FontWeight.w700,
    height: 20 / 10,
    letterSpacing: 0.5,
    textBaseline: TextBaseline.alphabetic,
  );
}
