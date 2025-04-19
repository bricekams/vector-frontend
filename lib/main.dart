import 'package:flutter/material.dart';
import 'package:frontend/config/routes.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const VectorUI());
}

class VectorUI extends StatelessWidget {
  const VectorUI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      themeMode: ThemeMode.dark,
      title: 'Vector 1.0',
      theme: ThemeData.from(
        useMaterial3: true,
        textTheme: GoogleFonts.tekturTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
      ),
    );
  }
}
