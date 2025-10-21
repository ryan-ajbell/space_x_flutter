import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpaceColors {
  static const Color spaceBlack = Color(0xFF070B14);
  static const Color deepBlue = Color(0xFF0D1B2A);
  static const Color accentBlue = Color(0xFF247BFD);
  static const Color accentTeal = Color(0xFF1DD1A1);
  static const Color danger = Color(0xFFFF4D5B);
  static const Color warning = Color(0xFFFFC857);
  static const Color success = Color(0xFF4ADE80);
  static const Color card = Color(0xFF132033);
  static const Color border = Color(0xFF1F2C3F);
}

class SpaceTheme {
  static ThemeData build() {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.orbitronTextTheme(base.textTheme).copyWith(
      titleLarge: GoogleFonts.orbitron(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
      titleMedium: GoogleFonts.orbitron(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
      ),
      bodyMedium: GoogleFonts.robotoMono(fontSize: 14, height: 1.4),
    );
    return base.copyWith(
      scaffoldBackgroundColor: SpaceColors.spaceBlack,
      cardColor: SpaceColors.card,
      colorScheme: ColorScheme.dark(
        primary: SpaceColors.accentBlue,
        secondary: SpaceColors.accentTeal,
        surface: SpaceColors.card,
        error: SpaceColors.danger,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium?.copyWith(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: SpaceColors.card.withValues(alpha: 0.85),
        elevation: 4,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: SpaceColors.border, width: 1),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: SpaceColors.border,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 11),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: SpaceColors.accentBlue,
      ),
    );
  }
}

class StarfieldBackground extends StatefulWidget {
  final Widget child;
  const StarfieldBackground({super.key, required this.child});
  @override
  State<StarfieldBackground> createState() => _StarfieldBackgroundState();
}

class _StarfieldBackgroundState extends State<StarfieldBackground> {
  late final List<_Star> _stars;
  @override
  void initState() {
    super.initState();
    _stars = List.generate(140, (i) => _Star.random());
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StarfieldPainter(_stars),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF050910), Color(0xFF0A1422), Color(0xFF0F2034)],
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double r;
  final double opacity;
  const _Star(this.x, this.y, this.r, this.opacity);
  factory _Star.random() {
    return _Star(_rand(), _rand(), 0.5 + _rand() * 1.3, 0.2 + _rand() * 0.8);
  }
  static double _rand() => (UniqueKey().hashCode % 1000) / 1000.0;
}

class _StarfieldPainter extends CustomPainter {
  final List<_Star> stars;
  _StarfieldPainter(this.stars);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (final s in stars) {
      paint.color = Colors.white.withValues(alpha: s.opacity);
      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height),
        s.r,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) => false;
}
