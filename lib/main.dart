import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';
import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Pre-warm the Google Fonts cache so they're available before the first frame.
  _prewarmFonts();
  runApp(const VisiaxxApp());
}

/// Triggers font descriptor resolution early so they are cached by the
/// time the first frame paints. This eliminates the "flash of fallback font"
/// that happens when GoogleFonts builds text styles lazily.
void _prewarmFonts() {
  // Touch the text styles to trigger the font fetch.
  // The GoogleFonts package will start downloading/caching immediately.
  GoogleFonts.syne(fontWeight: FontWeight.w800);
  GoogleFonts.dmSans(fontWeight: FontWeight.w400);
  GoogleFonts.dmSans(fontWeight: FontWeight.w500);
  GoogleFonts.dmSans(fontWeight: FontWeight.w700);
}

class VisiaxxApp extends StatelessWidget {
  const VisiaxxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visiaxx — Vision Care, Reimagined',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const _PreloadGate(),
    );
  }
}

/// A loading gate that precaches the app logo image and ensures fonts
/// are resolved before revealing the HomePage. This prevents the brief
/// "flash" of unstyled text / missing logo that the user sees after
/// the HTML splash screen fades away.
class _PreloadGate extends StatefulWidget {
  const _PreloadGate();

  @override
  State<_PreloadGate> createState() => _PreloadGateState();
}

class _PreloadGateState extends State<_PreloadGate> {
  bool _ready = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_ready) {
      _precache();
    }
  }

  Future<void> _precache() async {
    // Precache the logo image so it's decoded and ready
    await precacheImage(
      const AssetImage('lib/assets/images/app_logo.png'),
      context,
    );

    // Give GoogleFonts one extra frame to finalize any pending HTTP loads
    await Future.delayed(const Duration(milliseconds: 50));

    if (mounted) {
      setState(() => _ready = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // While precaching, show nothing (the HTML splash screen is still visible).
    // The background color matches the app background so there is zero flicker.
    if (!_ready) {
      return const SizedBox.shrink();
    }
    return const HomePage();
  }
}
