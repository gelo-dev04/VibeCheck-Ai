import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class AppColors {
  static const Color softIris = Color(0xFFB4BCFF);
  static const Color mintyGreen = Color(0xFFAEE9D1);
  static const Color dustyRose = Color(0xFFFFB8B8);
  static const Color pastelHoney = Color(0xFFFEE5A5);
  static const Color lilac = Color(0xFFE0C3FC);
  static const Color blueGray = Color(0xFFBDC3D1);
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color sky700 = Color(0xFF0369A1);
  static const Color sky600 = Color(0xFF0284C7);
  static const Color rose500 = Color(0xFFF43F5E);
  static const Color rose600 = Color(0xFFE11D48);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.skyBlue,
        primary: AppColors.skyBlue,
        secondary: AppColors.softIris,
        surface: Colors.white,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          color: AppColors.slate800,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.5,
        ),
        headlineMedium: GoogleFonts.outfit(
          color: AppColors.slate800,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.0,
        ),
        bodyLarge: GoogleFonts.outfit(
          color: AppColors.slate800,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.outfit(
          color: AppColors.slate600,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: GoogleFonts.outfit(
          color: AppColors.slate600,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
          fontSize: 10,
        ),
      ),
    );
  }
}

class GlassDecoration extends BoxDecoration {
  GlassDecoration({
    Color? color,
    BorderRadiusGeometry? borderRadius,
    BoxBorder? border,
  }) : super(
         color: color ?? Colors.white.withValues(alpha: 0.5),
         borderRadius: borderRadius ?? BorderRadius.circular(32),
         border:
             border ??
             Border.all(
               color: Colors.white.withValues(alpha: 0.2),
               width: 1.5,
             ), // white/20
         boxShadow: [
           BoxShadow(
             color: Colors.black.withOpacity(0.05),
             blurRadius: 20,
             offset: const Offset(0, 10),
           ),
         ],
       );
}

class GlassWidget extends StatelessWidget {
  final Widget child;
  final double blur;
  final BorderRadius? borderRadius;
  final Decoration? decoration;

  const GlassWidget({
    super.key,
    required this.child,
    this.blur = 15.0,
    this.borderRadius,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: decoration ?? GlassDecoration(borderRadius: borderRadius),
          child: child,
        ),
      ),
    );
  }
}
