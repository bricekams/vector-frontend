import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/config/routes.dart';
import 'package:frontend/providers/augment.dart';
import 'package:frontend/providers/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'models/augmentation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();
  Augmentation.registerAdapters();

  final app = MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => AugmentProvider()),
    ],
    child: VectorUI(),
  );

  runApp(app);
}

class VectorUI extends StatelessWidget {
  const VectorUI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Vector 1.0',
      theme: ThemeData.from(
        useMaterial3: true,
        textTheme: GoogleFonts.tekturTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}
